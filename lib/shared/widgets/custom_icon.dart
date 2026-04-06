import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final String id;
  final double size;
  final Color color;

  const CustomIcon({
    super.key,
    required this.id,
    this.size = 24,
    this.color = const Color(0xFF0C0C0C),
  });

  @override
  Widget build(BuildContext context) {
    final iconMap = {
      'map': Icons.map_outlined,
      'camera': Icons.camera_alt_outlined,
      'clock': Icons.access_time_outlined,
      'bell': Icons.notifications_outlined,
      'user': Icons.person_outline,
      'plus': Icons.add,
      'x': Icons.close,
      'back': Icons.arrow_back_ios_new,
      'check': Icons.check,
      'chevron': Icons.chevron_right,
      'mail': Icons.mail_outline,
      'lock': Icons.lock_outline,
      'eye': Icons.visibility_outlined,
      'eyeOff': Icons.visibility_off_outlined,
      'alert': Icons.warning_amber_outlined,
      'zap': Icons.flash_on_outlined,
      'drop': Icons.water_drop_outlined,
      'people': Icons.people_outline,
      'gear': Icons.settings_outlined,
      'shield': Icons.shield_outlined,
      'send': Icons.send_outlined,
      'link': Icons.link_outlined,
      'star': Icons.star_outline,
      'photo': Icons.photo_camera_outlined,
    };

    return Icon(
      iconMap[id] ?? Icons.help_outline,
      size: size,
      color: color,
    );
  }
}