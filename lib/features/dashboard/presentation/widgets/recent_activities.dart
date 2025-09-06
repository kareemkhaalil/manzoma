import 'package:flutter/material.dart';
import 'package:manzoma/core/enums/user_role.dart';

class RecentActivities extends StatelessWidget {
  final UserRole userRole;

  const RecentActivities({
    super.key,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final activities = _getActivitiesForRole();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...activities.map((activity) => _buildActivityItem(activity)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ActivityData activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity.icon,
              color: activity.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity.time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  List<ActivityData> _getActivitiesForRole() {
    switch (userRole) {
      case UserRole.superAdmin:
        return [
          ActivityData(
            title: 'New client registered',
            description: 'ABC Company joined the platform',
            time: '2 hours ago',
            icon: Icons.business,
            color: Colors.blue,
          ),
          ActivityData(
            title: 'System backup completed',
            description: 'Daily backup finished successfully',
            time: '4 hours ago',
            icon: Icons.backup,
            color: Colors.green,
          ),
          ActivityData(
            title: 'Payment received',
            description: 'XYZ Corp paid monthly subscription',
            time: '6 hours ago',
            icon: Icons.payment,
            color: Colors.orange,
          ),
        ];

      case UserRole.cad:
        return [
          ActivityData(
            title: 'Employee checked in',
            description: 'John Doe checked in at 9:00 AM',
            time: '30 min ago',
            icon: Icons.login,
            color: Colors.green,
          ),
          ActivityData(
            title: 'Payroll processed',
            description: 'Monthly payroll for 156 employees',
            time: '2 hours ago',
            icon: Icons.payment,
            color: Colors.blue,
          ),
          ActivityData(
            title: 'New employee added',
            description: 'Sarah Smith joined the team',
            time: '1 day ago',
            icon: Icons.person_add,
            color: Colors.purple,
          ),
        ];

      case UserRole.employee:
        return [
          ActivityData(
            title: 'Checked in',
            description: 'You checked in at 9:15 AM',
            time: '2 hours ago',
            icon: Icons.login,
            color: Colors.green,
          ),
          ActivityData(
            title: 'Payslip available',
            description: 'Your October payslip is ready',
            time: '1 day ago',
            icon: Icons.receipt,
            color: Colors.blue,
          ),
          ActivityData(
            title: 'Profile updated',
            description: 'Contact information updated',
            time: '3 days ago',
            icon: Icons.edit,
            color: Colors.orange,
          ),
        ];
    }
  }
}

class ActivityData {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;

  ActivityData({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
  });
}
