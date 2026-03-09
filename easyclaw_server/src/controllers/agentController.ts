/**
 * Agent 控制器
 */
import { Request, Response } from 'express';
import { agentService } from '../services/agentService';
import { ApiResponse } from '../types';

export const agentController = {
  /**
   * 获取所有 Agents
   */
  getAllAgents(req: Request, res: Response) {
    try {
      const agents = agentService.getAllAgents();
      const response: ApiResponse = {
        success: true,
        data: agents,
        meta: { total: agents.length }
      };
      res.json(response);
    } catch (error) {
      console.error('Error getting agents:', error);
      const response: ApiResponse = {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to get agents'
        }
      };
      res.status(500).json(response);
    }
  },

  /**
   * 根据 ID 获取 Agent
   */
  getAgentById(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const agent = agentService.getAgentById(id);
      
      if (!agent) {
        const response: ApiResponse = {
          success: false,
          error: {
            code: 'NOT_FOUND',
            message: `Agent with id ${id} not found`
          }
        };
        res.status(404).json(response);
        return;
      }
      
      const response: ApiResponse = {
        success: true,
        data: agent
      };
      res.json(response);
    } catch (error) {
      console.error('Error getting agent:', error);
      const response: ApiResponse = {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to get agent'
        }
      };
      res.status(500).json(response);
    }
  },

  /**
   * 搜索 Agents
   */
  searchAgents(req: Request, res: Response) {
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
      
      const agents = agentService.searchAgents(q);
      const response: ApiResponse = {
        success: true,
        data: agents,
        meta: { total: agents.length }
      };
      res.json(response);
    } catch (error) {
      console.error('Error searching agents:', error);
      const response: ApiResponse = {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to search agents'
        }
      };
      res.status(500).json(response);
    }
  }
};
