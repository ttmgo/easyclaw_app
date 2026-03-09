/**
 * 聊天服务
 * 处理与 AI 的对话逻辑
 */
import { kimiClient } from '../utils/kimiClient';
import { agentService } from './agentService';
import { messageService } from './messageService';
import { KimiMessage, Message } from '../types';

export interface ChatOptions {
  agentId: string;
  content: string;
  historyLimit?: number;
  temperature?: number;
  stream?: boolean;
}

export interface ChatResponse {
  message: Message;
  usage?: {
    promptTokens: number;
    completionTokens: number;
    totalTokens: number;
  };
}

export class ChatService {
  /**
   * 非流式聊天
   */
  async chat(options: ChatOptions): Promise<ChatResponse> {
    const { agentId, content, historyLimit = 10, temperature } = options;

    // 1. 获取 Agent 信息
    const agent = agentService.getAgentById(agentId);
    if (!agent) {
      throw new Error(`Agent not found: ${agentId}`);
    }

    // 2. 保存用户消息
    messageService.addUserMessage(agentId, content);

    // 3. 构建消息历史
    const history = messageService.getMessages(agentId, historyLimit);
    const systemPrompt = agentService.getAgentSystemPrompt(agentId);
    
    const kimiMessages: KimiMessage[] = [
      { role: 'system', content: systemPrompt || '你是一个有帮助的 AI 助手。' },
      ...messageService.toKimiFormat(history)
    ];

    // 4. 调用 Kimi API
    const response = await kimiClient.chat(kimiMessages, { temperature });
    const aiContent = response.choices[0]?.message?.content || '抱歉，我无法理解您的问题。';

    // 5. 保存 AI 回复
    const assistantMessage = messageService.addAssistantMessage(agentId, aiContent, 'rich-text');

    return {
      message: assistantMessage,
      usage: {
        promptTokens: response.usage?.prompt_tokens || 0,
        completionTokens: response.usage?.completion_tokens || 0,
        totalTokens: response.usage?.total_tokens || 0,
      },
    };
  }

  /**
   * 流式聊天
   * 返回异步生成器，用于 SSE
   */
  async *chatStream(options: ChatOptions): AsyncGenerator<
    { type: 'chunk'; content: string } | { type: 'complete'; message: Message },
    void,
    unknown
  > {
    const { agentId, content, historyLimit = 10, temperature } = options;

    // 1. 获取 Agent 信息
    const agent = agentService.getAgentById(agentId);
    if (!agent) {
      throw new Error(`Agent not found: ${agentId}`);
    }

    // 2. 保存用户消息
    messageService.addUserMessage(agentId, content);

    // 3. 构建消息历史
    const history = messageService.getMessages(agentId, historyLimit);
    const systemPrompt = agentService.getAgentSystemPrompt(agentId);
    
    const kimiMessages: KimiMessage[] = [
      { role: 'system', content: systemPrompt || '你是一个有帮助的 AI 助手。' },
      ...messageService.toKimiFormat(history)
    ];

    // 4. 调用 Kimi API 流式接口
    let fullContent = '';
    
    try {
      for await (const chunk of kimiClient.chatStream(kimiMessages, { temperature })) {
        const deltaContent = chunk.choices[0]?.delta?.content || '';
        if (deltaContent) {
          fullContent += deltaContent;
          yield { type: 'chunk', content: deltaContent };
        }
      }
    } catch (error) {
      console.error('Stream error:', error);
      throw error;
    }

    // 5. 保存完整回复
    const assistantMessage = messageService.addAssistantMessage(
      agentId, 
      fullContent || '抱歉，我遇到了一些问题。', 
      'rich-text'
    );

    yield { type: 'complete', message: assistantMessage };
  }

  /**
   * 获取聊天历史
   */
  getChatHistory(agentId: string, limit?: number): Message[] {
    return messageService.getMessages(agentId, limit);
  }

  /**
   * 清除聊天历史
   */
  clearChatHistory(agentId: string): void {
    messageService.clearMessages(agentId);
  }
}

export const chatService = new ChatService();
