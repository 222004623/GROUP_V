/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane
 */
import 'package:flutter/material.dart';
import '../app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    IconData icon;

    // Color-code based on application status
    switch (status.toLowerCase()) {
      case 'approved':
        bg = const Color(0xFFE8F5E9);
        text = AppTheme.success;
        icon = Icons.check_circle_outline;
        break;
      case 'rejected':
        bg = const Color(0xFFFFEBEE);
        text = AppTheme.error;
        icon = Icons.cancel_outlined;
        break;
      default: // pending
        bg = AppTheme.primaryLight;
        text = AppTheme.primaryDark;
        icon = Icons.hourglass_empty_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: text),
          const SizedBox(width: 6),
          Text(
            status[0].toUpperCase() + status.substring(1),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
        ],
      ),
    );
  }
}
