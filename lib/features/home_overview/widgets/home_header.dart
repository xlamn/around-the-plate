import 'package:app_theme/app_theme.dart';
import 'package:flutter/widgets.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good morning';
    if (hour >= 12 && hour < 17) return 'Good afternoon';
    if (hour >= 17 && hour < 21) return 'Good evening';
    return 'Good night';
  }

  String get _formattedDate {
    final now = DateTime.now();
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    return FHeader(
      title: Column(
        crossAxisAlignment: .start,
        spacing: AppSizes.spacing4,
        children: [
          Text(
            '$_greeting!',
            style: context.theme.typography.xl2.copyWith(
              fontWeight: .bold,
              height: 1.2,
            ),
          ),
          Text(
            _formattedDate,
            style: context.theme.typography.sm.copyWith(
              color: context.theme.colors.mutedForeground,
              fontWeight: .w400,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
