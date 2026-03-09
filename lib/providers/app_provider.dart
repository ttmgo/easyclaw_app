import 'package:flutter/material.dart';
import '../models/agent_model.dart';
import '../models/skill_model.dart';
import '../models/message_model.dart';

class AppProvider extends ChangeNotifier {
  String _activeTab = 'chat';
  AgentModel? _selectedAgent;
  SkillModel? _selectedSkill;
  AgentModel? _currentChatAgent;
  String _inputText = '';
  List<MessageModel> _messages = [];
  bool _isTyping = false;
  bool _isConnected = false;
  String _connectionStatus = 'OFFLINE';
  int _credits = 2400;
  int _uptime = 142;

  // Getters
  String get activeTab => _activeTab;
  AgentModel? get selectedAgent => _selectedAgent;
  SkillModel? get selectedSkill => _selectedSkill;
  AgentModel? get currentChatAgent => _currentChatAgent;
  String get inputText => _inputText;
  List<MessageModel> get messages => _messages;
  bool get isTyping => _isTyping;
  bool get isConnected => _isConnected;
  String get connectionStatus => _connectionStatus;
  int get credits => _credits;
  int get uptime => _uptime;

  // Discover Agents 数据
  List<AgentModel> get discoverAgents => [
    AgentModel(
      id: 'd1',
      title: "AI 影視導演 LEO",
      description: "跨模型電影級影像調度與分鏡設計，專攻視覺語言重構。",
      tag: "影視製作",
      status: "High Efficiency",
      rating: "9.9",
      completed: "1,240",
      activeUsers: "420",
      load: "28%",
      tps: "12.5s/clip",
      icon: Icons.movie,
      themeColor: "from-gray-900 via-blue-900 to-black",
      bgImage: "https://images.unsplash.com/photo-1478720568477-152d9b164e26?auto=format&fit=crop&q=80&w=600",
      role: "全能型 AI 導演。精通影視調色、分鏡設計與多模型協同工作流。LEO 通過自動化腳本解析，能將文字劇本瞬間轉化為具備攝影機參數的視覺分鏡。",
      expertise: ["分鏡指令優化", "動態運鏡控制", "視覺氛圍渲染", "多機位調度"],
      metrics: {"logic": "98.5%", "creative": "94.2%", "speed": "0.4s/frame"},
      pipeline: [
        {"step": "腳本結構拆解", "desc": "利用 NLP 提取情感基調與場景要素"},
        {"step": "視覺語法對齊", "desc": "匹配特定的電影大師鏡頭語言"},
        {"step": "多模型調度渲染", "desc": "調用 Sora/Runway 接口生成動態預覽"}
      ],
      recentAchievement: "為《賽博重慶 2077》提供全案視覺調度支持，節省了 70% 的前期溝通成本。",
    ),
    AgentModel(
      id: 'd2',
      title: "爆文營銷架構師",
      description: "基於大數據挖掘的社交媒體增長解決方案，擅長病毒式傳播分析。",
      tag: "社交媒體",
      status: "Peak Demand",
      rating: "9.8",
      completed: "8,502",
      activeUsers: "1,120",
      load: "92%",
      tps: "0.8s/post",
      icon: Icons.share,
      themeColor: "from-rose-900 via-pink-900 to-black",
      bgImage: "https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?auto=format&fit=crop&q=80&w=600",
      role: "小紅書爆款教父。擅長精準流量挖掘與種草視覺排版。通過實時追蹤 500+ 熱點標籤，自動生成最具點擊慾望的封面與文案組合。",
      expertise: ["CTR 優化", "情緒捕獲", "SEO 滲透", "流量估算"],
      metrics: {"logic": "92.0%", "creative": "99.1%", "speed": "0.1s/idea"},
      pipeline: [
        {"step": "熱點情緒掃描", "desc": "實時分析當前社交媒體情緒波動"},
        {"step": "爆發點文案預測", "desc": "基於歷史 10w+ 爆款案例進行風格遷移"},
        {"step": "排版視覺實驗", "desc": "A/B 測試最有效的視覺構圖"}
      ],
      recentAchievement: "單月助力 12 個品牌實現小紅書互動量 300% 增長。",
    ),
  ];

  // Skills 数据
  List<SkillModel> get skillTools => [
    SkillModel(
      id: 's1',
      title: "PPT 結構化引擎",
      description: "邏輯抽取與佈局映射。",
      icon: Icons.description,
      tag: "Office",
      rating: 4.9,
      users: "45k+",
      latency: "450ms",
      stack: "NLP-Schema-v4",
      performance: "98.2%",
      details: "支持從非結構化文本中提取核心邏輯，並自動生成商務級 PPT 頁面佈局與配圖建議。",
      features: ["自動目錄生成", "視覺權重優化", "多樣式主題遷移"],
      usage: "curl -X POST /v1/ppt-gen -d 'content=...' ",
      version: "stable-1.2.0",
      category: "生產力工具"
    ),
    SkillModel(
      id: 's2',
      title: "4K Super-Res",
      description: "神經網絡像素重構。",
      icon: Icons.auto_fix_high,
      tag: "Vision",
      rating: 4.8,
      users: "12k+",
      latency: "1.2s",
      stack: "ESRGAN-Custom",
      performance: "94.5%",
      details: "專為低分辨率 AI 生成圖優化，提供無損放大至 4K 分辨率的能力，保留細微紋理細節。",
      features: ["超分辨率重建", "噪點抑制", "邊緣平滑處理"],
      usage: "python run.py --input raw.png --scale 4x",
      version: "vision-v3-beta",
      category: "視覺增強"
    ),
  ];

  // Setters
  void setActiveTab(String tab) {
    _activeTab = tab;
    notifyListeners();
  }

  void setSelectedAgent(AgentModel? agent) {
    _selectedAgent = agent;
    notifyListeners();
  }

  void setSelectedSkill(SkillModel? skill) {
    _selectedSkill = skill;
    notifyListeners();
  }

  void setCurrentChatAgent(AgentModel? agent) {
    _currentChatAgent = agent;
    notifyListeners();
  }

  void setInputText(String text) {
    _inputText = text;
    notifyListeners();
  }

  void setIsTyping(bool typing) {
    _isTyping = typing;
    notifyListeners();
  }

  // Actions
  void initialize() {
    // 添加初始消息
    _messages = [
      MessageModel(
        id: 1,
        role: 'assistant',
        agentId: 'd1',
        content: "您好，我是 LEO。關於您要求的『賽博城市特寫』，我已完成分鏡規劃。這是初步生成的視覺風格參考與參數報告：",
        type: 'rich-text',
        attachment: AttachmentModel(
          type: 'image',
          url: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?auto=format&fit=crop&q=80&w=600',
          caption: '分鏡 A-01: 霓虹水窪特寫'
        ),
      ),
      MessageModel(
        id: 2,
        role: 'assistant',
        agentId: 'd2',
        content: "已為您的咖啡機品牌掃描熱點。當前「極簡主義」與「復古未來」標籤正在急劇上升，這是為您生成的文案框架與數據預測：",
        type: 'data-table',
        tableData: [
          TableRowModel(item: '預期點擊率', value: '8.4%', status: 'high'),
          TableRowModel(item: '核心關鍵字', value: '#氛圍感 #早C晚A', status: 'optimal'),
          TableRowModel(item: '建議發佈時段', value: '21:00 - 22:30', status: 'optimal'),
        ],
      ),
    ];
    _currentChatAgent = discoverAgents[0];
    notifyListeners();
  }

  void sendMessage(String content) {
    if (content.trim().isEmpty || _currentChatAgent == null) return;

    // 添加用户消息
    _messages.add(MessageModel(
      id: DateTime.now().millisecondsSinceEpoch,
      role: 'user',
      agentId: _currentChatAgent!.id,
      content: content,
    ));
    _inputText = '';
    _isTyping = true;
    notifyListeners();

    // 模拟AI响应
    Future.delayed(const Duration(milliseconds: 1500), () {
      _messages.add(MessageModel(
        id: DateTime.now().millisecondsSinceEpoch + 1,
        role: 'assistant',
        agentId: _currentChatAgent!.id,
        content: "已根據「$content」調用底層內核，處理結果已準備就緒。",
      ));
      _isTyping = false;
      notifyListeners();
    });
  }

  void startChatWithAgent(AgentModel agent) {
    _currentChatAgent = agent;
    _activeTab = 'chat';
    _selectedAgent = null;
    _selectedSkill = null;
    notifyListeners();
  }

  // 远程连接功能（占位）
  Future<void> connectToPC(String address) async {
    // TODO: 实现WebSocket连接
    _connectionStatus = 'CONNECTING...';
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));
    
    _isConnected = true;
    _connectionStatus = 'ONLINE';
    notifyListeners();
  }

  void disconnect() {
    _isConnected = false;
    _connectionStatus = 'OFFLINE';
    notifyListeners();
  }

  // 获取当前Agent的消息
  List<MessageModel> get currentAgentMessages {
    if (_currentChatAgent == null) return [];
    return _messages.where((m) => m.agentId == _currentChatAgent!.id).toList();
  }
}
