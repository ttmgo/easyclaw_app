import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/agent_model.dart';
import '../providers/app_provider.dart';

class AgentDetailPage extends StatelessWidget {
  final AgentModel agent;

  const AgentDetailPage({super.key, required this.agent});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => context.read<AppProvider>().setSelectedAgent(null),
        child: Container(
          color: Colors.black.withOpacity( 0.3),
          child: DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 0.5,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Stack(
                  children: [
                    CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        // 头部图片
                        SliverToBoxAdapter(
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 280,
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  imageUrl: agent.bgImage,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(color: Colors.grey[200]),
                                  errorWidget: (_, __, ___) => Container(
                                    color: Colors.grey[200],
                                    child: Icon(agent.icon, size: 60, color: Colors.grey),
                                  ),
                                ),
                              ),
                              Container(
                                height: 280,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity( 0.3),
                                      Colors.transparent,
                                      Colors.white,
                                    ],
                                  ),
                                ),
                              ),
                              // 返回按钮
                              Positioned(
                                top: MediaQuery.of(context).padding.top + 8,
                                left: 16,
                                child: GestureDetector(
                                  onTap: () => context.read<AppProvider>().setSelectedAgent(null),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity( 0.4),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity( 0.2),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              // 底部标题
                              Positioned(
                                bottom: 24,
                                left: 24,
                                right: 24,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEF4444),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        agent.tag,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      agent.title,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 内容
                        SliverToBoxAdapter(
                          child: Container(
                            transform: Matrix4.translationValues(0, -30, 0),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 指标
                                _buildMetrics(),
                                const SizedBox(height: 24),
                                // 专家定义
                                _buildSection(
                                  title: '專家定義',
                                  icon: Icons.track_changes,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  agent.role,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                    height: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // 协作流程
                                _buildSection(
                                  title: '協作流程 Pipeline',
                                  icon: Icons.account_tree,
                                ),
                                const SizedBox(height: 16),
                                ...agent.pipeline.asMap().entries.map((entry) {
                                  return _buildPipelineStep(
                                    index: entry.key + 1,
                                    step: entry.value['step']!,
                                    desc: entry.value['desc']!,
                                  );
                                }),
                                const SizedBox(height: 24),
                                // 最近成就
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: Colors.grey[100]!),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.emoji_events,
                                            size: 14,
                                            color: Colors.amber[600],
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '最近成就',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey[400],
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '"${agent.recentAchievement}"',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 120),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 底部按钮
                    Positioned(
                      bottom: 32,
                      left: 24,
                      right: 24,
                      child: GestureDetector(
                        onTap: () {
                          context.read<AppProvider>().startChatWithAgent(agent);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEF4444).withOpacity( 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bolt, size: 18, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                '啟動協作環境',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics() {
    return Row(
      children: [
        _buildMetricItem('Logic', agent.metrics['logic']!),
        _buildMetricItem('Creative', agent.metrics['creative']!),
        _buildMetricItem('Speed', agent.metrics['speed']!),
      ],
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.grey[300],
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFFEF4444)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPipelineStep({
    required int index,
    required String step,
    required String desc,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
