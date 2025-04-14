import 'package:flutter/material.dart';

class MoneyBadge extends StatelessWidget {
  final double amount;

  const MoneyBadge({
    Key? key,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
          ),
          const SizedBox(height: 4.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      color: Colors.blue.shade800,
                    ),
              ),
              const SizedBox(width: 2.0),
              Text(
                amount.toStringAsFixed(0),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.blue.shade900,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
