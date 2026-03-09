/**
 * 内存存储服务
 * 用于存储 Agents、Skills、Messages 等数据
 * 生产环境应替换为数据库
 */
import { Agent, Skill, Message } from '../types';

class MemoryStore {
  private agents: Map<string, Agent> = new Map();
  private skills: Map<string, Skill> = new Map();
  private messages: Map<string, Message[]> = new Map(); // agentId -> messages

  constructor() {
    this.initializeData();
  }

  private initializeData() {
    // 初始化 Agents 数据
    const agentsData: Agent[] = [
      {
        id: 'd1',
        title: 'AI 影視導演 LEO',
        description: '跨模型電影級影像調度與分鏡設計，專攻視覺語言重構。',
        tag: '影視製作',
        status: 'High Efficiency',
        rating: '9.9',
        completed: '1,240',
        activeUsers: '420',
        load: '28%',
        tps: '12.5s/clip',
        icon: 'movie',
        themeColor: 'from-gray-900 via-blue-900 to-black',
        bgImage: 'https://images.unsplash.com/photo-1478720568477-152d9b164e26?auto=format&fit=crop&q=80&w=600',
        role: '全能型 AI 導演。精通影視調色、分鏡設計與多模型協同工作流。LEO 通過自動化腳本解析，能將文字劇本瞬間轉化為具備攝影機參數的視覺分鏡。',
        expertise: ['分鏡指令優化', '動態運鏡控制', '視覺氛圍渲染', '多機位調度'],
        metrics: { logic: '98.5%', creative: '94.2%', speed: '0.4s/frame' },
        pipeline: [
          { step: '腳本結構拆解', desc: '利用 NLP 提取情感基調與場景要素' },
          { step: '視覺語法對齊', desc: '匹配特定的電影大師鏡頭語言' },
          { step: '多模型調度渲染', desc: '調用 Sora/Runway 接口生成動態預覽' }
        ],
        recentAchievement: '為《賽博重慶 2077》提供全案視覺調度支持，節省了 70% 的前期溝通成本。',
        systemPrompt: '你是 AI 影視導演 LEO，專攻影視製作和視覺語言重構。你擅長分鏡設計、動態運鏡控制和視覺氛圍渲染。請以專業導演的角度為用戶提供影視製作相關的建議和指導。'
      },
      {
        id: 'd2',
        title: '爆文營銷架構師',
        description: '基於大數據挖掘的社交媒體增長解決方案，擅長病毒式傳播分析。',
        tag: '社交媒體',
        status: 'Peak Demand',
        rating: '9.8',
        completed: '8,502',
        activeUsers: '1,120',
        load: '92%',
        tps: '0.8s/post',
        icon: 'share',
        themeColor: 'from-rose-900 via-pink-900 to-black',
        bgImage: 'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?auto=format&fit=crop&q=80&w=600',
        role: '小紅書爆款教父。擅長精準流量挖掘與種草視覺排版。通過實時追蹤 500+ 熱點標籤，自動生成最具點擊慾望的封面與文案組合。',
        expertise: ['CTR 優化', '情緒捕獲', 'SEO 滲透', '流量估算'],
        metrics: { logic: '92.0%', creative: '99.1%', speed: '0.1s/idea' },
        pipeline: [
          { step: '熱點情緒掃描', desc: '實時分析當前社交媒體情緒波動' },
          { step: '爆發點文案預測', desc: '基於歷史 10w+ 爆款案例進行風格遷移' },
          { step: '排版視覺實驗', desc: 'A/B 測試最有效的視覺構圖' }
        ],
        recentAchievement: '單月助力 12 個品牌實現小紅書互動量 300% 增長。',
        systemPrompt: '你是爆文營銷架構師，社交媒體營銷專家。你擅長 CTR 優化、情緒捕獲、SEO 滲透和流量估算。請為用戶提供專業的社交媒體內容策略和營銷建議。'
      },
      {
        id: 'd3',
        title: '全棧開發助手',
        description: '精通前後端開發、系統架構設計和代碼優化。',
        tag: '技術開發',
        status: 'Available',
        rating: '9.7',
        completed: '3,240',
        activeUsers: '890',
        load: '45%',
        tps: '0.5s/req',
        icon: 'code',
        themeColor: 'from-blue-900 via-indigo-900 to-black',
        bgImage: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?auto=format&fit=crop&q=80&w=600',
        role: '經驗豐富的全棧工程師。擅長 React、Node.js、Python 等技術棧，能夠幫助解決複雜的技術問題和系統架構設計。',
        expertise: ['前端開發', '後端架構', '數據庫設計', '性能優化'],
        metrics: { logic: '96.5%', creative: '88.2%', speed: '0.3s/line' },
        pipeline: [
          { step: '需求分析', desc: '理解用戶需求並拆解技術任務' },
          { step: '方案設計', desc: '設計最優技術方案和架構' },
          { step: '代碼實現', desc: '編寫高質量、可維護的代碼' }
        ],
        recentAchievement: '協助 50+ 團隊完成技術架構升級，平均性能提升 40%。',
        systemPrompt: '你是全棧開發助手，精通各種編程語言和框架。請為用戶提供專業的技術建議、代碼 review、bug 調試和架構設計指導。回答要清晰、準確，並提供具體的代碼示例。'
      }
    ];

    agentsData.forEach(agent => this.agents.set(agent.id, agent));

    // 初始化 Skills 数据
    const skillsData: Skill[] = [
      {
        id: 's1',
        title: 'PPT 結構化引擎',
        description: '邏輯抽取與佈局映射。',
        icon: 'description',
        tag: 'Office',
        rating: 4.9,
        users: '45k+',
        latency: '450ms',
        stack: 'NLP-Schema-v4',
        performance: '98.2%',
        details: '支持從非結構化文本中提取核心邏輯，並自動生成商務級 PPT 頁面佈局與配圖建議。',
        features: ['自動目錄生成', '視覺權重優化', '多樣式主題遷移'],
        usage: 'curl -X POST /v1/ppt-gen -d \'content=...\'',
        version: 'stable-1.2.0',
        category: '生產力工具'
      },
      {
        id: 's2',
        title: '4K Super-Res',
        description: '神經網絡像素重構。',
        icon: 'auto_fix_high',
        tag: 'Vision',
        rating: 4.8,
        users: '12k+',
        latency: '1.2s',
        stack: 'ESRGAN-Custom',
        performance: '94.5%',
        details: '專為低分辨率 AI 生成圖優化，提供無損放大至 4K 分辨率的能力，保留細微紋理細節。',
        features: ['超分辨率重建', '噪點抑制', '邊緣平滑處理'],
        usage: 'python run.py --input raw.png --scale 4x',
        version: 'vision-v3-beta',
        category: '視覺增強'
      },
      {
        id: 's3',
        title: '智能代碼審查',
        description: '自動化代碼質量分析與優化建議。',
        icon: 'fact_check',
        tag: 'DevOps',
        rating: 4.7,
        users: '8k+',
        latency: '800ms',
        stack: 'AST-Analyzer-v2',
        performance: '96.8%',
        details: '基於抽象語法樹的深度代碼分析，自動檢測潛在 bug、安全漏洞和性能瓶頸，提供具體的修復建議。',
        features: ['Bug 預測', '安全掃描', '性能分析', '風格檢查'],
        usage: 'POST /v1/code-review { "code": "...", "language": "python" }',
        version: 'dev-2.1.0',
        category: '開發工具'
      }
    ];

    skillsData.forEach(skill => this.skills.set(skill.id, skill));
  }

  // Agent 操作
  getAllAgents(): Agent[] {
    return Array.from(this.agents.values());
  }

  getAgentById(id: string): Agent | undefined {
    return this.agents.get(id);
  }

  // Skill 操作
  getAllSkills(): Skill[] {
    return Array.from(this.skills.values());
  }

  getSkillById(id: string): Skill | undefined {
    return this.skills.get(id);
  }

  // Message 操作
  getMessagesByAgentId(agentId: string): Message[] {
    return this.messages.get(agentId) || [];
  }

  addMessage(agentId: string, message: Message): void {
    if (!this.messages.has(agentId)) {
      this.messages.set(agentId, []);
    }
    this.messages.get(agentId)!.push(message);
  }

  clearMessages(agentId: string): void {
    this.messages.delete(agentId);
  }
}

// 导出单例实例
export const store = new MemoryStore();
