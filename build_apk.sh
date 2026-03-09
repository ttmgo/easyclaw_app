#!/bin/bash
# EasyClaw APK 构建脚本
# 使用方法: ./build_apk.sh

set -e

echo "═══════════════════════════════════════════"
echo "  EasyClaw Android APK 构建脚本"
echo "═══════════════════════════════════════════"
echo ""

# 设置 Java 环境
export JAVA_HOME="D:/Program Files (x86)/Android/jbr"
export PATH="$JAVA_HOME/bin:$PATH"

echo "✓ Java 环境已设置"
echo "  JAVA_HOME: $JAVA_HOME"
echo ""

# 进入项目目录
cd "$(dirname "$0")"

echo "📦 开始构建 Release APK..."
echo ""

# 构建 APK
flutter build apk --release

echo ""
echo "═══════════════════════════════════════════"
echo "  构建完成!"
echo "═══════════════════════════════════════════"
echo ""
echo "APK 文件位置:"
echo "  build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "文件大小:"
ls -lh build/app/outputs/flutter-apk/app-release.apk 2>/dev/null || echo "  (文件未找到)"
echo ""
echo "安装到设备:"
echo "  flutter install"
echo ""
