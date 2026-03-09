/**
 * 配置文件
 */
import dotenv from 'dotenv';
import path from 'path';

// 加载环境变量
dotenv.config({ path: path.resolve(process.cwd(), '.env') });

export const config = {
  // 服务配置
  port: parseInt(process.env.PORT || '3000', 10),
  nodeEnv: process.env.NODE_ENV || 'development',
  corsOrigin: process.env.CORS_ORIGIN || '*',
  
  // Kimi API 配置
  kimi: {
    apiKey: process.env.KIMI_API_KEY || '',
    baseUrl: process.env.KIMI_BASE_URL || 'https://api.moonshot.cn/v1',
    model: process.env.KIMI_MODEL || 'kimi-k2.5',
    maxTokens: parseInt(process.env.KIMI_MAX_TOKENS || '8192', 10),
    temperature: parseFloat(process.env.KIMI_TEMPERATURE || '0.7'),
    topP: parseFloat(process.env.KIMI_TOP_P || '0.9'),
  },
  
  // WebSocket 配置
  ws: {
    heartbeatInterval: parseInt(process.env.WS_HEARTBEAT_INTERVAL || '30000', 10),
    maxClients: parseInt(process.env.WS_MAX_CLIENTS || '1000', 10),
  },
  
  // 日志配置
  logLevel: process.env.LOG_LEVEL || 'info',
};

// 验证必要配置
export function validateConfig(): void {
  if (!config.kimi.apiKey) {
    console.warn('⚠️  Warning: KIMI_API_KEY is not set. AI features will not work.');
  }
}
