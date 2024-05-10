import {
  EventChannel,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  AbilityAware,
  AbilityPluginBinding,
} from '@ohos/flutter_ohos';
import { EventSink, StreamHandler, } from '@ohos/flutter_ohos/src/main/ets/plugin/common/EventChannel';
import { audio } from '@kit.AudioKit';

/** AudioStreamerPlugin **/
export default class AudioStreamerPlugin implements FlutterPlugin, MethodCallHandler, StreamHandler {
  private channel: MethodChannel | null = null;
  private eventChannel: EventChannel | null = null;
  // 16-bit PCM
  private maxAmplitude: number = 32767;
  private audioCapturer: audio.AudioCapturer | null = null;
  private eventSink: EventSink | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return "AudioStreamerPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    let messenger = binding.getBinaryMessenger();

    this.channel = new MethodChannel(messenger, "audio_streamer.methodChannel");
    this.channel.setMethodCallHandler(this)

    this.eventChannel = new EventChannel(messenger, "audio_streamer.eventChannel");
    this.eventChannel.setStreamHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "getSampleRate") {
      this.audioCapturer?.getStreamInfo().then((streamInfo) => {
        result.success(streamInfo.samplingRate)
      })
    } else {
      result.notImplemented()
    }
  }

  onListen(args: Map<String, ESObject>, events: EventSink): void {
    this.eventSink = events;
    let sampleRate: number = parseInt(`${args.get("sampleRate")}`)
    if (sampleRate < 8000 || sampleRate > 96000) {
      events!!.error(
        "SampleRateError",
        `Sample rate must be between 8000 and 96000, but got ${sampleRate}`,
        null
      );
      return;
    }
    this.startRecording(sampleRate)
  }

  onCancel(args: ESObject): void {
    this.eventSink = null;
    this.stopRecording()
  }

  async startRecording(sampleRate: number) {
    let audioStreamInfo: audio.AudioStreamInfo = {
      samplingRate: sampleRate,
      channels: audio.AudioChannel.CHANNEL_1,
      sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
      encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW,
    }
    let audioCapturerInfo: audio.AudioCapturerInfo = {
      source: audio.SourceType.SOURCE_TYPE_MIC,
      capturerFlags: 0, // 音频采集器标志
    }
    this.audioCapturer = await audio.createAudioCapturer({
      streamInfo: audioStreamInfo,
      capturerInfo: audioCapturerInfo,
    })

    // 监听音频数据
    this.audioCapturer.on("readData", (buffer: ArrayBuffer) => {
      let audioDataView = new Int16Array(buffer);
      let floatChannelData: number[] = new Array(audioDataView.length);

      // 转换为浮点数
      for(let i = 0; i < audioDataView.length; i++) {
        floatChannelData[i] = parseFloat(`${audioDataView[i] / this.maxAmplitude}`);
      }

      this.eventSink?.success(floatChannelData);
    })

    // 开始采集音频
    this.audioCapturer.start()
  }

  async stopRecording() {
    if (this.audioCapturer != null) {
      await this.audioCapturer.stop()
      await this.audioCapturer.release()
      this.audioCapturer = null
    }
  }
}