#!/bin/bash
# check-env.sh - OpenClaw 环境检查脚本

set -e

echo "=== OpenClaw 环境检查 ==="
echo ""

# Python 版本
echo "1. Python 版本:"
python3 --version

# Node.js 版本
echo ""
echo "2. Node.js 版本:"
node --version

# Git 版本
echo ""
echo "3. Git 版本:"
git --version

# jq 版本
echo ""
echo "4. jq 版本:"
jq --version

# GPG 版本
echo ""
echo "5. GPG 版本:"
gpg --version | head -1

# OpenClaw 版本
echo ""
echo "6. OpenClaw 版本:"
openclaw --version 2>/dev/null || echo "OpenClaw 未安装"

# clawhub 版本
echo ""
echo "7. clawhub 版本:"
clawhub --cli-version 2>/dev/null || echo "clawhub 未安装"

# 环境变量
echo ""
echo "8. 环境变量:"
echo "   PATH: $PATH"
echo "   USER: $USER"

echo ""
echo "=== 检查完成 ==="

# 检查 Git 配置
echo ""
echo "=== Git 配置检查 ==="
git config --global user.name
git config --global user.email
git config --global commit.gpgsign 2>/dev/null || echo "Git GPG 签名：未配置"

# 检查 GitHub CLI
echo ""
echo "=== GitHub CLI 状态 ==="
gh auth status 2>/dev/null || echo "GitHub CLI 未登录"

echo ""
echo "所有检查完成！✅"