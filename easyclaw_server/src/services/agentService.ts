/**
 * Agent 服务
 * 处理 Agent 相关的业务逻辑
 */
import { store } from './store';
import { Agent } from '../types';

export class AgentService {
  /**
   * 获取所有 Agents
   */
  getAllAgents(): Agent[] {
    return store.getAllAgents();
  }

  /**
   * 根据 ID 获取 Agent
   */
  getAgentById(id: string): Agent | null {
    return store.getAgentById(id) || null;
  }

  /**
   * 获取 Agent 的系统提示词
   */
  getAgentSystemPrompt(agentId: string): string | null {
    const agent = this.getAgentById(agentId);
    if (!agent) return null;
    
    return agent.systemPrompt || `你是 ${agent.title}，${agent.role}。你的专长包括：${agent.expertise.join('、')}。请根据用户的问题提供专业、准确、有帮助的回答。`;
  }

  /**
   * 按标签筛选 Agents
   */
  getAgentsByTag(tag: string): Agent[] {
    return this.getAllAgents().filter(agent => 
      agent.tag.toLowerCase().includes(tag.toLowerCase())
    );
  }

  /**
   * 搜索 Agents
   */
  searchAgents(query: string): Agent[] {
    const lowerQuery = query.toLowerCase();
    return this.getAllAgents().filter(agent => 
      agent.title.toLowerCase().includes(lowerQuery) ||
      agent.description.toLowerCase().includes(lowerQuery) ||
      agent.tag.toLowerCase().includes(lowerQuery)
    );
  }
}

export const agentService = new AgentService();
