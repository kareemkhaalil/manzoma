import 'package:flutter/material.dart';
import 'loading_widget.dart';
import 'error_widget.dart';

// Enum for different app states
enum AppState {
  initial,
  loading,
  success,
  error,
  empty,
}

// State wrapper widget that handles different states uniformly
class AppStateWrapper extends StatelessWidget {
  final AppState state;
  final Widget? child;
  final String? errorMessage;
  final String? loadingMessage;
  final String? emptyTitle;
  final String? emptyMessage;
  final IconData? emptyIcon;
  final VoidCallback? onRetry;
  final VoidCallback? onEmptyAction;
  final String? emptyActionText;
  final bool showLoadingLogo;

  const AppStateWrapper({
    super.key,
    required this.state,
    this.child,
    this.errorMessage,
    this.loadingMessage,
    this.emptyTitle,
    this.emptyMessage,
    this.emptyIcon,
    this.onRetry,
    this.onEmptyAction,
    this.emptyActionText,
    this.showLoadingLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case AppState.loading:
        return LoadingWidget(
          message: loadingMessage,
          showLogo: showLoadingLogo,
        );
      
      case AppState.error:
        return AppErrorWidget(
          message: errorMessage ?? 'حدث خطأ غير متوقع',
          onRetry: onRetry,
        );
      
      case AppState.empty:
        return EmptyStateWidget(
          title: emptyTitle,
          message: emptyMessage ?? 'لا توجد بيانات للعرض',
          icon: emptyIcon,
          onAction: onEmptyAction,
          actionText: emptyActionText,
        );
      
      case AppState.success:
      case AppState.initial:
      default:
        return child ?? const SizedBox.shrink();
    }
  }
}

// Mixin for handling common state operations
mixin AppStateMixin<T extends StatefulWidget> on State<T> {
  AppState _currentState = AppState.initial;
  String? _errorMessage;
  String? _loadingMessage;

  AppState get currentState => _currentState;
  String? get errorMessage => _errorMessage;
  String? get loadingMessage => _loadingMessage;

  void setLoadingState({String? message}) {
    setState(() {
      _currentState = AppState.loading;
      _loadingMessage = message;
      _errorMessage = null;
    });
  }

  void setSuccessState() {
    setState(() {
      _currentState = AppState.success;
      _errorMessage = null;
      _loadingMessage = null;
    });
  }

  void setErrorState(String message) {
    setState(() {
      _currentState = AppState.error;
      _errorMessage = message;
      _loadingMessage = null;
    });
  }

  void setEmptyState() {
    setState(() {
      _currentState = AppState.empty;
      _errorMessage = null;
      _loadingMessage = null;
    });
  }

  void setInitialState() {
    setState(() {
      _currentState = AppState.initial;
      _errorMessage = null;
      _loadingMessage = null;
    });
  }

  void showSuccessMessage(String message) {
    SuccessSnackBar.show(context, message);
  }

  void showErrorMessage(String message) {
    ErrorSnackBar.show(context, message);
  }

  void showLoadingDialog({String? message}) {
    LoadingDialog.show(context, message: message);
  }

  void hideLoadingDialog() {
    LoadingDialog.hide(context);
  }

  void showErrorDialog({
    String? title,
    required String message,
    VoidCallback? onRetry,
  }) {
    ErrorDialog.show(
      context,
      title: title,
      message: message,
      onRetry: onRetry,
    );
  }
}

// Builder widget for conditional state rendering
class AppStateBuilder extends StatelessWidget {
  final AppState state;
  final Widget Function() successBuilder;
  final Widget Function()? loadingBuilder;
  final Widget Function(String message)? errorBuilder;
  final Widget Function()? emptyBuilder;
  final String? errorMessage;
  final String? loadingMessage;
  final VoidCallback? onRetry;

  const AppStateBuilder({
    super.key,
    required this.state,
    required this.successBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.errorMessage,
    this.loadingMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case AppState.loading:
        return loadingBuilder?.call() ?? 
               LoadingWidget(message: loadingMessage);
      
      case AppState.error:
        return errorBuilder?.call(errorMessage ?? 'حدث خطأ غير متوقع') ?? 
               AppErrorWidget(
                 message: errorMessage ?? 'حدث خطأ غير متوقع',
                 onRetry: onRetry,
               );
      
      case AppState.empty:
        return emptyBuilder?.call() ?? 
               const EmptyStateWidget(
                 message: 'لا توجد بيانات للعرض',
               );
      
      case AppState.success:
      case AppState.initial:
      default:
        return successBuilder();
    }
  }
}

// Extension for easy state management with BLoC
extension BlocStateExtension on Object {
  AppState toAppState() {
    final stateType = runtimeType.toString();
    
    if (stateType.contains('Loading')) {
      return AppState.loading;
    } else if (stateType.contains('Error')) {
      return AppState.error;
    } else if (stateType.contains('Empty')) {
      return AppState.empty;
    } else if (stateType.contains('Loaded') || 
               stateType.contains('Success') ||
               stateType.contains('Created') ||
               stateType.contains('Updated') ||
               stateType.contains('Deleted')) {
      return AppState.success;
    } else {
      return AppState.initial;
    }
  }
}

