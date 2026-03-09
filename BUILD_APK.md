# EasyClaw Android APK 构建指南

## 📋 环境要求

- Flutter SDK 3.24.3+
- Android SDK 34+
- Java 17+ (Android Studio 内置的 JBR)

## 🔧 构建步骤

### 方法一：使用 Flutter 命令 (推荐)

1. **设置 Java 环境变量**

   在 PowerShell 中运行：
   ```powershell
   $env:JAVA_HOME = "D:\Program Files (x86)\Android\jbr"
   $env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
   ```

2. **构建 Release APK**

   ```bash
   flutter build apk --release
   ```

3. **APK 输出位置**

   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

### 方法二：使用提供的构建脚本

在 MSYS2/Git Bash 中运行：

```bash
./build_apk.sh
```

### 方法三：使用 Android Studio

1. 打开 Android Studio
2. 选择 `Build` > `Flutter` > `Build APK`
3. 或者在 Terminal 中运行 `flutter build apk --release`

## 📱 安装 APK

### 安装到已连接的设备

```bash
flutter install
```

### 手动安装

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 🔍 常见问题

### 1. JAVA_HOME 未设置

**错误**: `JAVA_HOME is not set and no 'java' command could be found`

**解决**:
```powershell
$env:JAVA_HOME = "D:\Program Files (x86)\Android\jbr"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
```

### 2. Gradle Java 版本不匹配

**错误**: `org.gradle.java.home Gradle property is invalid`

**解决**: 已修复 `android/gradle.properties` 中的配置。

### 3. 构建超时

Release 构建可能需要 5-10 分钟，取决于电脑性能。请耐心等待。

## 📦 APK 信息

| 属性 | 值 |
|------|-----|
| 包名 | com.easyclaw.easyclaw_app |
| 版本 | 1.0.0 |
| 版本号 | 1 |
| 目标平台 | Android 34+ |

## 🚀 发布到应用商店

如需发布到 Google Play 或其他应用商店，需要：

1. 生成正式的签名密钥：
   ```bash
   keytool -genkey -v -keystore easyclaw-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias easyclaw
   ```

2. 配置 `android/app/build.gradle` 中的签名配置

3. 构建 App Bundle：
   ```bash
   flutter build appbundle --release
   ```

## 📝 备注

- 当前构建使用 debug 签名配置，适合测试
- 正式发布前需要配置正式签名
- 构建过程中需要下载依赖，首次构建可能较慢
