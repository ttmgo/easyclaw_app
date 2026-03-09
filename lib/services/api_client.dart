import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

/// EasyClaw API 客户端
/// 用于连接 EasyClaw Server
class EasyClawApiClient {
  static const String baseUrl = 'http://localhost:3000/api';
  static const String wsUrl = 'ws://localhost:3000/ws';
  
  final http.Client _httpClient = http.Client();
  WebSocketChannel? _wsChannel;
  
  /// 获取所有 Agents
  Future<List<dynamic>> getAgents() async {
    final response = await _httpClient.get(Uri.parse('$baseUrl/agents'));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['data'] as List<dynamic>;
      }
    }
    throw Exception('Failed to get agents: ${response.body}');
  }
  
  /// 获取单个 Agent
  Future<Map<String, dynamic>> getAgent(String id) async {
    final response = await _httpClient.get(Uri.parse('$baseUrl/agents/$id'));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['data'] as Map<String, dynamic>;
      }
    }
    throw Exception('Failed to get agent: ${response.body}');
  }
  
  /// 搜索 Agents
  Future<List<dynamic>> searchAgents(String query) async {
    final response = await _httpClient.get(
      Uri.parse('$baseUrl/agents/search?q=${Uri.encodeComponent(query)}'),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['data'] as List<dynamic>;
      }
    }
    throw Exception('Failed to search agents: ${response.body}');
  }
  
  /// 获取所有 Skills
  Future<List<dynamic>> getSkills() async {
    final response = await _httpClient.get(Uri.parse('$baseUrl/skills'));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['data'] as List<dynamic>;
      }
    }
    throw Exception('Failed to get skills: ${response.body}');
  }
  
  /// 获取单个 Skill
  Future<Map<String, dynamic>> getSkill(String id) async {
    final response = await _httpClient.get(Uri.parse('$baseUrl/skills/$id'));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['data'] as Map<String, dynamic>;
      }
    }
    throw Exception('Failed to get skill: ${response.body}');
  }
  
  /// 非流式聊天
  Future<Map<String, dynamic>> sendMessage({
    required String agentId,
    required String content,
    double? temperature,
  }) async {
    final response = await _httpClient.post(
      Uri.parse('$baseUrl/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'agentId': agentId,
        'content': content,
        if (temperature != null) 'temperature': temperature,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['data'] as Map<String, dynamic>;
      }
    }
    throw Exception('Failed to send message: ${response.body}');
  }
  
  /// 获取聊天历史
  Future<List<dynamic>> getChatHistory(String agentId, {int? limit}) async {
    var url = '$baseUrl/chat/history/$agentId';
    if (limit != null) {
      url += '?limit=$limit';
    }
    
    final response = await _httpClient.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['data'] as List<dynamic>;
      }
    }
    throw Exception('Failed to get chat history: ${response.body}');
  }
  
  /// 清除聊天历史
  Future<void> clearChatHistory(String agentId) async {
    final response = await _httpClient.delete(
      Uri.parse('$baseUrl/chat/history/$agentId'),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to clear chat history: ${response.body}');
    }
  }
  
  /// 连接 WebSocket
  void connectWebSocket({
    required Function(Map<String, dynamic>) onMessage,
    required Function() onConnected,
    required Function() onDisconnected,
    required Function(String) onError,
  }) {
    try {
      _wsChannel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      _wsChannel!.stream.listen(
        (message) {
          final data = jsonDecode(message as String);
          onMessage(data);
        },
        onDone: () {
          onDisconnected();
        },
        onError: (error) {
          onError(error.toString());
        },
      );
      
      onConnected();
    } catch (e) {
      onError(e.toString());
    }
  }
  
  /// 通过 WebSocket 发送消息
  void sendWebSocketMessage(String agentId, String content, {double? temperature}) {
    if (_wsChannel == null) return;
    
    _wsChannel!.sink.add(jsonEncode({
      'type': 'chat',
      'payload': {
        'agentId': agentId,
        'content': content,
        if (temperature != null) 'temperature': temperature,
      },
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }));
  }
  
  /// 选择 Agent (WebSocket)
  void selectAgent(String agentId) {
    if (_wsChannel == null) return;
    
    _wsChannel!.sink.add(jsonEncode({
      'type': 'connect',
      'payload': {'agentId': agentId},
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }));
  }
  
  /// 发送心跳 (WebSocket)
  void sendPing() {
    if (_wsChannel == null) return;
    
    _wsChannel!.sink.add(jsonEncode({
      'type': 'ping',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }));
  }
  
  /// 断开 WebSocket
  void disconnectWebSocket() {
    _wsChannel?.sink.close();
    _wsChannel = null;
  }
  
  /// 关闭客户端
  void dispose() {
    disconnectWebSocket();
    _httpClient.close();
  }
}

/// 使用示例：
/// 
/// ```dart
/// final apiClient = EasyClawApiClient();
/// 
/// // 获取 Agents
/// final agents = await apiClient.getAgents();
/// 
/// // 发送消息
/// final response = await apiClient.sendMessage(
///   agentId: 'd1',
///   content: '你好',
/// );
/// 
/// // WebSocket 连接
/// apiClient.connectWebSocket(
///   onMessage: (data) {
///     if (data['type'] == 'chat') {
///       if (data['payload']['type'] == 'chunk') {
///         print('收到: ${data['payload']['content']}');
///       }
///     }
///   },
///   onConnected: () => print('已连接'),
///   onDisconnected: () => print('已断开'),
///   onError: (error) => print('错误: $error'),
/// );
/// 
/// // 发送消息
/// apiClient.sendWebSocketMessage('d1', '你好');
/// ```
