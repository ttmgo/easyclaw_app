# GitHub Actions 自动构建 APK

本项目已配置 GitHub Actions 自动构建 Android APK。

## 🚀 如何使用

### 方法 1：手动触发构建

1. 打开 GitHub 仓库页面
2. 点击 **Actions** 标签
3. 选择 **Build Android APK** 工作流
4. 点击 **Run workflow** 按钮
5. 选择构建类型（Debug 或 Release）
6. 点击 **Run workflow**

### 方法 2：自动触发

- **Push 到 main/master 分支**: 自动构建 Debug APK
- **创建标签 (v*)**: 自动构建 Release APK 并创建 GitHub Release
- **Pull Request**: 自动构建 Debug APK 用于测试

### 方法 3：本地推送到 GitHub 自动构建

```bash
git add .
git commit -m "更新代码"
git push origin main
```

推送后，GitHub Actions 会自动开始构建。

---

## 📥 下载 APK

### 方式 1：从 Actions 下载

1. 打开 GitHub 仓库页面
2. 点击 **Actions** 标签
3. 点击最新的成功构建
4. 在 **Artifacts** 部分下载 APK

### 方式 2：从 Releases 下载

1. 打开 GitHub 仓库页面
2. 点击 **Releases** 标签
3. 下载最新版本的 APK

---

## ⚙️ 工作流配置说明

### 触发条件

| 事件 | 触发行为 |
|------|----------|
| `push` 到 main/master | 自动构建 Debug APK |
| `push` 到 develop | 自动构建 Debug APK |
| 推送标签 `v*` | 构建 Release APK + 创建 Release |
| Pull Request | 构建 Debug APK 用于测试 |
| 手动触发 | 可选择 Debug 或 Release |

### 构建环境

- **OS**: Ubuntu Latest
- **Java**: OpenJDK 17 (Temurin)
- **Flutter**: 3.24.3 (Stable)

### 输出文件

| 构建类型 | 输出路径 | Artifact 名称 |
|----------|----------|---------------|
| Debug | `build/app/outputs/flutter-apk/app-debug.apk` | app-debug |
| Release | `build/app/outputs/flutter-apk/app-release.apk` | app-release |

---

## 🔧 首次设置

### 1. 创建 GitHub 仓库

如果你的代码还没有推送到 GitHub：

```bash
# 初始化 Git 仓库
git init

# 添加远程仓库（替换为你的仓库地址）
git remote add origin https://github.com/yourusername/easyclaw_app.git

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit"

# 推送到 GitHub
git push -u origin main
```

### 2. 验证工作流

推送后，打开 GitHub 仓库页面，点击 **Actions** 标签，应该能看到正在运行的工作流。

---

## 📋 构建状态

[![Build Android APK](https://github.com/yourusername/easyclaw_app/actions/workflows/build_apk.yml/badge.svg)](https://github.com/yourusername/easyclaw_app/actions/workflows/build_apk.yml)

（将 `yourusername` 替换为你的 GitHub 用户名）

---

## 📝 注意事项

1. **Artifact 保留期**: 构建的 APK 默认保留 30 天
2. **Release APK**: 只有打了标签（如 `v1.0.0`）才会构建 Release 版本
3. **构建时间**: 首次构建可能需要 10-15 分钟（需要下载依赖），后续构建约 5-8 分钟

---

## 🔥 常见问题

### Q: 如何修改 Flutter 版本？

编辑 `.github/workflows/build_apk.yml`：

```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.24.3'  # 修改这里
    channel: 'stable'
```

### Q: 如何修改 Java 版本？

编辑 `.github/workflows/build_apk.yml`：

```yaml
- name: Set up JDK 17
  uses: actions/setup-java@v4
  with:
    java-version: '17'  # 修改这里
    distribution: 'temurin'
```

### Q: 构建失败了怎么办？

1. 点击失败的 workflow run
2. 查看失败的 job 日志
3. 根据错误信息修复代码或配置
4. 重新推送代码触发构建

---

## 📚 相关链接

- [GitHub Actions 文档](https://docs.github.com/cn/actions)
- [Flutter 构建文档](https://docs.flutter.dev/deployment/cd)
- [Artifact 下载指南](https://docs.github.com/cn/actions/managing-workflow-runs/downloading-workflow-artifacts)
