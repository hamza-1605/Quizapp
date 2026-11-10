import 'package:flutter/material.dart';

// A list entry that starts a special kind of round (Random, Custom).
class RoundModeTile extends StatelessWidget {
  const RoundModeTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: scheme.secondaryContainer,
        foregroundColor: scheme.onSecondaryContainer,
        child: Icon(icon),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}