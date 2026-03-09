/**
 * WebSocket 服务
 * 处理实时通信
 */
import { WebSocket, WebSocketServer } from 'ws';
import { config } from '../config';
import { WSClient, WSMessage } from '../types';
import { chatService } from '../services/chatService';
import { agentService } from '../services/agentService';

export class WebSocketService {
  private wss: WebSocketServer | null = null;
  private clients: Map<string, WSClient> = new Map();
  private heartbeatInterval: NodeJS.Timeout | null = null;

  /**
   * 初始化 WebSocket 服务器
   */
  initialize(server: any): void {
    this.wss = new WebSocketServer({ server, path: '/ws' });
    
    console.log('🚀 WebSocket server initialized on path: /ws');

    this.wss.on('connection', (ws: WebSocket, req) => {
      const clientId = this.generateClientId();
      const client: WSClient = {
        id: clientId,
        ws,
        lastPing: Date.now(),
      };

      this.clients.set(clientId, client);
      console.log(`🔌 Client connected: ${clientId}. Total clients: ${this.clients.size}`);

      // 发送连接成功消息
      this.sendMessage(client, {
        type: 'connect',
        payload: { clientId, message: 'Connected successfully' },
        timestamp: Date.now(),
      });

      // 处理消息
      ws.on('message', async (data: Buffer) => {
        try {
          const message: WSMessage = JSON.parse(data.toString());
          await this.handleMessage(client, message);
        } catch (error) {
          console.error('Error parsing WebSocket message:', error);
          this.sendMessage(client, {
            type: 'error',
            payload: { message: 'Invalid message format' },
            timestamp: Date.now(),
          });
        }
      });

      // 处理关闭
      ws.on('close', () => {
        this.clients.delete(clientId);
        console.log(`🔌 Client disconnected: ${clientId}. Total clients: ${this.clients.size}`);
      });

      // 处理错误
      ws.on('error', (error) => {
        console.error(`WebSocket error for client ${clientId}:`, error);
        this.clients.delete(clientId);
      });

      // 心跳
      ws.on('pong', () => {
        client.lastPing = Date.now();
      });
    });

    // 启动心跳检测
    this.startHeartbeat();
  }

  /**
   * 处理消息
   */
  private async handleMessage(client: WSClient, message: WSMessage): Promise<void> {
    switch (message.type) {
      case 'ping':
        this.sendMessage(client, {
          type: 'pong',
          timestamp: Date.now(),
        });
        break;

      case 'chat':
        await this.handleChatMessage(client, message);
        break;

      case 'connect':
        // 设置当前 Agent
        if (message.payload?.agentId) {
          client.currentAgentId = message.payload.agentId;
          this.sendMessage(client, {
            type: 'connect',
            payload: { message: `Connected to agent: ${message.payload.agentId}` },
            timestamp: Date.now(),
          });
        }
        break;

      default:
        this.sendMessage(client, {
          type: 'error',
          payload: { message: `Unknown message type: ${message.type}` },
          timestamp: Date.now(),
        });
    }
  }

  /**
   * 处理聊天消息
   */
  private async handleChatMessage(client: WSClient, message: WSMessage): Promise<void> {
    const { agentId, content, temperature } = message.payload || {};

    if (!agentId || !content) {
      this.sendMessage(client, {
        type: 'error',
        payload: { message: 'agentId and content are required' },
        timestamp: Date.now(),
      });
      return;
    }

    // 验证 Agent 是否存在
    const agent = agentService.getAgentById(agentId);
    if (!agent) {
      this.sendMessage(client, {
        type: 'error',
        payload: { message: `Agent not found: ${agentId}` },
        timestamp: Date.now(),
      });
      return;
    }

    try {
      // 发送 typing 状态
      this.sendMessage(client, {
        type: 'typing',
        payload: { isTyping: true },
        timestamp: Date.now(),
      });

      // 调用流式聊天服务
      const stream = chatService.chatStream({
        agentId,
        content,
        temperature: temperature ? parseFloat(temperature) : undefined,
      });

      let fullContent = '';

      for await (const chunk of stream) {
        if (chunk.type === 'chunk') {
          fullContent += chunk.content;
          this.sendMessage(client, {
            type: 'chat',
            payload: {
              type: 'chunk',
              content: chunk.content,
              agentId,
            },
            timestamp: Date.now(),
          });
        } else if (chunk.type === 'complete') {
          this.sendMessage(client, {
            type: 'chat',
            payload: {
              type: 'complete',
              message: chunk.message,
              agentId,
            },
            timestamp: Date.now(),
          });
        }
      }
    } catch (error: any) {
      console.error('Error in WebSocket chat:', error);
      this.sendMessage(client, {
        type: 'error',
        payload: { message: error.message || 'Failed to process chat' },
        timestamp: Date.now(),
      });
    } finally {
      // 结束 typing 状态
      this.sendMessage(client, {
        type: 'typing',
        payload: { isTyping: false },
        timestamp: Date.now(),
      });
    }
  }

  /**
   * 发送消息给客户端
   */
  private sendMessage(client: WSClient, message: WSMessage): void {
    if (client.ws.readyState === WebSocket.OPEN) {
      client.ws.send(JSON.stringify(message));
    }
  }

  /**
   * 生成客户端 ID
   */
  private generateClientId(): string {
    return `client-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }

  /**
   * 启动心跳检测
   */
  private startHeartbeat(): void {
    this.heartbeatInterval = setInterval(() => {
      const now = Date.now();
      const timeout = config.ws.heartbeatInterval * 2;

      this.clients.forEach((client, clientId) => {
        // 检查是否超时
        if (now - client.lastPing > timeout) {
          console.log(`💔 Client timeout: ${clientId}`);
          client.ws.terminate();
          this.clients.delete(clientId);
          return;
        }

        // 发送 ping
        if (client.ws.readyState === WebSocket.OPEN) {
          client.ws.ping();
        }
      });
    }, config.ws.heartbeatInterval);
  }

  /**
   * 关闭 WebSocket 服务
   */
  close(): void {
    if (this.heartbeatInterval) {
      clearInterval(this.heartbeatInterval);
    }
    
    this.clients.forEach((client) => {
      client.ws.close();
    });
    this.clients.clear();

    this.wss?.close();
    console.log('🛑 WebSocket server closed');
  }

  /**
   * 获取在线客户端数量
   */
  getClientCount(): number {
    return this.clients.size;
  }
}

export const wsService = new WebSocketService();
