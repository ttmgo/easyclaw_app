/**
 * 消息服务
 * 处理消息的存储和检索
 */
import { store } from './store';
import { Message } from '../types';

export class MessageService {
  /**
   * 生成唯一 ID
   */
  private generateId(): string {
    return `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }

  /**
   * 获取 Agent 的历史消息
   */
  getMessages(agentId: string, limit: number = 50): Message[] {
    const messages = store.getMessagesByAgentId(agentId);
    // 返回最新的消息，限制数量
    return messages.slice(-limit);
  }

  /**
   * 添加用户消息
   */
  addUserMessage(agentId: string, content: string): Message {
    const message: Message = {
      id: this.generateId(),
      role: 'user',
      agentId,
      content,
      type: 'text',
      createdAt: new Date(),
    };
    
    store.addMessage(agentId, message);
    return message;
  }

  /**
   * 添加助手消息
   */
  addAssistantMessage(
    agentId: string, 
    content: string, 
    type: Message['type'] = 'text'
  ): Message {
    const message: Message = {
      id: this.generateId(),
      role: 'assistant',
      agentId,
      content,
      type,
      createdAt: new Date(),
    };
    
    store.addMessage(agentId, message);
    return message;
  }

  /**
   * 清除 Agent 的消息历史
   */
  clearMessages(agentId: string): void {
    store.clearMessages(agentId);
  }

  /**
   * 转换为 Kimi API 格式
   */
  toKimiFormat(messages: Message[]): Array<{ role: 'user' | 'assistant' | 'system'; content: string }> {
    return messages.map(msg => ({
      role: msg.role,
      content: msg.content,
    }));
  }
}

export const messageService = new MessageService();
