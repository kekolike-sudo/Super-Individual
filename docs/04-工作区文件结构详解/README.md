# 04-工作区文件结构详解

> **跨平台支持** - macOS / Linux / Windows (WSL2)  
> **最后更新：** 2026-04-06  
> **维护者：** kekolike-sudo

---

## 🎯 了解 OpenClaw 的工作区

工作区是 OpenClaw 的**核心配置目录**，包含定义 AI 人格、技能配置和记忆系统的所有文件。

### 工作区位置

| 平台 | 默认路径 | 说明 |
|------|-------|--|
| **macOS** | `~/Library/Application Support/OpenClaw/workspace` | 用户库目录 |
| **Linux** | `~/.config/openclaw/workspace` | 配置目录 |
| **Windows (WSL2)** | `~/workspaces/.config/openclaw/workspace` | 类似 Linux |
| **Windows (原生)** | `C:\Users\Name\AppData\Local\OpenClaw` | 需要配置 |

**查看当前工作区：**
```bash
# 查看工作区路径
openclaw workdir

# 或查看完整配置
openclaw config show
```

---

## 📁 工作区核心文件

### 文件结构概览

```
workspace/
├── agents/
│   ├── agents.md             # 多 Agent 配置
│   └── agent-templates/
│       ├── general.yaml      # 通用 Agent 模板
│       ├── analyst.yaml      # 数据分析 Agent 模板
│       └── creator.yaml      # 内容创作 Agent 模板
│
├── soul/
│   ├── soul.md               # AI 人格定义
│   └── personality/
│       ├── formal.yaml       # 正式风格
│       ├── casual.yaml       # 随意风格
│       └── expert.yaml       # 专家风格
│
├── memory/
│   ├── memory.md             # 长期记忆
│   └── sessions/             # 会话历史
│       ├── session_001.json
│       ├── session_002.json
│       └── ...
│
├── skills/                   # 技能目录
│   ├── openclaw-cli/
│   ├── github/
│   └── ...
│
├── config/
│   ├── config.yaml           # 系统配置
│   ├── keys/                 # API 密钥
│   └── templates/            # 任务模板
│
└── logs/                     # 日志目录
    ├── openclaw.log
    └── skills/
```

---

## 📄 核心文件详解

### 1️⃣ **agents.md - 多 Agent 配置**

**位置：** `agents/agents.md`  
**功能：** 定义所有可用 Agent 的角色、能力和职责

#### 文件结构

```yaml
# agents.md - OpenClaw Agent 配置

# =========================
# 全局配置
# =========================
system:
  name: "OpenClaw Assistant"
  version: "0.2.0"
  max_concurrent_agents: 3
  timeout_per_task: 300  # 秒

# =========================
# Agent 列表
# =========================
agents:
  # Agent 1: 统筹 Agent
  - name: "统筹 Agent"
    id: "orchestrator"
    role: "orchestrator"
    description: "负责任务分解、调度和进度跟踪"
    capabilities:
      - task_decomposition
      - scheduling
      - progress_tracking
      - coordination
    priority: 100
    auto_assign: true

  # Agent 2: 数据分析 Agent
  - name: "数据分析 Agent"
    id: "data_analyst"
    role: "analyst"
    description: "擅长数据查询、统计分析和报告生成"
    capabilities:
      - data_query
      - statistical_analysis
      - chart_generation
      - report_writing
    tools:
      - "github"
      - "gdrive"
      - "database_connector"
    priority: 80
    auto_assign: false

  # Agent 3: 内容创作 Agent
  - name: "内容创作 Agent"
    id: "content_creator"
    role: "creator"
    description: "负责文章撰写、脚本创作和图文生成"
    capabilities:
      - article_writing
      - script_creation
      - image_generation
      - editing
    tools:
      - "browser"
      - "pdf_reader"
      - "image_editor"
    priority: 70
    auto_assign: false

  # Agent 4: 知识管理 Agent
  - name: "知识管理 Agent"
    id: "knowledge_manager"
    role: "manager"
    description: "负责知识库维护、文档组织和信息管理"
    capabilities:
      - document_organization
      - knowledge_graph
      - search_and_retrieve
      - metadata_management
    tools:
      - "obsidian_integration"
      - "pdf_reader"
      - "document_analyzer"
    priority: 60
    auto_assign: false

# =========================
# Agent 协作配置
# =========================
collaboration:
  default_mode: "sequential"  # sequential | parallel | feedback
  coordination_agent: "orchestrator"
  max_retries: 3
  error_threshold: 2  # 连续错误次数触发人工介入

# =========================
# 任务分配规则
# =========================
task_routing:
  - type: "data_analysis"
    assign_to: "data_analyst"
    confidence: 0.9

  - type: "content_creation"
    assign_to: "content_creator"
    confidence: 0.85

  - type: "knowledge_management"
    assign_to: "knowledge_manager"
    confidence: 0.9

  - type: "general"
    assign_to: "orchestrator"
    confidence: 0.7
```

#### 核心字段说明

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | 字符串 | Agent 名称（显示用） |
| `id` | 字符串 | 唯一标识符（内部使用） |
| `role` | 字符串 | 角色类型：orchestrator/analyst/creator/manager |
| `description` | 字符串 | Agent 功能描述 |
| `capabilities` | 数组 | 可执行的能力列表 |
| `tools` | 数组 | 可使用的技能列表 |
| `priority` | 数字 | 优先级（100-0） |
| `auto_assign` | 布尔值 | 是否自动分配任务 |

#### 能力类型

```yaml
capabilities:
  # 基础能力
  - task_decomposition      # 任务分解
  - scheduling              # 调度执行
  - progress_tracking       # 进度跟踪
  - coordination            # 协调协作
  
  # 分析能力
  - data_query              # 数据查询
  - statistical_analysis    # 统计分析
  - chart_generation        # 图表生成
  - report_writing          # 报告撰写
  
  # 创作能力
  - article_writing         # 文章撰写
  - script_creation         # 脚本创作
  - image_generation        # 图片生成
  - editing                 # 编辑
  
  # 管理能力
  - document_organization   # 文档组织
  - knowledge_graph         # 知识图谱
  - search_and_retrieve     # 搜索检索
  - metadata_management     # 元数据管理
```

---

### 2️⃣ **soul.md - AI 人格定义**

**位置：** `soul/soul.md`  
**功能：** 定义 AI 的核心原则、行为边界和风格偏好

#### 文件结构

```yaml
# soul.md - AI 人格配置文件

# =========================
# 核心原则
# =========================
core_principles:
  - "始终以用户利益为优先"
  - "保持诚实和透明"
  - "尊重用户隐私"
  - "持续学习和改进"
  - "避免过度承诺"

# =========================
# 行为边界
# =========================
boundaries:
  # 禁止操作
  prohibited_actions:
    - "执行可能危害用户设备安全的命令"
    - "未经授权访问用户私人数据"
    - "删除关键系统文件"
    - "发送未经确认的信息"

  # 权限限制
  permission_limits:
    - "需要用户确认的操作：文件删除、API 调用"
    - "需要管理员权限：系统配置修改"
    - "默认权限：只读操作、查询任务"

  # 伦理约束
  ethical_constraints:
    - "尊重不同文化和信仰"
    - "避免偏见和歧视性言论"
    - "保护知识产权"
    - "维护信息安全"

# =========================
# 风格偏好
# =========================
style_preferences:
  # 语言风格
  language_style: "professional_casual"  # formal | casual | professional_casual | expert
  tone: "helpful_encouraging"  # neutral | helpful | encouraging | serious
  verbosity: "concise"  # verbose | concise | detailed
  humor_level: 2  # 0-5，0=无幽默，5=很幽默
  
  # 输出格式
  output_format:
    - "优先使用 Markdown 格式"
    - "使用 emoji 增强可读性"
    - "重要信息使用粗体"
    - "列表使用有序/无序列表"
    - "代码使用代码块"
  
  # 交互方式
  interaction:
    - "主动询问模糊需求"
    - "提供多个选项供选择"
    - "重要问题二次确认"
    - "错误时给出解决方案"

# =========================
# 知识范围
# =========================
knowledge_scope:
  areas:
    - "技术文档阅读"
    - "数据分析"
    - "内容创作"
    - "项目管理"
    - "编程辅助"
    - "日常助手"
  expertise_level: "competent"  # novice | competent | expert | authority

# =========================
# 学习机制
# =========================
learning:
  enabled: true
  user_feedback:
    - "记住用户偏好"
    - "记录常用任务"
    - "识别任务模式"
  knowledge_update:
    - "从对话中学习"
    - "从任务执行中学习"
    - "从错误中学习"
```

#### 语言风格选项

| 风格 | 特点 | 适用场景 |
|------|------|---------|
| **formal** | 正式、专业 | 商务报告、技术文档 |
| **casual** | 随意、友好 | 日常对话、轻松任务 |
| **professional_casual** | 平衡专业与亲和 | 日常工作、项目协作 |
| **expert** | 专家级、深入 | 技术讨论、专业咨询 |

#### 语气选项

| 语气 | 特点 | 说明 |
|------|------|------|
| **neutral** | 客观中立 | 陈述事实，不带情感 |
| **helpful** | 乐于助人 | 主动提供帮助 |
| **encouraging** | 鼓励支持 | 给予肯定和鼓励 |
| **serious** | 严肃认真 | 专注任务，高效执行 |

---

### 3️⃣ **memory.md - 长期记忆管理**

**位置：** `memory/memory.md`  
**功能：** 存储用户习惯、偏好、常用任务等长期信息

#### 文件结构

```yaml
# memory.md - 长期记忆配置

# =========================
# 用户偏好
# =========================
preferences:
  # 交流偏好
  communication:
    language: "中文"
    style: "concise"  # detailed | concise | medium
    emoji_usage: true
    formal_level: 3  # 1-5，1=很随意，5=很正式
  
  # 工作偏好
  work_style:
    start_time: "09:00"
    end_time: "18:00"
    lunch_break: "12:00-13:00"
    preferred_days: ["周一", "周二", "周三", "周四", "周五"]
  
  # 工具偏好
  tool_preferences:
    - "优先使用本地工具"
    - "避免不必要的云服务"
    - "数据本地存储优先"
  
  # 输出偏好
  output_preferences:
    - "使用中文输出"
    - "Markdown 格式"
    - "重要信息加粗"
    - "使用 emoji"

# =========================
# 常用任务模式
# =========================
frequently_used_tasks:
  # 每日任务
  daily:
    - "09:00 - 生成早报"
    - "12:00 - 检查日历"
    - "18:00 - 生成日报"
  
  # 每周任务
  weekly:
    - "周一 - 生成周报"
    - "周五 - 总结本周"
  
  # 每月任务
  monthly:
    - "月初 - 生成月报"
    - "月末 - 总结月份"

# =========================
# 学习到的习惯
# =========================
learned_patterns:
  # 行为模式
  behavior_patterns:
    - name: "周五周报习惯"
      description: "每周五下午自动生成周报"
      trigger: "周五 17:00"
      action: "summarize_week"
      confidence: 0.95
  
    - name: "邮件处理习惯"
      description: "优先处理重要邮件"
      trigger: "新邮件到达"
      action: "classify_priority"
      confidence: 0.90

  # 任务偏好
  task_preferences:
    - "喜欢用命令行查看数据"
    - "偏好 PDF 格式的报告"
    - "重要邮件自动分类"

# =========================
# 用户项目
# =========================
user_projects:
  # 项目 1
  - name: "OpenClaw 教程项目"
    status: "active"
    priority: 1
    start_date: "2026-04-06"
    deadline: "2026-06-30"
    tasks:
      - name: "第一章编写"
        status: "completed"
        completed_at: "2026-04-06"
      - name: "第二章编写"
        status: "completed"
        completed_at: "2026-04-06"
      - name: "第三章编写"
        status: "in_progress"
        expected_completion: "2026-04-07"
  
  # 项目 2
  - name: "自动化工作流搭建"
    status: "planning"
    priority: 2
    start_date: "2026-04-10"
    tasks:
      - name: "数据收集流程"
        status: "pending"
      - name: "分析报告生成"
        status: "pending"

# =========================
# 知识笔记
# =========================
knowledge_notes:
  # 知识点 1
  - topic: "OpenClaw 架构"
    summary: "Agent 系统 + Skill 系统 + 记忆管理"
    tags: ["架构", "核心", "学习"]
    created_at: "2026-04-06"
  
  # 知识点 2
  - topic: "跨平台部署"
    summary: "macOS/Linux/WSL2 三种方式"
    tags: ["部署", "跨平台"]
    created_at: "2026-04-06"

# =========================
# 记忆优化
# =========================
memory_optimization:
  # 自动清理
  auto_cleanup:
    enabled: true
    max_entries: 1000
    cleanup_frequency: "weekly"
  
  # 优先级标记
  priorities:
    - level: 1  # 核心记忆（永不删除）
    - level: 2  # 重要记忆（保留 90 天）
    - level: 3  # 一般记忆（保留 30 天）
    - level: 4  # 临时记忆（7 天清理）
```

---

## 🔧 如何修改文件定义 AI 人格

### 修改 agents.md

#### 1️⃣ 添加新 Agent

**步骤：**
```bash
# 1. 打开 agents.md
# 2. 在 agents 列表中添加新 Agent
# 3. 定义能力、工具、优先级
# 4. 保存并重启服务
```

**示例：添加一个「代码审查 Agent」**
```yaml
  # Agent 5: 代码审查 Agent
  - name: "代码审查 Agent"
    id: "code_reviewer"
    role: "analyst"
    description: "擅长代码审查、质量保证和代码优化"
    capabilities:
      - code_analysis
      - quality_review
      - optimization_suggestions
      - security_scan
    tools:
      - "github"
      - "git"
      - "code_analyzer"
    priority: 75
    auto_assign: false
```

#### 2️⃣ 修改 Agent 能力

**步骤：**
```bash
# 在 capabilities 列表中修改
capabilities:
  - existing_capability_1
  - existing_capability_2
  - new_capability_3  # 新增能力
  - removed_capability  # 移除能力（删除该行）
```

#### 3️⃣ 调整任务分配

**步骤：**
```bash
# 修改 task_routing 配置
task_routing:
  - type: "code_review"
    assign_to: "code_reviewer"
    confidence: 0.95  # 提高置信度
```

---

### 定制 soul.md

#### 1️⃣ 调整语言风格

**示例：改为更正式的语气**
```yaml
style_preferences:
  language_style: "formal"  # 改为 formal
  tone: "helpful"  # 改为 helpful
  verbosity: "detailed"  # 改为 detailed
  humor_level: 1  # 降低幽默感
```

#### 2️⃣ 修改行为边界

**示例：增加权限控制**
```yaml
boundaries:
  prohibited_actions:
    - "执行可能危害用户设备安全的命令"
    - "未经授权访问用户私人数据"
    - "删除关键系统文件"
    - "发送未经确认的信息"
    - "修改系统配置文件"  # 新增

  permission_limits:
    - "需要用户确认的操作：文件删除、API 调用"
    - "需要管理员权限：系统配置修改"
    - "默认权限：只读操作、查询任务"
    - "需要二次确认：敏感数据操作"  # 新增
```

#### 3️⃣ 调整输出格式

**示例：使用更简洁的格式**
```yaml
output_format:
  - "优先使用 Markdown 格式"
  - "减少 emoji 使用"  # 减少
  - "重要信息加粗"
  - "列表使用有序列表"  # 改为有序
  - "代码使用代码块"
  - "避免过长段落"  # 新增
```

---

### 调整 memory.md

#### 1️⃣ 添加用户偏好

**示例：添加新的偏好**
```yaml
preferences:
  # ... 现有配置 ...
  
  # 新增偏好
  notification_preferences:
    - "重要任务即时通知"
    - "日报在 18:00 发送"
    - "周报在周五发送"
```

#### 2️⃣ 记录任务习惯

**示例：记录新的任务模式**
```yaml
learned_patterns:
  behavior_patterns:
    # ... 现有模式 ...
    
    - name: "日报习惯"
      description: "每周一到周五自动生成日报"
      trigger: "工作日 18:00"
      action: "generate_daily_report"
      confidence: 0.85  # 置信度
```

#### 3️⃣ 更新项目信息

**示例：添加新项目**
```yaml
user_projects:
  # ... 现有项目 ...
  
  # 新项目
  - name: "OpenClaw 技能开发"
    status: "planning"
    priority: 3
    start_date: "2026-04-10"
    tasks:
      - name: "技能设计"
        status: "pending"
      - name: "脚本编写"
        status: "pending"
```

---

## 🔄 文件更新机制

### 自动更新（热更新）

**原理：**
- OpenClaw 持续监控配置文件变更
- 检测到文件变化后自动重载
- 无需重启服务

**支持的文件：**
- ✅ `agents/agents.md`
- ✅ `soul/soul.md`
- ✅ `memory/memory.md`
- ✅ `config/config.yaml`

**监控机制：**
```bash
# 检查文件监控状态
openclaw config show | grep file_watching

# 手动触发重载
openclaw config reload
```

### 何时需要重启

**必须重启的场景：**
- 🔄 修改 `agents/agent-templates/` 下的模板文件
- 🔄 添加/删除 Agent 模板
- 🔄 重大架构调整
- 🔄 性能配置变更

**安全重启：**
```bash
# 1. 先查看当前任务
openclaw status

# 2. 等待当前任务完成
# 3. 执行重启
openclaw restart

# 4. 验证重启成功
openclaw status
```

---

## 📋 版本管理建议

### Git 版本控制

**推荐配置：**
```bash
# 初始化 Git 仓库
cd workspace
git init

# 配置 Git
git config --global core.autocrlf false
git config --global core.filemode true

# 添加 Gitignore
echo "logs/" >> .gitignore
echo "*.tmp" >> .gitignore
echo "sessions/*.log" >> .gitignore

# 首次提交
git add .
git commit -m "initial: OpenClaw workspace configuration"
```

### 备份策略

**推荐方案：**

| 平台 | 备份方式 | 频率 |
|------|-------|--|
| **macOS** | Time Machine | 自动 |
| **Linux** | rsync + cron | 每日 |
| **Windows** | OneDrive | 自动 |
| **跨平台** | Git 仓库 | 每次变更 |

**备份脚本示例：**
```bash
#!/bin/bash
# backup_workspace.sh

BACKUP_DIR="/backup/openclaw"
WORKSPACE="$HOME/.config/openclaw/workspace"
DATE=$(date +%Y%m%d)

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 压缩备份
tar -czf "$BACKUP_DIR/workspace_${DATE}.tar.gz" "$WORKSPACE"

# 保留最近 30 天的备份
find "$BACKUP_DIR" -name "workspace_*.tar.gz" -mtime +30 -delete

echo "Backup completed: workspace_${DATE}.tar.gz"
```

---

## 🔄 跨平台注意事项

### 文件路径差异

**macOS:**
- 使用 `~` 表示用户主目录
- 文件路径区分大小写
- 默认使用 UTF-8 编码

**Linux:**
- 使用 `~` 表示用户主目录
- 文件路径区分大小写
- 文件权限严格

**Windows (WSL2):**
- 访问 Windows 文件：`/mnt/c/Users/...`
- 建议工作目录放在 WSL2 内部
- 文件路径区分大小写（Linux 模式）

### 换行符问题

**统一使用 LF (`\n`):**
```bash
# Git 配置统一换行符
git config --global core.autocrlf false

# 检查文件换行符
file filename.md
```

### 编码问题

**所有文件使用 UTF-8:**
```bash
# 检查文件编码
file -i filename.md

# 转换文件编码（如果需要）
iconv -f GBK -t UTF-8 input.md > output.md
```

---

## 🔄 常见问题

### Q1: 修改 agents.md 后没有生效？

**解答：**
```bash
# 1. 检查语法是否正确
openclaw config validate

# 2. 手动触发重载
openclaw config reload

# 3. 查看日志
openclaw logs | grep "config"
```

### Q2: soul.md 修改后风格不变？

**解答：**
```bash
# 1. 检查文件路径
ls -la soul/soul.md

# 2. 检查权限
ls -l soul/soul.md

# 3. 重载配置
openclaw config reload

# 4. 重启服务
openclaw restart
```

### Q3: 如何查看 memory.md 的内容？

**解答：**
```bash
# 查看记忆内容
cat memory/memory.md

# 或通过 OpenClaw 查询
/sessions list  # 查看会话历史
/memory query "关键词"  # 查询记忆
```

### Q4: 文件修改后自动更新失败？

**解答：**
```bash
# 1. 检查文件监控
openclaw config show | grep file_watching

# 2. 手动触发
openclaw config reload

# 3. 如果仍失败，手动重启
openclaw restart
```

### Q5: 跨平台文件同步问题？

**解答：**
- **Git 配置统一换行符**
- **使用 Git 进行版本控制**
- **避免直接在 Windows 编辑 Linux 文件**
- **优先在 WSL2 内编辑文件**

---

## 📚 下一步建议

**已了解：**
- ✅ 工作区核心文件结构
- ✅ agents.md - 多 Agent 配置
- ✅ soul.md - AI 人格定义
- ✅ memory.md - 长期记忆管理
- ✅ 如何修改定义 AI 人格
- ✅ 文件更新机制
- ✅ 版本管理建议

**下一步建议：**
- 📖 继续阅读 [05-基础命令速查](docs/05-基础命令速查/) 学习常用命令
- 📖 查看 [06-工具系统与技能安装](docs/06-工具系统与技能安装/) 了解技能管理
- 📖 实践 [13-知识管理自动化](docs/13-知识管理自动化/) 应用记忆系统

---

**作者：** kekolike-sudo  
**最后更新：** 2026-04-06  
**版本：** 0.2.0  
**许可证：** MIT
