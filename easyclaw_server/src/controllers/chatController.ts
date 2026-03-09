/**
 * Chat 控制器
 */
import { Request, Response } from 'express';
import { chatService } from '../services/chatService';
import { ApiResponse } from '../types';

export const chatController = {
  /**
   * 非流式聊天
   */
  async chat(req: Request, res: Response) {
    try {
      const { agentId, content, temperature } = req.body;

      // 参数验证
      if (!agentId || typeof agentId !== 'string') {
        const response: ApiResponse = {
          success: false,
          error: {
            code: 'BAD_REQUEST',
            message: 'agentId is required and must be a string'
          }
        };
        res.status(400).json(response);
        return;
      }

      if (!content || typeof content !== 'string') {
        const response: ApiResponse = {
          success: false,
          error: {
            code: 'BAD_REQUEST',
            message: 'content is required and must be a string'
          }
        };
        res.status(400).json(response);
        return;
      }

      // 调用聊天服务
      const result = await chatService.chat({
        agentId,
        content,
        temperature: temperature ? parseFloat(temperature) : undefined
      });

      const response: ApiResponse = {
        success: true,
        data: result
      };
      res.json(response);
    } catch (error: any) {
      console.error('Error in chat:', error);
      
      // 检查是否是 Agent 不存在的错误
      if (error.message?.includes('Agent not found')) {
        const response: ApiResponse = {
          success: false,
          error: {
            code: 'NOT_FOUND',
            message: error.message
          }
        };
        res.status(404).json(response);
        return;
      }

      // 检查是否是 Kimi API 错误
      if (error.message?.includes('KIMI_API_KEY')) {
        const response: ApiResponse = {
          success: false,
          error: {
            code: 'SERVICE_UNAVAILABLE',
            message: 'AI service is not configured properly'
          }
        };
        res.status(503).json(response);
        return;
      }

      const response: ApiResponse = {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: error.message || 'Failed to process chat request'
        }
      };
      res.status(500).json(response);
    }
  },

  /**
   * 流式聊天 (SSE)
   */
  async chatStream(req: Request, res: Response) {
    try {
      const { agentId, content, temperature } = req.body;

      // 参数验证
      if (!agentId || typeof agentId !== 'string') {
        res.status(400).json({
          success: false,
          error: {
            code: 'BAD_REQUEST',
            message: 'agentId is required and must be a string'
          }
        });
        return;
      }

      if (!content || typeof content !== 'string') {
        res.status(400).json({
          success: false,
          error: {
            code: 'BAD_REQUEST',
            message: 'content is required and must be a string'
          }
        });
        return;
      }

      // 设置 SSE 头
      res.setHeader('Content-Type', 'text/event-stream');
      res.setHeader('Cache-Control', 'no-cache');
      res.setHeader('Connection', 'keep-alive');
      res.setHeader('X-Accel-Buffering', 'no');

      // 发送初始连接确认
      res.write(`data: ${JSON.stringify({ type: 'connected' })}\n\n`);

      // 调用流式聊天服务
      const stream = chatService.chatStream({
        agentId,
        content,
        temperature: temperature ? parseFloat(temperature) : undefined
      });

      for await (const chunk of stream) {
        if (chunk.type === 'chunk') {
          res.write(`data: ${JSON.stringify({ type: 'chunk', content: chunk.content })}\n\n`);
        } else if (chunk.type === 'complete') {
          res.write(`data: ${JSON.stringify({ type: 'complete', message: chunk.message })}\n\n`);
        }
      }

      res.write(`data: ${JSON.stringify({ type: 'done' })}\n\n`);
      res.end();
    } catch (error: any) {
      console.error('Error in chat stream:', error);
      
      // 如果已经设置了 SSE 头，则以 SSE 格式发送错误
      if (!res.headersSent) {
        res.status(500).json({
          success: false,
          error: {
            code: 'INTERNAL_ERROR',
            message: error.message || 'Failed to process chat stream'
          }
        });
      } else {
        res.write(`data: ${JSON.stringify({ type: 'error', message: error.message })}\n\n`);
        res.end();
      }
    }
  },

  /**
   * 获取聊天历史
   */
  getChatHistory(req: Request, res: Response) {
    try {
      const { agentId } = req.params;
      const limit = req.query.limit ? parseInt(req.query.limit as string, 10) : undefined;

      if (!agentId) {
        const response: ApiResponse = {
          success: false,
          error: {
            code: 'BAD_REQUEST',
            message: 'agentId is required'
          }
        };
        res.status(400).json(response);
        return;
      }

      const messages = chatService.getChatHistory(agentId, limit);
      const response: ApiResponse = {
        success: true,
        data: messages,
        meta: { total: messages.length }
      };
      res.json(response);
    } catch (error: any) {
      console.error('Error getting chat history:', error);
      const response: ApiResponse = {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: error.message || 'Failed to get chat history'
        }
      };
      res.status(500).json(response);
    }
  },

  /**
   * 清除聊天历史
   */
  clearChatHistory(req: Request, res: Response) {
    try {
      const { agentId } = req.params;

      if (!agentId) {
        const response: ApiResponse = {
          success: false,
          error: {
            code: 'BAD_REQUEST',
            message: 'agentId is required'
          }
        };
        res.status(400).json(response);
        return;
      }

      chatService.clearChatHistory(agentId);
      const response: ApiResponse = {
        success: true,
        data: { message: 'Chat history cleared successfully' }
      };
      res.json(response);
    } catch (error: any) {
      console.error('Error clearing chat history:', error);
      const response: ApiResponse = {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: error.message || 'Failed to clear chat history'
        }
      };
      res.status(500).json(response);
    }
  }
};
