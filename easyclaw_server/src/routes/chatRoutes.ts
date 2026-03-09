/**
 * Chat 路由
 */
import { Router } from 'express';
import { chatController } from '../controllers/chatController';

const router = Router();

// POST /api/chat - 非流式聊天
router.post('/', chatController.chat);

// POST /api/chat/stream - 流式聊天 (SSE)
router.post('/stream', chatController.chatStream);

// GET /api/chat/history/:agentId - 获取聊天历史
router.get('/history/:agentId', chatController.getChatHistory);

// DELETE /api/chat/history/:agentId - 清除聊天历史
router.delete('/history/:agentId', chatController.clearChatHistory);

export default router;
