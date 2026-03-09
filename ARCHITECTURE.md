# EasyClaw 移动端应用架构设计文档

## 1. 项目概述

### 1.1 项目简介
EasyClaw 是一款基于 Flutter 开发的移动端应用，定位为 AI 助手客户端，提供远程控制和 AI 对话功能。用户可以通过该应用与各类 AI Agent 进行交互，管理技能工具，实现智能化任务处理。

### 1.2 核心功能
- **AI 对话**: 与多个 AI Agent 进行实时对话，支持富文本、图片、数据表格等多种消息格式
- **Agent 发现**: 浏览和发现可用的 AI Agent，查看详细信息和工作流
- **技能管理**: 管理各类技能工具，如 PPT 生成、图像增强等
- **远程控制**: 支持 WebSocket 连接远程 PC 进行控制（待实现）

### 1.3 目标平台
- Android
- iOS（可扩展）

---

## 2. 架构设计原则

### 2.1 设计目标
1. **简洁性**: 保持代码结构清晰，易于理解和维护
2. **可测试性**: 业务逻辑与 UI 分离，便于单元测试
3. **可扩展性**: 模块化设计，支持新功能快速接入
4. **响应式**: 状态变更自动触发 UI 更新

### 2.2 架构模式
采用 **Provider 状态管理 + 分层架构** 模式：
- 表现层（UI Layer）: Flutter Widgets
- 状态层（State Layer）: Provider 管理应用状态
- 数据层（Data Layer）: 数据模型和模拟数据

---

## 3. 技术栈

### 3.1 核心技术
| 技术 | 版本 | 用途 |
|------|------|------|
| Flutter SDK | ^3.5.3 | 跨平台 UI 框架 |
| Dart | ^3.5.3 | 编程语言 |

### 3.2 主要依赖
| 包名 | 版本 | 用途 |
|------|------|------|
| provider | ^6.1.2 | 状态管理 |
| http | ^1.2.1 | HTTP 网络请求 |
| web_socket_channel | ^2.4.5 | WebSocket 通信 |
| cached_network_image | ^3.3.1 | 网络图片缓存加载 |
| shared_preferences | ^2.2.3 | 本地持久化存储 |
| google_fonts | ^6.2.1 | 字体管理 |
| cupertino_icons | ^1.0.8 | iOS 风格图标 |

---

## 4. 目录结构

```
easyclaw_app/
├── android/                    # Android 平台配置
├── ios/                        # iOS 平台配置（预留）
├── lib/                        # 主代码目录
│   ├── main.dart               # 应用入口
│   ├── models/                 # 数据模型层
│   │   ├── agent_model.dart    # AI Agent 数据模型
│   │   ├── message_model.dart  # 消息数据模型
│   │   └── skill_model.dart    # 技能工具数据模型
│   ├── providers/              # 状态管理层
│   │   └── app_provider.dart   # 全局应用状态管理
│   └── screens/                # 页面/UI 层
│       ├── home_screen.dart    # 主页（底部导航容器）
│       ├── chat_tab.dart       # 对话 Tab 页面
│       ├── discover_tab.dart   # 发现 Tab 页面
│       ├── skills_tab.dart     # 技能 Tab 页面
│       ├── profile_tab.dart    # 个人中心 Tab 页面
│       ├── agent_detail_page.dart   # Agent 详情页
│       └── skill_detail_page.dart   # 技能详情页
├── test/                       # 测试目录
├── pubspec.yaml                # 项目依赖配置
└── analysis_options.yaml       # 代码分析配置
```

---

## 5. 数据模型设计

### 5.1 AgentModel - AI Agent 数据模型
```dart
class AgentModel {
  final String id;              // 唯一标识
  final String title;           // 名称
  final String description;     // 描述
  final String tag;             // 标签
  final String status;          // 状态
  final String rating;          // 评分
  final String completed;       // 完成任务数
  final String activeUsers;     // 活跃用户
  final String load;            // 负载
  final String tps;             // 响应速度
  final IconData icon;          // 图标
  final String themeColor;      // 主题色
  final String bgImage;         // 背景图
  final String role;            // 角色定位
  final List<String> expertise; // 专长领域
  final Map<String, String> metrics;        // 性能指标
  final List<Map<String, String>> pipeline; // 工作流
  final String recentAchievement;           // 近期成就
}
```

### 5.2 MessageModel - 消息数据模型
```dart
class MessageModel {
  final int id;                 // 消息 ID
  final String role;            // 角色：user/assistant
  final String agentId;         // 所属 Agent ID
  final String content;         // 内容
  final String? type;           // 类型：rich-text/data-table
  final AttachmentModel? attachment;   // 附件
  final List<TableRowModel>? tableData; // 表格数据
}

class AttachmentModel {
  final String type;    // 类型：image
  final String url;     // URL
  final String caption; // 说明
}

class TableRowModel {
  final String item;    // 项目
  final String value;   // 值
  final String status;  // 状态
}
```

### 5.3 SkillModel - 技能工具数据模型
```dart
class SkillModel {
  final String id;          // 唯一标识
  final String title;       // 名称
  final String description; // 描述
  final IconData icon;      // 图标
  final String tag;         // 标签
  final double rating;      // 评分
  final String users;       // 用户数
  final String latency;     // 延迟
  final String stack;       // 技术栈
  final String performance; // 性能
  final String details;     // 详情
  final List<String> features; // 特性列表
  final String usage;       // 使用方式
  final String version;     // 版本
  final String category;    // 分类
}
```

---

## 6. 状态管理设计

### 6.1 架构选择
采用 **Provider** 作为状态管理方案：
- 轻量级，适合中小型项目
- 与 Flutter 官方集成良好
- 学习成本低，团队易上手

### 6.2 AppProvider 核心状态
```dart
class AppProvider extends ChangeNotifier {
  // 导航状态
  String _activeTab;           // 当前激活 Tab
  
  // 选择状态
  AgentModel? _selectedAgent;  // 选中的 Agent（用于详情页）
  SkillModel? _selectedSkill;  // 选中的 Skill（用于详情页）
  AgentModel? _currentChatAgent; // 当前对话的 Agent
  
  // 输入状态
  String _inputText;           // 输入框文本
  
  // 数据状态
  List<MessageModel> _messages; // 消息列表
  
  // UI 状态
  bool _isTyping;              // 是否正在输入/处理
  bool _isConnected;           // 连接状态
  String _connectionStatus;    // 连接状态文本
  
  // 用户状态
  int _credits;                // 积分
  int _uptime;                 // 运行时间
  
  // 数据集合
  List<AgentModel> get discoverAgents;  // 可发现的 Agents
  List<SkillModel> get skillTools;      // 技能工具列表
}
```

### 6.3 状态更新流程
```
用户操作 → 调用 Provider 方法 → 修改状态 → notifyListeners() → UI 重建
```

### 6.4 状态持久化策略
- **当前**: 数据存储在内存中（Provider）
- **未来扩展**: 
  - 使用 `shared_preferences` 存储用户配置
  - 使用本地数据库（如 Hive/SQLite）存储历史消息
  - 后端 API 持久化对话记录

---

## 7. 模块划分

### 7.1 模块结构图
```
┌─────────────────────────────────────────────────────────┐
│                      EasyClaw App                        │
├─────────────┬─────────────┬─────────────┬───────────────┤
│   Chat      │  Discover   │   Skills    │    Profile    │
│   Module    │   Module    │   Module    │    Module     │
├─────────────┼─────────────┼─────────────┼───────────────┤
│ • 消息列表   │ • Agent 卡片 │ • 技能卡片   │ • 连接状态    │
│ • 输入框     │ • 详情页     │ • 详情页     │ • 用户设置    │
│ • Agent 切换 │ • 工作流展示 │ • 使用说明   │ • 积分显示    │
│ • 附件展示   │ • 性能指标   │ • 性能数据   │ • 系统信息    │
└─────────────┴─────────────┴─────────────┴───────────────┘
                    ↕ 共享状态 (AppProvider)
```

### 7.2 各模块职责

#### 7.2.1 Chat 模块（对话模块）
- **页面**: `chat_tab.dart`
- **功能**:
  - 展示与当前 Agent 的对话历史
  - 支持文本、图片、表格等多种消息格式
  - Agent 头像快速切换
  - 连接状态指示器
  - 消息输入和发送

#### 7.2.2 Discover 模块（发现模块）
- **页面**: `discover_tab.dart`, `agent_detail_page.dart`
- **功能**:
  - 展示可用的 AI Agent 列表
  - Agent 详情展示（角色、专长、工作流、指标）
  - 一键开始对话

#### 7.2.3 Skills 模块（技能模块）
- **页面**: `skills_tab.dart`, `skill_detail_page.dart`
- **功能**:
  - 展示技能工具列表
  - 技能详情（特性、使用方法、性能数据）
  - 分类浏览

#### 7.2.4 Profile 模块（个人中心模块）
- **页面**: `profile_tab.dart`
- **功能**:
  - 远程连接管理
  - 用户积分和运行时间展示
  - 系统设置入口

---

## 8. UI 设计规范

### 8.1 色彩系统
| 用途 | 颜色值 | 说明 |
|------|--------|------|
| 主色调 | `#EF4444` | 红色，用于激活状态、按钮 |
| 背景色 | `#FFFFFF` | 白色主背景 |
| 次级背景 | `#F9FAFB` | 浅灰色，用于输入框、卡片 |
| 文字主色 | `#111827` | 深灰色 |
| 文字次色 | `#6B7280` | 中灰色 |
| 禁用色 | `#D1D5DB` | 浅灰色 |
| 成功色 | `#22C55E` | 绿色（在线状态）|

### 8.2 字体规范
- **主字体**: Google Fonts - Inter
- **标题**: 24px, FontWeight.w900, 斜体
- **正文**: 13-14px, FontWeight.w500/w600
- **标签**: 10-11px, FontWeight.w900, 大写字母间距

### 8.3 圆角规范
- **卡片**: 20-24px
- **按钮**: 12-24px
- **头像**: 12-14px
- **输入框**: 24px

---

## 9. 网络通信设计

### 9.1 当前实现
- **HTTP**: 使用 `http` 包进行 RESTful API 调用
- **WebSocket**: 使用 `web_socket_channel` 包（已集成，待实现完整功能）

### 9.2 通信流程
```
┌──────────┐     HTTP/WebSocket      ┌──────────┐
│  Mobile  │ ◄──────────────────────► │  Server  │
│   App    │                         │          │
└──────────┘                         └──────────┘
     │                                    │
     │ 1. 发送消息                        │
     │ ────────────────────────────────► │
     │                                    │
     │ 2. AI 处理                         │
     │ ◄───────────────────────────────  │
     │                                    │
     │ 3. 接收响应                        │
     │ ◄───────────────────────────────  │
```

### 9.3 待实现功能
- WebSocket 连接管理
- 心跳保活机制
- 断线重连逻辑
- 消息队列（离线消息）

---

## 10. 扩展性考虑

### 10.1 功能扩展
| 扩展方向 | 实现建议 |
|----------|----------|
| 新增 Agent | 在 `AppProvider` 中添加 Agent 数据 |
| 新增技能 | 在 `AppProvider` 中添加 Skill 数据 |
| 新消息类型 | 扩展 `MessageModel` 的 type 字段和解析逻辑 |
| 深色模式 | 添加 ThemeProvider 管理主题状态 |
| 多语言 | 集成 flutter_localizations 和 ARB 文件 |

### 10.2 架构演进路线
```
当前架构 ──► 添加 Repository 层 ──► 集成后端 API ──► 添加本地缓存
   │                │                   │                │
   │                │                   │                ▼
   │                │                   │           离线支持
   │                │                   ▼
   │                │           用户认证/数据同步
   │                ▼
   │        数据抽象层（支持多数据源）
   ▼
考虑迁移至 BLoC/Riverpod（项目规模扩大时）
```

### 10.3 性能优化建议
1. **列表优化**: 使用 `ListView.builder` 实现懒加载
2. **图片优化**: 使用 `cached_network_image` 缓存网络图片
3. **状态优化**: 细粒度拆分 Provider，避免不必要的重建
4. **动画优化**: 使用 `AnimatedContainer` 等内置动画组件

---

## 11. 开发规范

### 11.1 代码规范
- 遵循 `flutter_lints` 推荐的代码规范
- 使用 `const` 构造函数优化性能
- Widget 拆分为小型、可复用的组件

### 11.2 命名规范
| 类型 | 命名方式 | 示例 |
|------|----------|------|
| 类名 | 大驼峰 | `AgentModel`, `ChatTab` |
| 文件名 | 小写下划线 | `agent_model.dart`, `chat_tab.dart` |
| 变量/函数 | 小驼峰 | `selectedAgent`, `sendMessage()` |
| 常量 | 大写下划线 | `DEFAULT_TIMEOUT` |

### 11.3 提交规范
```
<type>: <subject>

<body>

type:
- feat: 新功能
- fix: 修复
- docs: 文档
- style: 格式（不影响代码运行）
- refactor: 重构
- test: 测试
- chore: 构建/工具
```

---

## 12. 附录

### 12.1 依赖版本锁定
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.1.2
  google_fonts: ^6.2.1
  cached_network_image: ^3.3.1
  http: ^1.2.1
  web_socket_channel: ^2.4.5
  shared_preferences: ^2.2.3
```

### 12.2 参考资料
- [Flutter 官方文档](https://docs.flutter.dev/)
- [Provider 官方文档](https://pub.dev/packages/provider)
- [Material Design 3 规范](https://m3.material.io/)

---

**文档版本**: v1.0  
**最后更新**: 2025-03-04  
**作者**: EasyClaw Team
