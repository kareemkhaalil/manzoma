import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String amount;
  final double changePercent;
  final Color color;
  final Widget icon;
  final List<Color> colors;

  const StatCard({
    required this.title,
    required this.amount,
    required this.changePercent,
    required this.color,
    required this.icon,
    required this.colors,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: icon,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '(${changePercent > 0 ? '+' : ''}$changePercent%)',
                    style: TextStyle(fontSize: 16, color: color),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
