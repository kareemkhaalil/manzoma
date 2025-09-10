import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/activity_entity.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(ActivityInitial());

  Future<void> getRecentActivities() async {
    emit(ActivityLoading());
    // هنا ستقوم بجلب البيانات من الـ UseCase الخاص بك

    // بيانات وهمية للتوضيح
    await Future.delayed(const Duration(milliseconds: 1500));
    emit(ActivityLoaded(activities: [
      ActivityEntity(
        id: '1',
        title: 'New client registered',
        description: 'ABC Company joined the platform',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        actionType: 'CREATE_CLIENT',
      ),
      ActivityEntity(
        id: '2',
        title: 'Employee checked in',
        description: 'John Doe checked in at Main Branch',
        time: DateTime.now().subtract(const Duration(minutes: 30)),
        actionType: 'CHECK_IN',
      ),
      ActivityEntity(
        id: '3',
        title: 'New employee added',
        description: 'Sarah Smith joined the team',
        time: DateTime.now().subtract(const Duration(days: 1)),
        actionType: 'CREATE_USER',
      ),
    ]));
  }
}

abstract class ActivityState extends Equatable {
  const ActivityState();
  @override
  List<Object> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  final List<ActivityEntity> activities;
  const ActivityLoaded({required this.activities});
  @override
  List<Object> get props => [activities];
}

class ActivityError extends ActivityState {
  final String message;
  const ActivityError({required this.message});
  @override
  List<Object> get props => [message];
}
