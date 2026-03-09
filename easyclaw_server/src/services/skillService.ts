/*
 * Skill 服务
 * 处理 Skill 相关的业务逻辑
 */
import { store } from './store';
import { Skill } from '../types';

export class SkillService {
  /**
   * 获取所有 Skills
   */
  getAllSkills(): Skill[] {
    return store.getAllSkills();
  }

  /**
   * 根据 ID 获取 Skill
   */
  getSkillById(id: string): Skill | null {
    return store.getSkillById(id) || null;
  }

  /**
   * 按分类获取 Skills
   */
  getSkillsByCategory(category: string): Skill[] {
    return this.getAllSkills().filter(skill => 
      skill.category.toLowerCase() === category.toLowerCase()
    );
  }

  /**
   * 搜索 Skills
   */
  searchSkills(query: string): Skill[] {
    const lowerQuery = query.toLowerCase();
    return this.getAllSkills().filter(skill => 
      skill.title.toLowerCase().includes(lowerQuery) ||
      skill.description.toLowerCase().includes(lowerQuery) ||
      skill.category.toLowerCase().includes(lowerQuery)
    );
  }

  /**
   * 获取所有分类
   */
  getCategories(): string[] {
    const categories = new Set<string>();
    this.getAllSkills().forEach(skill => categories.add(skill.category));
    return Array.from(categories);
  }
}

export const skillService = new SkillService();
