import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/skill_model.dart';
import '../providers/app_provider.dart';

class SkillDetailPage extends StatelessWidget {
  final SkillModel skill;

  const SkillDetailPage({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => context.read<AppProvider>().setSelectedSkill(null),
        child: Container(
          color: Colors.black.withValues(alpha: 0.3),
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
                        // 头部
                        SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 16,
                              left: 24,
                              right: 24,
                              bottom: 24,
                            ),
                            child: Row(
                              children: [
                                // 返回按钮
                                GestureDetector(
                                  onTap: () => context.read<AppProvider>().setSelectedSkill(null),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9FAFB),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey[200]!),
                                    ),
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.grey[700],
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  skill.category.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey[300],
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const Spacer(),
                                // 收藏按钮
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: Icon(
                                    Icons.bookmark_border,
                                    color: Colors.grey[400],
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 内容
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 标题和图标
                                Row(
                                  children: [
                                    Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.grey[100]!),
                                      ),
                                      child: Icon(
                                        skill.icon,
                                        size: 32,
                                        color: skill.id == 's1' ? Colors.orange : Colors.purple,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  skill.title,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFEF4444),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  skill.version,
                                                  style: const TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            skill.details,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[500],
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                // 核心指标
                                Row(
                                  children: [
                                    _buildMetricCard(
                                      label: 'Latency',
                                      value: skill.latency,
                                      icon: Icons.schedule,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildMetricCard(
                                      label: 'Reliability',
                                      value: skill.performance,
                                      icon: Icons.verified_user,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildMetricCard(
                                      label: 'Users',
                                      value: skill.users,
                                      icon: Icons.people,
                                      color: Colors.orange,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                // 技术栈
                                _buildSection(title: '技術堆棧 Tech Stack', icon: Icons.memory),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.terminal,
                                                  size: 16,
                                                  color: Color(0xFFEF4444),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'DEPLOYMENT',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      fontWeight: FontWeight.w900,
                                                      color: Colors.white.withValues(alpha: 0.3),
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                  Text(
                                                    skill.stack,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'UPTIME',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white.withValues(alpha: 0.3),
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                              const Text(
                                                '99.99%',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      const Divider(color: Colors.white12),
                                      const SizedBox(height: 16),
                                      Text(
                                        'CMD_INVOKE',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white.withValues(alpha: 0.3),
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.4),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          skill.usage,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'monospace',
                                            color: const Color(0xFFEF4444).withValues(alpha: 0.8),
                                          ),
                                    ],
                                  ),
                                        ),
                                      ),
                                ),
                                const SizedBox(height: 32),
                                // 核心特性
                                _buildSection(title: '核心特性 Features', icon: Icons.bolt),
                                const SizedBox(height: 12),
                                ...skill.features.map((feature) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey[100]!),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEF4444),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        feature,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, size: 18, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              '立即調用工具',
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
                  ],
                ),
              );
            },
          ),
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

  Widget _buildMetricCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 12, color: color),
                const SizedBox(width: 4),
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey[400],
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
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
}
