import 'package:flutter/material.dart';

enum BadgeSize { small, medium, large }

class DateBadge extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final BadgeSize size;

  const DateBadge({
    super.key,
    required this.startDate,
    required this.endDate,
    this.size = BadgeSize.large, // Default to large
  });

  @override
  Widget build(BuildContext context) {
    final double padding = _getPadding();
    final double dividerHeight = _getDividerHeight();

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDateColumn('START', startDate),
          Container(
            width: 1,
            height: dividerHeight,
            color: Colors.grey.shade300,
          ),
          _buildDateColumn('END', endDate),
        ],
      ),
    );
  }

  Widget _buildDateColumn(String label, DateTime date) {
    final TextStyle labelStyle = _getLabelStyle();
    final TextStyle dateStyle = _getDateStyle();
    final TextStyle yearStyle = _getYearStyle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: labelStyle,
        ),
        const SizedBox(height: 4),
        Text(
          '${_formatMonth(date)} ${date.day}',
          style: dateStyle,
        ),
        Text(
          '${date.year}',
          style: yearStyle,
        ),
      ],
    );
  }

  double _getPadding() {
    switch (size) {
      case BadgeSize.small:
        return 8.0;
      case BadgeSize.medium:
        return 10.0;
      case BadgeSize.large:
        return 16.0;
    }
  }

  double _getDividerHeight() {
    switch (size) {
      case BadgeSize.small:
        return 25.0;
      case BadgeSize.medium:
        return 30.0;
      case BadgeSize.large:
        return 40.0;
    }
  }

  TextStyle _getLabelStyle() {
    switch (size) {
      case BadgeSize.small:
        return const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey);
      case BadgeSize.medium:
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey);
      case BadgeSize.large:
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey);
    }
  }

  TextStyle _getDateStyle() {
    switch (size) {
      case BadgeSize.small:
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87);
      case BadgeSize.medium:
        return const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87);
      case BadgeSize.large:
        return const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87);
    }
  }

  TextStyle _getYearStyle() {
    switch (size) {
      case BadgeSize.small:
        return const TextStyle(fontSize: 12, color: Colors.black54);
      case BadgeSize.medium:
        return const TextStyle(fontSize: 14, color: Colors.black54);
      case BadgeSize.large:
        return const TextStyle(fontSize: 16, color: Colors.black54);
    }
  }

  String _formatMonth(DateTime date) {
    if (size == BadgeSize.small) {
      return {
        1: 'Jan',
        2: 'Feb',
        3: 'Mar',
        4: 'Apr',
        5: 'May',
        6: 'Jun',
        7: 'Jul',
        8: 'Aug',
        9: 'Sep',
        10: 'Oct',
        11: 'Nov',
        12: 'Dec',
      }[date.month]!;
    }
    return {
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December',
    }[date.month]!;
  }
}
