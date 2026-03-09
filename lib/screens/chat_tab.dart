import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/agent_model.dart';
import '../providers/app_provider.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(

        final recentItems = [
          ...provider.discoverAgents,
          ...provider.skillTools.take(1),
        ];

        return Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                right: 20,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity( 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'MESSAGE.',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[900],
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      _buildConnectionStatus(provider),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Agent切换器
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recentItems.length,
                      itemBuilder: (context, index) {
                        final item = recentItems[index];
                        final isActive = provider.currentChatAgent?.id == item.id;
                        
                        return GestureDetector(
                          onTap: () {
                            if (item is AgentModel) {
                              provider.setCurrentChatAgent(item);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: isActive
                                        ? Border.all(color: const Color(0xFFEF4444), width: 2)
                                        : null,
                                    boxShadow: isActive
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFFEF4444).withOpacity( 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: item.id.startsWith('d')
                                        ? CachedNetworkImage(
                                            imageUrl: item.bgImage,
                                            fit: BoxFit.cover,
                                            placeholder: (_, __) => Container(color: Colors.grey[200]),
                                            errorWidget: (_, __, ___) => Container(
                                              color: Colors.grey[200],
                                              child: Icon(item.icon, size: 20, color: Colors.grey),
                                            ),
                                          )
                                        : Container(
                                            color: Colors.grey[100],
                                            child: Icon(item.icon, size: 20, color: Colors.grey),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // 消息列表
            Expanded(
              child: provider.currentChatAgent == null
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount: messages.length + (provider.isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length && provider.isTyping) {
                          return _buildTypingIndicator();
                        }
                        final msg = messages[index];
                        return _buildMessage(msg);
                      },
                    ),
            ),
            // 输入框
            Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity( 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey[100]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: (v) => provider.setInputText(v),
                        onSubmitted: (_) => _sendMessage(provider),
                        decoration: const InputDecoration(
                          hintText: '輸入指令...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _sendMessage(provider),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: provider.inputText.trim().isNotEmpty
                              ? const Color(0xFFEF4444)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: provider.inputText.trim().isNotEmpty
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFEF4444).withOpacity( 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          Icons.arrow_upward,
                          color: provider.inputText.trim().isNotEmpty
                              ? Colors.white
                              : Colors.grey[400],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConnectionStatus(AppProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: provider.isConnected
            ? Colors.green.withOpacity( 0.1)
            : Colors.grey.withOpacity( 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: provider.isConnected
              ? Colors.green.withOpacity( 0.3)
              : Colors.grey.withOpacity( 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: provider.isConnected ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            provider.connectionStatus,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: provider.isConnected ? Colors.green[700] : Colors.grey,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'Standby_Mode',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[300],
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Processing...',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[400],
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(MessageModel msg) {
    final isUser = msg.role == 'user';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isUser ? Colors.grey[900] : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity( 0.03),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              msg.content,
              style: TextStyle(
                fontSize: 13,
                color: isUser ? Colors.white : Colors.grey[800],
                fontWeight: isUser ? FontWeight.w600 : FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
          // 附件 - 图片
          if (msg.attachment != null && msg.attachment!.type == 'image')
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey[100]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CachedNetworkImage(
                    imageUrl: msg.attachment!.url,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 160,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 160,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 160,
                      color: Colors.grey[200],
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          // 附件 - 数据表格
          if (msg.tableData != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity( 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: msg.tableData!.map((row) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            row.item,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity( 0.5),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            row.value,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _sendMessage(AppProvider provider) {
    if (provider.inputText.trim().isEmpty) return;
    provider.sendMessage(_controller.text);
    _controller.clear();
  }
}
