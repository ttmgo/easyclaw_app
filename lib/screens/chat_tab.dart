import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/agent_model.dart';
import '../models/message_model.dart';
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
      builder: (context, provider, child) {
        final messages = provider.currentAgentMessages;
        final recentItems = [
          ...provider.discoverAgents,
          ...provider.skillTools.take(1),
        ];

        return Column(
          children: [
            _buildHeader(context, provider, recentItems),
            _buildMessageList(provider, messages),
            _buildInputArea(context, provider),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppProvider provider, List<dynamic> recentItems) {
    return Container(
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
            color: Colors.black.withOpacity(0.03),
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
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recentItems.length,
              itemBuilder: (context, index) {
                final item = recentItems[index];
                final isActive = provider.currentChatAgent?.id == (item is AgentModel ? item.id : '');
                
                return GestureDetector(
                  onTap: () {
                    if (item is AgentModel) {
                      provider.setCurrentChatAgent(item);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: _buildAvatar(item, isActive),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(dynamic item, bool isActive) {
    return AnimatedContainer(
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
                  color: const Color(0xFFEF4444).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: item is AgentModel
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
                child: const Icon(Icons.layers, size: 20, color: Colors.grey),
              ),
      ),
    );
  }

  Widget _buildConnectionStatus(AppProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: provider.isConnected
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: provider.isConnected
              ? Colors.green.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
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

  Widget _buildMessageList(AppProvider provider, List<MessageModel> messages) {
    return Expanded(
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
                return _buildMessage(messages[index]);
              },
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
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _buildMessageBubble(msg, isUser),
          if (msg.attachment != null && msg.attachment!.type == 'image')
            _buildImageAttachment(msg.attachment!.url),
          if (msg.tableData != null)
            _buildTableAttachment(msg.tableData!),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel msg, bool isUser) {
    return Container(
   
