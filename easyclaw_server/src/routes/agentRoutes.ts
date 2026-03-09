/**
 * Agent 路由
 */
import { Router } from 'express';
import { agentController } from '../controllers/agentController';

const router = Router();

// GET /api/agents - 获取所有 Agents
router.get('/', agentController.getAllAgents);

// GET /api/agents/search?q=xxx - 搜索 Agents
router.get('/search', agentController.searchAgents);

// GET /api/agents/:id - 获取单个 Agent
router.get('/:id', agentController.getAgentById);

export default router;
