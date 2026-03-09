/**
 * EasyClaw Server
 * 主入口文件
 */
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import http from 'http';

import { config, validateConfig } from './config';
import { errorHandler, notFoundHandler } from './middleware/errorHandler';
import { requestLogger } from './middleware/validator';
import agentRoutes from './routes/agentRoutes';
import skillRoutes from './routes/skillRoutes';
import chatRoutes from './routes/chatRoutes';
import { wsService } from './services/webSocketService';

// 创建 Express 应用
const app = express();
const server = http.createServer(app);

// 验证配置
validateConfig();

// 中间件
app.use(helmet({
  contentSecurityPolicy: false, // 允许跨域资源加载
}));
app.use(cors({
  origin: config.corsOrigin,
  credentials: true,
}));
app.use(morgan(config.nodeEnv === 'development' ? 'dev' : 'combined'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(requestLogger);

// 健康检查
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    environment: config.nodeEnv,
    websocketClients: wsService.getClientCount(),
  });
});

// API 路由
app.use('/api/agents', agentRoutes);
app.use('/api/skills', skillRoutes);
app.use('/api/chat', chatRoutes);

// 根路由
app.get('/', (req, res) => {
  res.json({
    name: 'EasyClaw Server',
    version: '1.0.0',
    description: 'AI Agent 管理与对话服务',
    endpoints: {
      agents: '/api/agents',
      skills: '/api/skills',
      chat: '/api/chat',
      websocket: '/ws',
      health: '/health',
    },
    docs: 'https://github.com/your-org/easyclaw',
  });
});

// 错误处理
app.use(notFoundHandler);
app.use(errorHandler);

// 初始化 WebSocket
wsService.initialize(server);

// 启动服务器
const PORT = config.port;
server.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════════════════╗
║                                                ║
║   🚀 EasyClaw Server is running!               ║
║                                                ║
║   📡 HTTP:  http://localhost:${PORT}            ║
║   🔌 WS:    ws://localhost:${PORT}/ws          ║
║                                                ║
║   📚 API Endpoints:                            ║
║   • GET  /api/agents                          ║
║   • GET  /api/agents/:id                      ║
║   • GET  /api/skills                          ║
║   • GET  /api/skills/:id                      ║
║   • POST /api/chat                            ║
║   • POST /api/chat/stream                     ║
║                                                ║
╚════════════════════════════════════════════════╝
  `);
});

// 优雅关闭
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  wsService.close();
  server.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('SIGINT received, shutting down gracefully');
  wsService.close();
  server.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});

// 未捕获的错误处理
process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
  process.exit(1);
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});

export default app;
