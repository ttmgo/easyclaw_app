/**
 * 类型定义文件
 */

// Agent 类型
export interface Agent {
  id: string;
  title: string;
  description: string;
  tag: string;
  status: string;
  rating: string;
  completed: string;
  activeUsers: string;
  load: string;
  tps: string;
  icon: string;
  themeColor: string;
  bgImage: string;
  role: string;
  expertise: string[];
  metrics: Record<string, string>;
  pipeline: Array<{ step: string; desc: string }>;
  recentAchievement: string;
  systemPrompt?: string; // 用于 AI 对话的系统提示词
}

// Skill 类型
export interface Skill {
  id: string;
  title: string;
  description: string;
  icon: string;
  tag: string;
  rating: number;
  users: string;
  latency: string;
  stack: string;
  performance: string;
  details: string;
  features: string[];
  usage: string;
  version: string;
  category: string;
}

// 消息类型
export interface Message {
  id: string;
  role: 'user' | 'assistant' | 'system';
  agentId: string;
  content: string;
  type?: 'text' | 'rich-text' | 'data-table' | 'image';
  attachment?: Attachment;
  tableData?: TableRow[];
  createdAt: Date;
}

export interface Attachment {
  type: 'image';
  url: string;
  caption: string;
}

export interface TableRow {
  item: string;
  value: string;
  status: string;
}

// Kimi API 类型
export interface KimiMessage {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

export interface KimiChatRequest {
  model: string;
  messages: KimiMessage[];
  temperature?: number;
  top_p?: number;
  stream?: boolean;
  max_tokens?: number;
}

export interface KimiChatResponse {
  id: string;
  object: string;
  created: number;
  model: string;
  choices: Array<{
    index: number;
    message: KimiMessage;
    finish_reason: string;
  }>;
  usage: {
    prompt_tokens: number;
    completion_tokens: number;
    total_tokens: number;
  };
}

export interface KimiStreamChunk {
  id: string;
  object: string;
  created: number;
  model: string;
  choices: Array<{
    index: number;
    delta: {
      role?: string;
      content?: string;
    };
    finish_reason: string | null;
  }>;
}

// WebSocket 类型
export interface WSClient {
  id: string;
  ws: WebSocket;
  userId?: string;
  currentAgentId?: string;
  lastPing: number;
}

export interface WSMessage {
  type: 'chat' | 'ping' | 'pong' | 'typing' | 'error' | 'connect' | 'disconnect';
  payload?: any;
  timestamp: number;
}

// API 响应类型
export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
  };
  meta?: {
    page?: number;
    limit?: number;
    total?: number;
  };
}
