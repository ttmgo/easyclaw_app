/**
 * Kimi API 客户端
 * 封装与 Kimi K2.5 API 的通信
 */
import { config } from '../config';
import { KimiChatRequest, KimiMessage, KimiChatResponse, KimiStreamChunk } from '../types';

export class KimiClient {
  private apiKey: string;
  private baseUrl: string;
  private model: string;

  constructor() {
    this.apiKey = config.kimi.apiKey;
    this.baseUrl = config.kimi.baseUrl;
    this.model = config.kimi.model;
  }

  /**
   * 非流式聊天请求
   */
  async chat(messages: KimiMessage[], options?: Partial<KimiChatRequest>): Promise<KimiChatResponse> {
    if (!this.apiKey) {
      throw new Error('KIMI_API_KEY is not configured');
    }

    const requestBody: KimiChatRequest = {
      model: this.model,
      messages,
      temperature: options?.temperature ?? config.kimi.temperature,
      top_p: options?.top_p ?? config.kimi.topP,
      max_tokens: options?.max_tokens ?? config.kimi.maxTokens,
      stream: false,
    };

    try {
      const response = await fetch(`${this.baseUrl}/chat/completions`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.apiKey}`,
        },
        body: JSON.stringify(requestBody),
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(
          `Kimi API error: ${response.status} ${response.statusText} - ${errorData.error?.message || 'Unknown error'}`
        );
      }

      return await response.json() as KimiChatResponse;
    } catch (error) {
      console.error('Kimi API request failed:', error);
      throw error;
    }
  }

  /**
   * 流式聊天请求
   * 返回一个异步生成器，用于 SSE 流式响应
   */
  async *chatStream(
    messages: KimiMessage[],
    options?: Partial<KimiChatRequest>
  ): AsyncGenerator<KimiStreamChunk, void, unknown> {
    if (!this.apiKey) {
      throw new Error('KIMI_API_KEY is not configured');
    }

    const requestBody: KimiChatRequest = {
      model: this.model,
      messages,
      temperature: options?.temperature ?? config.kimi.temperature,
      top_p: options?.top_p ?? config.kimi.topP,
      max_tokens: options?.max_tokens ?? config.kimi.maxTokens,
      stream: true,
    };

    try {
      const response = await fetch(`${this.baseUrl}/chat/completions`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.apiKey}`,
          'Accept': 'text/event-stream',
        },
        body: JSON.stringify(requestBody),
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(
          `Kimi API error: ${response.status} ${response.statusText} - ${errorData.error?.message || 'Unknown error'}`
        );
      }

      const reader = response.body?.getReader();
      if (!reader) {
        throw new Error('Response body is not readable');
      }

      const decoder = new TextDecoder();
      let buffer = '';

      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        buffer += decoder.decode(value, { stream: true });
        const lines = buffer.split('\n');
        buffer = lines.pop() || '';

        for (const line of lines) {
          const trimmedLine = line.trim();
          if (!trimmedLine || trimmedLine === 'data: [DONE]') continue;
          
          if (trimmedLine.startsWith('data: ')) {
            try {
              const jsonData = JSON.parse(trimmedLine.slice(6));
              yield jsonData as KimiStreamChunk;
            } catch (e) {
              console.warn('Failed to parse SSE data:', trimmedLine);
            }
          }
        }
      }
    } catch (error) {
      console.error('Kimi API stream request failed:', error);
      throw error;
    }
  }

  /**
   * 构建系统提示词
   */
  buildSystemPrompt(agentRole: string, expertise: string[]): string {
    return `你是 ${agentRole}。你的专长包括：${expertise.join('、')}。

请根据用户的问题提供专业、准确、有帮助的回答。在回答时：
1. 保持专业但友好的语气
2. 给出具体、可执行的建议
3. 如果涉及技术内容，提供清晰的解释
4. 在适当的时候使用结构化格式（如列表、表格）来组织信息

记住：你的目标是帮助用户高效地完成任务。`;
  }
}

// 导出单例实例
export const kimiClient = new KimiClient();
