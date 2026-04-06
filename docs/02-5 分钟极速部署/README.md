# 02-5 分钟极速部署

## 章节内容

### 2.1 一行命令安装

#### macOS - Homebrew 安装
```bash
brew install openclaw
```

#### Linux - Ubuntu/Debian 安装
```bash
curl -fsSL https://get.openclaw.ai | bash
```

#### Windows - WSL2 安装
```bash
wsl --install
# 在 WSL2 中执行 Linux 安装步骤
```

### 2.2 初始化向导配置

#### 2.2.1 模型密钥配置
- 本地模型密钥
- 云服务 API 密钥

#### 2.2.2 基础设置
- Gateway 配置
- 网络端口设置

### 2.3 验证安装

#### 检查服务状态
```bash
openclaw status
```

#### 首次启动测试
```bash
openclaw test
```

---

**最后更新：** 2026-04-06  
**维护者：** kekolike-sudo
