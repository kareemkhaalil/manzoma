import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime time; // <-- استخدام DateTime للترتيب الدقيق
  final String actionType; // e.g., 'CREATE_USER', 'CHECK_IN'

  const ActivityEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.actionType,
  });

  @override
  List<Object> get props => [id, title, description, time, actionType];
}
