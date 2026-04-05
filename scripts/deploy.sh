#!/bin/bash
# deploy.sh - OpenClaw 一键部署脚本

set -e

echo "================================"
echo "   OpenClaw 一键部署脚本"
echo "================================"
echo ""

# 1. 检查依赖
echo "1. 检查依赖..."
check_dep() {
    if ! command -v $1 &> /dev/null; then
        echo "❌ $1 未安装，请先安装"
        exit 1
    fi
}

check_dep python3
check_dep git
check_dep jq

echo "✅ 所有依赖已安装"
echo ""

# 2. 检查 Python 版本
echo "2. 检查 Python 版本..."
PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
if [[ $(echo "$PYTHON_VERSION" | cut -d'.' -f1) -lt 3 ]] || \
   [[ $(echo "$PYTHON_VERSION" | cut -d'.' -f2) -lt 10 ]]; then
    echo "❌ Python 版本需 >= 3.10"
    exit 1
fi
echo "✅ Python $PYTHON_VERSION"
echo ""

# 3. 检查 Node.js 版本
echo "3. 检查 Node.js 版本..."
NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
    echo "❌ Node.js 版本需 >= 20"
    exit 1
fi
echo "✅ Node.js $(node --version)"
echo ""

# 4. 检查 Homebrew
echo "4. 检查 Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "⚠️  Homebrew 未安装，部分工具可能无法安装"
else
    echo "✅ Homebrew 已安装"
fi
echo ""

# 5. 询问用户部署方式
echo "5. 选择部署方式:"
echo "   1) 本地 Homebrew (推荐)"
echo "   2) Docker 容器化"
echo "   3) 云服务器"
echo ""
read -p "请选择 (1-3): [1] " DEPLOY_METHOD
DEPLOY_METHOD=${DEPLOY_METHOD:-1}

# 6. 执行安装
case $DEPLOY_METHOD in
    1)
        echo "6. 安装 OpenClaw (Homebrew)..."
        brew install openclaw
        echo "✅ OpenClaw 安装完成"
        ;;
    2)
        echo "6. 安装 OpenClaw (Docker)..."
        if command -v docker &> /dev/null; then
            docker pull openclaw/openclaw:latest
            docker run -d --name openclaw -v $HOME/.openclaw:/openclaw openclaw/openclaw
            echo "✅ OpenClaw Docker 容器启动完成"
        else
            echo "❌ Docker 未安装，请安装后重试"
            exit 1
        fi
        ;;
    3)
        echo "6. 选择云服务器..."
        echo "   推荐使用：AWS EC2 / DigitalOcean / 阿里云"
        echo "   最低配置：2 核 4GB"
        echo "   后续需要自行配置 SSH 和防火墙"
        read -p "是否继续？[y/N] " CONTINUE
        if [[ $CONTINUE != "y" && $CONTINUE != "Y" ]]; then
            echo "❌ 已取消部署"
            exit 0
        fi
        echo "✅ 云服务器部署说明已生成，请查看 docs/01-快速开始/02-部署方式对比.md"
        ;;
    *)
        echo "❌ 无效的选择"
        exit 1
        ;;
esac

# 7. 安装基础技能
echo ""
echo "7. 安装基础技能..."
echo "   已安装技能："
clawhub install gog
clawhub install github
clawhub install summarize
echo "✅ 基础技能安装完成"
echo ""

# 8. 配置 Git
echo "8. 配置 Git..."
echo "   请配置你的 GitHub 账户："
echo "   git config --global user.name \"你的名字\""
echo "   git config --global user.email \"your@email.com\""
echo ""
read -p "是否继续？[y/N] " CONFIGURE_GIT
if [[ $CONFIGURE_GIT == "y" || $CONFIGURE_GIT == "Y" ]]; then
    git config --global user.name $(git config user.name 2>/dev/null || echo "未设置")
    git config --global user.email $(git config user.email 2>/dev/null || echo "未设置")
    echo "✅ Git 配置完成"
else
    echo "⚠️  跳过 Git 配置"
fi
echo ""

# 9. 配置 GPG 签名（可选）
echo "9. 配置 GPG 签名（可选）..."
read -p "是否配置 GPG 签名？[y/N] " CONFIGURE_GPG
if [[ $CONFIGURE_GPG == "y" || $CONFIGURE_GPG == "Y" ]]; then
    echo "   请按以下步骤配置 GPG:"
    echo "   1. 访问：https://github.com/settings/gpg-keys"
    echo "   2. 生成密钥：gpg --full-generate-key"
    echo "   3. 添加公钥到 GitHub"
    echo "   4. 配置 Git：git config --global user.signingkey YOUR_KEY_ID"
    read -p "完成配置后按回车继续..."
    echo "✅ GPG 配置说明已提供"
else
    echo "⚠️  跳过 GPG 签名"
fi
echo ""

# 10. 测试安装
echo "11. 测试安装..."
echo "   检查 OpenClaw 版本..."
openclaw --version
echo ""

echo "================================"
echo "   ✅ 部署完成!"
echo "================================"
echo ""
echo "下一步："
echo "1. 阅读文档：docs/01-快速开始/"
echo "2. 登录 clawhub: clawhub login"
echo "3. 开始使用：openclaw --help"
echo ""
echo "遇到问题？查看避坑指南："
echo "   docs/避坑指南/01-常见问题.md"
echo ""