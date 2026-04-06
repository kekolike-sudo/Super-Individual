# 02-5 分钟极速部署

> **跨平台支持** - macOS / Linux / Windows (WSL2)  
> **最后更新：** 2026-04-06  
> **维护者：** kekolike-sudo

---

## 📋 平台选择指南

| 平台 | 安装方式 | 推荐度 | 适用场景 |
|------|-------|------|--|
| **macOS** | Homebrew | ⭐⭐⭐⭐⭐ | 桌面用户，M 系列芯片 |
| **Linux** | 安装脚本 | ⭐⭐⭐⭐⭐ | 服务器/开发环境 |
| **Windows** | WSL2 | ⭐⭐⭐⭐ | 需要 Windows 桌面 |

**选择建议：**
- 🍎 **macOS 用户** - 直接使用 Homebrew（最优体验）
- 🐧 **Linux 用户** - 使用官方安装脚本（原生支持）
- 🪟 **Windows 用户** - 推荐 WSL2 + Ubuntu（稳定可靠）

---

## 🍎 macOS - Homebrew 安装

### 安装步骤

#### 1️⃣ 检查 Homebrew
```bash
# 确认 Homebrew 已安装
brew --version

# 如未安装，先执行
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 2️⃣ 安装 OpenClaw
```bash
# 安装 OpenClaw
brew install openclaw

# 查看版本
openclaw --version
```

#### 3️⃣ 验证安装
```bash
# 检查依赖
brew doctor

# 检查端口
lsof -i :8080

# 首次测试
openclaw test
```

**系统要求：**
- ✅ macOS 12.0+ (Intel / M 系列芯片)
- ✅ Homebrew 已安装
- ✅ 网络连接

**优势：**
- ⭐⭐⭐⭐⭐ 官方原生支持
- ⭐⭐⭐⭐⭐ M 系列芯片优化
- ⭐⭐⭐⭐⭐ 自动更新机制
- ⭐⭐⭐⭐⭐ 依赖管理完善

---

## 🐧 Linux - Ubuntu/Debian 安装

### 安装步骤

#### 1️⃣ 更新系统
```bash
# 更新包列表
sudo apt update && sudo apt upgrade -y
```

#### 2️⃣ 安装依赖
```bash
# 安装必要依赖
sudo apt install -y python3.10 curl jq git

# 确认版本
python3 --version
```

#### 3️⃣ 执行安装脚本
```bash
# 从官网下载并执行安装脚本
curl -fsSL https://get.openclaw.ai | bash

# 按提示完成配置
```

#### 4️⃣ 验证安装
```bash
# 检查版本
openclaw --version

# 检查服务状态
openclaw status

# 检查系统依赖
systemctl status openclaw
```

**系统要求：**
- ✅ Ubuntu 20.04+ / Debian 11+
- ✅ Python 3.10+
- ✅ 网络连接
- ✅ sudo 权限

**优势：**
- ⭐⭐⭐⭐⭐ 原生支持
- ⭐⭐⭐⭐⭐ 服务器部署友好
- ⭐⭐⭐⭐⭐ 资源占用低
- ⭐⭐⭐⭐⭐ 完全可定制

**注意事项：**
- ⚠️ 需要 `sudo` 权限
- ⚠️ 确保端口 8080 开放
- ⚠️ 防火墙需允许相应端口

---

## 🪟 Windows - WSL2 安装

### 为什么选择 WSL2？
- ✅ 完整的 Linux 环境
- ✅ 性能接近原生
- ✅ 可以访问 Windows 文件
- ✅ 适合 Windows 桌面用户

### 安装步骤

#### 1️⃣ 安装 WSL2
```powershell
# 以管理员身份运行 PowerShell
# 启用 WSL2

# 方法 1：一键安装（推荐 Windows 11）
wsl --install

# 方法 2：手动安装
wsl --install -d Ubuntu-20.04

# 重启电脑
Restart-Computer
```

#### 2️⃣ 设置 WSL2 版本
```bash
# 重启后打开 Ubuntu，检查 WSL 版本
wsl -l -v

# 设置默认版本为 WSL2
wsl --set-version Ubuntu-20.04 2
```

#### 3️⃣ 执行 Linux 安装
```bash
# 在 WSL2 Ubuntu 中执行 Linux 安装步骤
# 1. 更新系统
sudo apt update && sudo apt upgrade -y

# 2. 安装依赖
sudo apt install -y python3.10 curl jq git

# 3. 安装 OpenClaw
curl -fsSL https://get.openclaw.ai | bash

# 4. 验证安装
openclaw --version
```

#### 4️⃣ 配置 Windows 文件访问
```bash
# WSL2 中访问 Windows 文件
# /mnt/c/Users/YourName/ 对应当前 Windows 用户目录

# 设置工作目录
openclaw workdir set /mnt/c/Users/YourName/Documents/OpenClaw
```

**系统要求：**
- ✅ Windows 10 2004+ / Windows 11
- ✅ WSL2 已启用
- ✅ 管理员权限
- ✅ 64 位系统

**优势：**
- ⭐⭐⭐⭐⭐ 完整的 Linux 环境
- ⭐⭐⭐⭐ 性能接近原生
- ⭐⭐⭐⭐ 保持 Windows 桌面
- ⭐⭐⭐⭐ 文件访问方便

**注意事项：**
- ⚠️ 首次设置需要重启
- ⚠️ 文件路径格式转换
- ⚠️ 部分工具在 WSL2 中性能略有差异

**文件路径映射：**
```
Windows 路径                    WSL2 路径
C:\Users\YourName              /mnt/c/Users/YourName
C:\Users\YourName\Documents    /mnt/c/Users/YourName/Documents
```

---

## 🔄 跨平台常见问题

### Q1: macOS Gatekeeper 拦截怎么办？
**症状：** 提示 "无法打开，因为无法验证开发者"

**解决方案：**
```bash
# 方法 1：系统设置允许
# 系统偏好设置 → 安全性与隐私 → 打开任意应用

# 方法 2：使用 sudo
sudo xattr -d com.apple.quarantine $(which openclaw)
```

### Q2: Windows WSL2 文件路径问题？
**问题：** 无法访问 Windows 文件 或 权限不足

**解决方案：**
```bash
# 访问 Windows 文件：/mnt/c/...
# 建议工作目录放在 WSL2 内部，性能更好

# 示例：
openclaw workdir set ~/OpenClaw  # WSL2 内部
```

### Q3: 不同平台性能差异？
- **macOS M 系列：** 最优（原生 ARM 支持）
- **Linux：** 优秀（x86/ARM 原生）
- **Windows WSL2：** 良好（接近原生，略低 5-10%）

### Q4: 文件编码问题？
- **所有平台：** 统一使用 UTF-8 编码
- **Git 配置：**
```bash
git config --global core.autocrlf false
git config --global core.filemode true
```

### Q5: 备份策略？
- **macOS:** Time Machine 自动备份
- **Linux:** rsync + cron 定时备份
- **Windows:** OneDrive 同步 或 WSL2 数据导出

---

## 📚 下一步

**安装完成后，建议立即：**
1. ✅ 运行首次测试：`openclaw test`
2. ✅ 配置 API 密钥：`openclaw config set`
3. ✅ 阅读基础命令：查看 `docs/05-基础命令速查/`
4. ✅ 开始第一条指令：尝试发送简单命令

---

**平台覆盖：** macOS / Linux / Windows (WSL2)  
**版本：** 2.0  
**最后更新：** 2026-04-06
