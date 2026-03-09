# EasyClaw Server - 快速开始指南

## 📋 前置要求

- Node.js 18+ 
- npm 或 yarn
- Kimi API Key（从 https://platform.moonshot.cn/ 获取）

---

## 🚀 安装与启动

### 1. 进入服务端目录

```bash
cd easyclaw_server
```

### 2. 安装依赖

```bash
npm install
```

### 3. 配置环境变量

```bash
cp .env.example .env
```

编辑 `.env` 文件，填入你的 Kimi API Key：

```env
PORT=3000
KIMI_API_KEY=你的_API_Key_这里
KIMI_BASE_URL=https://api.moonshot.cn/v1
KIMI_MODEL=kimi-k2.5
NODE_ENV=development
```

### 4. 启动开发服务器

```bash
npm run dev
```

服务器将在 http://localhost:3000 启动。

---

## 🧪 测试 API

### 健康检查

```bash
curl http://localhost:3000/health
```

### 获取 Agents

```bash
curl http://localhost:3000/api/agents
```

### 发送消息（非流式）

```bash
curl -X POST http://localhost:3000/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "agentId": "d1",
    "content": "你好，请介绍一下自己"
  }'
```

### 流式聊天（SSE）

```bash
curl -X POST http://localhost:3000/api/chat/stream \
  -H "Content-Type: application/json" \
  -d '{
    "agentId": "d1",
    "content": "你好"
  }'
```

---

## 📱 连接移动端

### 1. 更新移动端配置

编辑 `lib/services/api_client.dart`：

```dart
// 如果使用模拟器，使用 10.0.2.2 (Android) 或 localhost (iOS)
// 如果使用真机，使用电脑的局域网 IP
static const String baseUrl = 'http://10.0.2.2:3000/api';  // Android 模拟器
static const String wsUrl = 'ws://10.0.2.2:3000/ws';       // Android 模拟器
```

### 2. 导入 API 客户端

```dart
import 'services/api_client.dart';

class _ChatTabState extends State<ChatTab> {
  final apiClient = EasyClawApiClient();
  
  @override
  void initState() {
    super.initState();
    _initWebSocket();
    _loadAgents();
  }
  
  void _initWebSocket() {
    apiClient.connectWebSocket(
      onMessage: (data) {
        if (data['type'] == 'chat') {
          // 处理消息
        }
      },
      onConnected: () => print('WebSocket connected'),
      onDisconnected: () => print('WebSocket disconnected'),
      onError: (error) => print('WebSocket error: $error'),
    );
  }
  
  Future<void> _loadAgents() async {
    try {
      final agents = await apiClient.getAgents();
      // 更新状态
    } catch (e) {
      print('Error loading agents: $e');
    }
  }
  
  void _sendMessage(String content) {
    apiClient.sendWebSocketMessage('d1', content);
  }
  
  @override
  void dispose() {
    apiClient.dispose();
    super.dispose();
  }
}
```

---

## 🔧 生产部署

### 1. 构建

```bash
npm run build
```

### 2. 启动生产服务器

```bash
NODE_ENV=production npm start
```

或使用 PM2：

```bash
npm install -g pm2
pm2 start dist/index.js --name easyclaw-server
```

---

## 📁 项目结构

```
easyclaw_server/
├── src/
│   ├── config/           # 配置文件
│   │   └── index.ts      # 环境变量配置
│   ├── controllers/      # 控制器
│   │   ├── agentController.ts
│   │   ├── skillController.ts
│   │   └── chatController.ts
│   ├── middleware/       # 中间件
│   │   ├── errorHandler.ts
│   │   └── validator.ts
│   ├── routes/           # 路由
│   │   ├── agentRoutes.ts
│   │   ├── skillRoutes.ts
│   │   └── chatRoutes.ts
│   ├── services/         # 业务逻辑
│   │   ├── store.ts      # 内存存储
│   │   ├── agentService.ts
│   │   ├── skillService.ts
│   │   ├── messageService.ts
│   │   ├── chatService.ts
│   │   └── webSocketService.ts
│   ├── types/            # 类型定义
│   │   └── index.ts
│   ├── utils/            # 工具函数
│   │   └── kimiClient.ts # Kimi API 客户端
│   └── index.ts          # 入口文件
├── .env                  # 环境变量（不提交到 git）
├── .env.example          # 环境变量示例
├── .gitignore
├── package.json
├── tsconfig.json
├── README.md
└── API.md                # API 文档
```

---

## 🔌 环境变量说明

| 变量名 | 必填 | 默认值 | 说明 |
|--------|------|--------|------|
| PORT | 否 | 3000 | HTTP 服务端口 |
| KIMI_API_KEY | 是 | - | Kimi API 密钥 |
| KIMI_BASE_URL | 否 | https://api.moonshot.cn/v1 | Kimi API 地址 |
| KIMI_MODEL | 否 | kimi-k2.5 | 模型名称 |
| NODE_ENV | 否 | development | 运行环境 |
| CORS_ORIGIN | 否 | * | 允许的跨域来源 |
| WS_HEARTBEAT_INTERVAL | 否 | 30000 | WebSocket 心跳间隔(ms) |

---

## 🐛 常见问题

### 1. 连接被拒绝

**问题**: 移动端无法连接到服务器

**解决**:
- 确保手机和电脑在同一网络
- 使用电脑的局域网 IP 而非 localhost
- 检查防火墙设置

### 2. Kimi API 错误

**问题**: 返回 "AI service is not configured properly"

**解决**:
- 检查 `.env` 文件中的 `KIMI_API_KEY` 是否正确设置
- 确认 API Key 有效且未过期

### 3. CORS 错误

**问题**: 浏览器/移动端报告跨域错误

**解决**:
- 修改 `.env` 中的 `CORS_ORIGIN` 为具体的域名
- 或使用 `*` 允许所有来源（仅开发环境）

---

## 📚 相关文档

- [API 文档](./API.md) - 完整的 API 接口文档
- [Kimi API 文档](https://platform.moonshot.cn/docs) - Kimi 官方文档

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

## 📄 License

MIT
