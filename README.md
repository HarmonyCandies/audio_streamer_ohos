# audio_streamer_ohos

[![pub package](https://img.shields.io/pub/v/audio_streamer_ohos.svg)](https://pub.dartlang.org/packages/audio_streamer_ohos) [![GitHub stars](https://img.shields.io/github/stars/harmonycandies/audio_streamer_ohos)](https://github.com/harmonycandies/audio_streamer_ohos/stargazers) [![GitHub forks](https://img.shields.io/github/forks/harmonycandies/audio_streamer_ohos)](https://github.com/harmonycandies/audio_streamer_ohos/network) [![GitHub license](https://img.shields.io/github/license/harmonycandies/audio_streamer_ohos)](https://github.com/harmonycandies/audio_streamer_ohos/blob/master/LICENSE) [![GitHub issues](https://img.shields.io/github/issues/harmonycandies/audio_streamer_ohos)](https://github.com/harmonycandies/audio_streamer_ohos/issues) ![HarmonyCandies QQ 群](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fharmonycandies%2F.github%2Frefs%2Fheads%2Fmain%2Fdata.yml&query=%24.qq_group_number&label=QQ%E7%BE%A4&logo=qq&color=1DACE8)

Streaming of Pulse-code modulation (PCM) audio from OpenHarmony

The OpenHarmony implementation of the [audio_streamer](https://pub.dev/packages/audio_streamer)

[audio_streamer](https://pub.dev/packages/audio_streamer) 在 OpenHarmony 平台上的实现

## Usage (使用方法)

```pubspec
dependencies:
  audio_streamer: 4.1.1
  audio_streamer_ohos: 0.0.2
```

refer to [audio_streamer](https://pub.dev/packages/audio_streamer) for more details

更多细节请参考 [audio_streamer](https://pub.dev/packages/audio_streamer)

## Permissions (权限)

Add `ohos.permission.MICROPHONE` to your OpenHarmony project's `module.json` file.

在 OpenHarmony 项目的 `module.json` 文件中添加 `ohos.permission.MICROPHONE` 权限

```json
{
  "module": {
    "requestPermissions": [
      {
        "name": "ohos.permission.MICROPHONE",
        "reason": "Microphone permission is required to record audio."
      }
    ]
  }
}
```
