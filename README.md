# vlc_player

VLC Player Plugin

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/to/develop-plugins),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## MobileVLCKit 4.x

```shell

git clone https://code.videolan.org/videolan/VLCKit.git
cd VLCKit
git checkout 4.0
./compileAndBuildMobileVLCKit.sh
```

output: build/MobileVLCKit.framework

将 MobileVLCKit.framework 拖入 Flutter 项目的 ios/Runner/Frameworks/
创建目录（如果没有）：

```mkdir -p ios/Runner/Frameworks```

拖入 MobileVLCKit.framework，并勾选 Embed & Sign

在 ios/Runner.xcodeproj 中设置：

Framework Search Paths 添加：

javascript
Copy
Edit
$(PROJECT_DIR)/Runner/Frameworks