# EasyClaw Server

EasyClaw 服务端 - AI Agent 管理与对话服务

## 技术栈

- **Runtime**: Node.js + TypeScript
- **Framework**: Express.js
- **WebSocket**: ws
- **AI 模型**: Kimi K2.5 (Moonshot AI)

## 快速开始

### 1. 安装依赖

```bash
npm install
```

### 2. 配置环境变量

```bash
cp .env.example .env
# 编辑 .env 文件，设置你的 Kimi API Key
```

### 3. 启动开发服务器

```bash
npm run dev
```

### 4. 构建生产版本

```bash
npm run build
npm start
```

## API 文档

### 基础信息

- **Base URL**: `http://localhost:3000/api`
- **WebSocket**: `ws://localhost:3000/ws`

### 认证

目前使用简单的 token 认证，在请求头中添加：

```
Authorization: Bearer <token>
```

### 接口列表

| 方法 | 路径 | 描述 |
|------|------|------|
| GET | /api/agents | 获取 Agent 列表 |
| GET | /api/agents/:id | 获取 Agent 详情 |
| GET | /api/skills | 获取技能列表 |
| GET | /api/skills/:id | 获取技能详情 |
| POST | /api/chat | 发送消息（非流式）|
| POST | /api/chat/stream | 发送消息（流式 SSE）|
| GET | /api/messages/:agentId | 获取历史消息 |
| WebSocket | /ws | 实时对话连接 |

## 环境变量

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| PORT | 服务端口 | 3000 |
| KIMI_API_KEY | Kimi API 密钥 | - |
| KIMI_BASE_URL | Kimi API 基础 URL | https://api.moonshot.cn/v1 |
| KIMI_MODEL | 模型名称 | kimi-k2.5 |
| NODE_ENV | 环境模式 | development |

## 项目结构

```
src/
├── config/         # 配置文件
├── controllers/    # 控制器
├── middleware/     # 中间件
├── routes/         # 路由
├── services/       # 业务逻辑
├── types/          # 类型定义
├── utils/          # 工具函数
└── index.ts        # 入口文件
```

## License

MIT
