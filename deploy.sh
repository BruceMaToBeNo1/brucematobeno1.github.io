#!/bin/bash

# Hugo 博客部署脚本
# 使用方法: ./deploy.sh "提交信息"

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查是否在正确的目录
if [ ! -f "config.yaml" ]; then
    print_error "请在 Hugo 项目根目录运行此脚本"
    exit 1
fi

# 获取提交信息
COMMIT_MSG=${1:-"Update blog content"}

print_status "开始部署博客..."

# 1. 检查 Git 状态
print_status "检查 Git 状态..."
git status

# 2. 添加所有更改到 Git
print_status "添加文件到 Git..."
git add .

# 3. 检查是否有更改需要提交
if git diff --staged --quiet; then
    print_warning "没有检测到更改，跳过提交步骤"
else
    # 4. 提交更改
    print_status "提交更改: $COMMIT_MSG"
    git commit -m "$COMMIT_MSG"
fi

# 5. 推送到远程仓库
print_status "推送到 GitHub..."
git push origin main

# 6. 等待 GitHub Actions 完成
print_status "代码已推送到 GitHub"
print_status "GitHub Actions 将自动构建和部署网站"
print_status "请访问以下链接查看部署状态:"
echo "https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]\([^/]*\/[^.]*\).*/\1/')/actions
