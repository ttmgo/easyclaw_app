# EasyClaw Server API 文档

## 基础信息

- **Base URL**: `http://localhost:3000/api`
- **WebSocket**: `ws://localhost:3000/ws`
- **Content-Type**: `application/json`

## 响应格式

所有 API 响应均采用以下格式：

```json
{
  "success": true,      // 请求是否成功
  "data": {},           // 响应数据（成功时）
  "error": {            // 错误信息（失败时）
    "code": "ERROR_CODE",
    "message": "错误描述"
  },
  "meta": {             // 元数据（可选）
    "total": 10
  }
}
```

---

## Agent API

### 获取所有 Agents

```
GET /api/agents
```

**响应示例**:

```json
{
  "success": true,
  "data": [
    {
      "id": "d1",
      "title": "AI 影視導演 LEO",
      "description": "跨模型電影級影像調度與分鏡設計...",
      "tag": "影視製作",
      "status": "High Efficiency",
      "rating": "9.9",
      "completed": "1,240",
      "activeUsers": "420",
      "load": "28%",
      "tps": "12.5s/clip",
      "icon": "movie",
      "themeColor": "from-gray-900 via-blue-900 to-black",
      "bgImage": "https://images.unsplash.com/...",
      "role": "全能型 AI 導演...",
      "expertise": ["分鏡指令優化", "動態運鏡控制", ...],
      "metrics": {
        "logic": "98.5%",
        "creative": "94.2%",
        "speed": "0.4s/frame"
      },
      "pipeline": [
        { "step": "腳本結構拆解", "desc": "..." },
        ...
      ],
      "recentAchievement": "..."
    }
  ],
  "meta": {
    "total": 3
  }
}
```

---

### 获取单个 Agent

```
GET /api/agents/:id
```

**参数**:
- `id` (path) - Agent ID

**响应示例**:

```json
{
  "success": true,
  "data": {
    "id": "d1",
    "title": "AI 影視導演 LEO",
    ...
  }
}
```

---

### 搜索 Agents

```
GET /api/agents/search?q=关键词
```

**参数**:
- `q` (query) - 搜索关键词

**响应示例**:

```json
{
  "success": true,
  "data": [...],
  "meta": {
    "total": 1
  }
}
```

---

## Skill API

### 获取所有 Skills

```
GET /api/skills
```

**响应示例**:

```json
{
  "success": true,
  "data": [
    {
      "id": "s1",
      "title": "PPT 結構化引擎",
      "description": "邏輯抽取與佈局映射。",
      "icon": "description",
      "tag": "Office",
      "rating": 4.9,
      "users": "45k+",
      "latency": "450ms",
      "stack": "NLP-Schema-v4",
      "performance": "98.2%",
      "details": "...",
      "features": ["自動目錄生成", "視覺權重優化", ...],
      "usage": "curl -X POST /v1/ppt-gen...",
      "version": "stable-1.2.0",
      "category": "生產力工具"
    }
  ],
  "meta": {
    "total": 3
  }
}
```

---

### 获取单个 Skill

```
GET /api/skills/:id
```

---

### 获取分类列表

```
GET /api/skills/categories
```

**响应示例**:

```json
{
  "success": true,
  "data": ["生產力工具", "視覺增強", "開發工具"]
}
```

---

### 搜索 Skills

```
GET /api/skills/search?q=关键词
```

---

## Chat API

### 非流式聊天

```
POST /api/chat
```

**请求体**:

```json
{
  "agentId": "d1",          // 必填 - Agent ID
  "content": "你好",        // 必填 - 用户消息
  "temperature": 0.7        // 可选 - 温度参数 (0-2)
}
```

**响应示例**:

```json
{
  "success": true,
  "data": {
    "message": {
      "id": "1234567890-abc",
      "role": "assistant",
      "agentId": "d1",
      "content": "你好！我是 AI 影視導演 LEO...",
      "type": "rich-text",
      "createdAt": "2025-03-04T12:00:00.000Z"
    },
    "usage": {
      "promptTokens": 150,
      "completionTokens": 200,
      "totalTokens": 350
    }
  }
}
```

---

### 流式聊天 (SSE)

```
POST /api/chat/stream
```

**请求体**: 同上

**响应**: Server-Sent Events 流

**事件类型**:

1. **连接确认**:
```
data: {"type": "connected"}
```

2. **内容块**:
```
data: {"type": "chunk", "content": "你好"}
```

3. **完成**:
```
data: {"type": "complete", "message": {...}}
```

4. **结束**:
```
data: {"type": "done"}
```

**JavaScript 客户端示例**:

```javascript
const eventSource = new EventSource('/api/chat/stream', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    agentId: 'd1',
    content: '你好'
  })
});

eventSource.onmessage = (event) => {
  const data = JSON.parse(event.data);
  
  if (data.type === 'chunk') {
    console.log('收到内容:', data.content);
  } else if (data.type === 'complete') {
    console.log('完成:', data.message);
    eventSource.close();
  }
};
```

---

### 获取聊天历史

```
GET /api/chat/history/:agentId?limit=50
```

**参数**:
- `agentId` (path) - Agent ID
- `limit` (query) - 返回消息数量限制，默认 50

**响应示例**:

```json
{
  "success": true,
  "data": [
    {
      "id": "msg-1",
      "role": "user",
      "agentId": "d1",
      "content": "你好",
      "type": "text",
      "createdAt": "2025-03-04T12:00:00.000Z"
    },
    {
      "id": "msg-2",
      "role": "assistant",
      "agentId": "d1",
      "content": "你好！我是...",
      "type": "rich-text",
      "createdAt": "2025-03-04T12:00:01.000Z"
    }
  ],
  "meta": {
    "total": 2
  }
}
```

---

### 清除聊天历史

```
DELETE /api/chat/history/:agentId
```

**响应示例**:

```json
{
  "success": true,
  "data": {
    "message": "Chat history cleared successfully"
  }
}
```

---

## WebSocket API

### 连接

```
ws://localhost:3000/ws
```

### 消息格式

所有消息均为 JSON 格式：

```json
{
  "type": "message_type",
  "payload": {},
  "timestamp": 1234567890
}
```

### 消息类型

#### 1. 连接确认（服务端发送）

```json
{
  "type": "connect",
  "payload": {
    "clientId": "client-xxx",
    "message": "Connected successfully"
  },
  "timestamp": 1234567890
}
```

#### 2. Ping/Pong

客户端发送：
```json
{
  "type": "ping",
  "timestamp": 1234567890
}
```

服务端响应：
```json
{
  "type": "pong",
  "timestamp": 1234567890
}
```

#### 3. 选择 Agent

```json
{
  "type": "connect",
  "payload": {
    "agentId": "d1"
  },
  "timestamp": 1234567890
}
```

#### 4. 发送消息

```json
{
  "type": "chat",
  "payload": {
    "agentId": "d1",
    "content": "你好",
    "temperature": 0.7
  },
  "timestamp": 1234567890
}
```

#### 5. 接收回复（服务端发送）

内容块：
```json
{
  "type": "chat",
  "payload": {
    "type": "chunk",
    "content": "你好",
    "agentId": "d1"
  },
  "timestamp": 1234567890
}
```

完成：
```json
{
  "type": "chat",
  "payload": {
    "type": "complete",
    "message": {
      "id": "msg-xxx",
      "role": "assistant",
      "agentId": "d1",
      "content": "你好！我是...",
      "type": "rich-text",
      "createdAt": "2025-03-04T12:00:00.000Z"
    },
    "agentId": "d1"
  },
  "timestamp": 1234567890
}
```

#### 6. 打字状态（服务端发送）

```json
{
  "type": "typing",
  "payload": {
    "isTyping": true
  },
  "timestamp": 1234567890
}
```

#### 7. 错误（服务端发送）

```json
{
  "type": "error",
  "payload": {
    "message": "错误描述"
  },
  "timestamp": 1234567890
}
```

---

### WebSocket JavaScript 客户端示例

```javascript
const ws = new WebSocket('ws://localhost:3000/ws');

ws.onopen = () => {
  console.log('Connected');
  
  // 选择 Agent
  ws.send(JSON.stringify({
    type: 'connect',
    payload: { agentId: 'd1' },
    timestamp: Date.now()
  }));
};

ws.onmessage = (event) => {
  const message = JSON.parse(event.data);
  
  switch (message.type) {
    case 'connect':
      console.log('Connected:', message.payload);
      break;
    case 'typing':
      console.log('Typing:', message.payload.isTyping);
      break;
    case 'chat':
      if (message.payload.type === 'chunk') {
        console.log('Chunk:', message.payload.content);
      } else if (message.payload.type === 'complete') {
        console.log('Complete:', message.payload.message);
      }
      break;
    case 'error':
      console.error('Error:', message.payload.message);
      break;
  }
};

ws.onclose = () => {
  console.log('Disconnected');
};

// 发送消息
function sendMessage(content) {
  ws.send(JSON.stringify({
    type: 'chat',
    payload: {
      agentId: 'd1',
      content: content
    },
    timestamp: Date.now()
  }));
}

// 心跳
setInterval(() => {
  ws.send(JSON.stringify({
    type: 'ping',
    timestamp: Date.now()
  }));
}, 30000);
```

---

## 错误码

| 错误码 | 描述 | HTTP 状态码 |
|--------|------|-------------|
| BAD_REQUEST | 请求参数错误 | 400 |
| NOT_FOUND | 资源不存在 | 404 |
| INTERNAL_ERROR | 服务器内部错误 | 500 |
| SERVICE_UNAVAILABLE | 服务不可用（如 Kimi API 未配置） | 503 |

---

## 健康检查

```
GET /health
```

**响应示例**:

```json
{
  "status": "ok",
  "timestamp": "2025-03-04T12:00:00.000Z",
  "environment": "development",
  "websocketClients": 5
}
```
