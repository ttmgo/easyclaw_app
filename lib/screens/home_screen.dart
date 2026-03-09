import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'chat_tab.dart';
import 'discover_tab.dart';
import 'skills_tab.dart';
import 'profile_tab.dart';
import 'agent_detail_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // 主内容
              IndexedStack(
                index: _getTabIndex(provider.activeTab),
                children: const [
                  ChatTab(),
                  DiscoverTab(),
                  SkillsTab(),
                  ProfileTab(),
                ],
              ),
              // Agent详情页
              if (provider.selectedAgent != null)
                AgentDetailPage(agent: provider.selectedAgent!),
              // Skill详情页（已移除）
              // if (provider.selectedSkill != null)
              //   SkillDetailPage(skill: provider.selectedSkill!),
              if (provider.selectedSkill != null)
                SkillDetailPage(skill: provider.selectedSkill!),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(provider),
        );
      },
    );
  }

  int _getTabIndex(String tab) {
    switch (tab) {
      case 'chat':
        return 0;
      case 'discover':
        return 1;
      case 'agents':
        return 2;
      case 'profile':
        return 3;
      default:
        return 0;
    }
  }

  Widget _buildBottomNav(AppProvider provider) {
    return Container(
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.chat_bubble_outline,
                label: 'Chat',
                isActive: provider.activeTab == 'chat',
                onTap: () => provider.setActiveTab('chat'),
              ),
              _buildNavItem(
                icon: Icons.explore_outlined,
                label: 'Explore',
                isActive: provider.activeTab == 'discover',
                onTap: () => provider.setActiveTab('discover'),
              ),
              _buildNavItem(
                icon: Icons.layers_outlined,
                label: 'Skills',
                isActive: provider.activeTab == 'agents',
                onTap: () => provider.setActiveTab('agents'),
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                label: 'Admin',
                isActive: provider.activeTab == 'profile',
                onTap: () => provider.setActiveTab('profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEF4444).withOpacity( 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? const Color(0xFFEF4444) : Colors.grey[300],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: isActive ? const Color(0xFFEF4444) : Colors.grey[300],
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
