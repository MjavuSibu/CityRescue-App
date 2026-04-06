import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'custom_icon.dart';

class BottomNav extends StatelessWidget {
  final String active;
  final Function(String) onNav;

  const BottomNav({
    super.key,
    required this.active,
    required this.onNav,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {'id': 'home', 'icon': 'map', 'label': 'Explore'},
      {'id': 'camera', 'icon': 'camera', 'label': 'Report'},
      {'id': 'tracking', 'icon': 'clock', 'label': 'Track'},
      {'id': 'notifications', 'icon': 'bell', 'label': 'Alerts'},
      {'id': 'profile', 'icon': 'user', 'label': 'Profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: tabs.map((tab) {
          final isActive = active == tab['id'];
          return Expanded(
            child: GestureDetector(
              onTap: () => onNav(tab['id']!),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isActive)
                    Container(
                      width: 32,
                      height: 3,
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                    ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.lime : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: CustomIcon(
                        id: tab['icon']!,
                        size: 19,
                        color: isActive ? AppColors.limeT : AppColors.ink3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tab['label']!,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: isActive ? AppColors.ink : AppColors.ink3,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}