/**
 * Skill 路由
 */
import { Router } from 'express';
import { skillController } from '../controllers/skillController';

const router = Router();

// GET /api/skills - 获取所有 Skills
router.get('/', skillController.getAllSkills);

// GET /api/skills/categories - 获取所有分类
router.get('/categories', skillController.getCategories);

// GET /api/skills/search?q=xxx - 搜索 Skills
router.get('/search', skillController.searchSkills);

// GET /api/skills/:id - 获取单个 Skill
router.get('/:id', skillController.getSkillById);

export default router;
