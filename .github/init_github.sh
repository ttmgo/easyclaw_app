#!/bin/bash
# EasyClaw GitHub 初始化脚本
# 用于初始化 Git 仓库并推送到 GitHub

echo "═══════════════════════════════════════════"
echo "  EasyClaw GitHub 初始化脚本"
echo "═══════════════════════════════════════════"
echo ""

# 检查是否在正确的目录
cd "$(dirname "$0")"

# 检查 Git 是否安装
if ! command -v git &> /dev/null; then
    echo "❌ 错误: Git 未安装"
    echo "请先安装 Git: https://git-scm.com/downloads"
    exit 1
fi

echo "✓ Git 已安装"

# 检查是否已初始化 Git
if [ -d ".git" ]; then
    echo "✓ Git 仓库已初始化"
else
    echo "📦 初始化 Git 仓库..."
    git init
    echo "✓ Git 仓库初始化完成"
fi

# 检查远程仓库
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")

if [ -z "$REMOTE_URL" ]; then
    echo ""
    echo "⚠️  未配置远程仓库"
    echo ""
    echo "请在 GitHub 上创建一个新仓库，然后输入仓库地址"
    echo "例如: https://github.com/username/easyclaw_app.git"
    echo ""
    read -p "请输入 GitHub 仓库地址: " REPO_URL
    
    if [ -z "$REPO_URL" ]; then
        echo "❌ 错误: 仓库地址不能为空"
        exit 1
    fi
    
    git remote add origin "$REPO_URL"
    echo "✓ 远程仓库已添加: $REPO_URL"
else
    echo "✓ 远程仓库已配置: $REMOTE_URL"
fi

echo ""
echo "📤 添加文件到 Git..."
git add .

# 检查是否有变更要提交
if git diff --cached --quiet; then
    echo "⚠️  没有要提交的变更"
else
    echo "💾 提交变更..."
    git commit -m "Initial commit: EasyClaw App with GitHub Actions"
    echo "✓ 变更已提交"
fi

echo ""
echo "🚀 推送到 GitHub..."
git push -u origin main 2>/dev/null || git push -u origin master 2>/dev/null || echo "⚠️  推送失败，请手动执行: git push -u origin main"

echo ""
echo "═══════════════════════════════════════════"
echo "  初始化完成！"
echo "═══════════════════════════════════════════"
echo ""
echo "下一步:"
echo "1. 打开 GitHub 仓库页面"
echo "2. 点击 'Actions' 标签"
echo "3. 等待构建完成"
echo "4. 下载 APK"
echo ""
echo "或者手动触发构建:"
echo "  1. 进入 Actions 页面"
echo "  2. 选择 'Build Android APK'"
echo "  3. 点击 'Run workflow'"
echo ""
