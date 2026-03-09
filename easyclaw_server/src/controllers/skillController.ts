/**
 * Skill 控制器
 */
import { Request, Response } from 'express';
import { skillService } from '../services/skillService';
import { ApiResponse } from '../types';

export const skillController = {
  /**
   * 获取所有 Skills
   */
  getAllSkills(req: Request, res: Response) {
    try {
      const skills = skillService.getAllSkills();
      const response: ApiResponse = {
        success: true,
        data: skills,
        meta: { total: skills.length }
      };
      res.json(response);
    } catch (error) {
      console.error('Error getting skills:', error);
      const response: ApiResponse = {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to get skills'
        }
      };
      res.status(500).json(response);
    }
  },

  /**
   * 根据 ID 获取 Skill
   */
  getSkillById(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const skill = skillService.getSkillById(id);
      
      if (!skill) {
        const response: ApiResponse = {
          success: false,
          error: {
            code: 'NOT_FOUND',
            message: `Skill with id ${id} not found`
          }
        };
        res.status(404).json(response);
        return;
      }
      
      const response: ApiResponse = {
        success: true,
        data: skill
      };
      res.json(response);
    } catch (error) {
      console.error('Error getting skill:', error);
      const response: ApiResponse = {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to get skill'
        }
      };
      res.status(500).json(response);
    }
  },

  /**
   * 获取所有分类
   */
  getCategories(req: Request, res: Response) {
    try {
      const categories = skillService.getCategories();
      const response: ApiResponse = {
        success: true,
        data: categories
      };
      res.json(response);
    } catch (error) {
      console.error('Error getting categories:', error);
      const response: ApiResponse = {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to get categories'
        }
      };
      res.status(500).json(response);
    }
  },

  /**
   * 搜索 Skills
   */
  searchSkills(req: Request, res: Response) {
    try {
      const { q } = req.query;
      
      if (!q || typeof q !== 'string') {
        const response: ApiResponse = {
          success: false,
          error: {
            code: 'BAD_REQUEST',
            message: 'Query parameter "q" is required'
          }
        };
        res.status(400).json(response);
        return;
      }
      
      const skills = skillService.searchSkills(q);
      const response: ApiResponse = {
        success: true,
        data: skills,
        meta: { total: skills.length }
      };
      res.json(response);
    } catch (error) {
      console.error('Error searching skills:', error);
      const response: ApiResponse = {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to search skills'
        }
      };
      res.status(500).json(response);
    }
  }
};
