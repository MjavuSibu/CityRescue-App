import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final String id;
  final double size;
  final Color color;

  const CustomIcon({
    super.key,
    required this.id,
    this.size = 24,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    // Material Icons placeholder (matches React prototype icons)
    final iconMap = {
      'pin': Icons.location_on,
      'map': Icons.map,
      'camera': Icons.camera_alt,
      'clock': Icons.access_time,
      'bell': Icons.notifications,
      'user': Icons.person,
      'plus': Icons.add,
      'x': Icons.close,
      'back': Icons.arrow_back_ios_new,
      'check': Icons.check,
      'chevron': Icons.chevron_right,
      'mail': Icons.mail_outline,
      'lock': Icons.lock_outline,
      'eye': Icons.visibility,
      'eyeOff': Icons.visibility_off,
      'alert': Icons.warning_amber,
      'zap': Icons.flash_on,
      'drop': Icons.water_drop,
      'people': Icons.people_outline,
      'gear': Icons.settings_outlined,
      'shield': Icons.security,
      'send': Icons.send,
      'link': Icons.link,
      'star': Icons.star_outline,
      'photo': Icons.photo_camera,
    };

    return Icon(
      iconMap[id] ?? Icons.help_outline,
      size: size,
      color: color,
    );
  }
}