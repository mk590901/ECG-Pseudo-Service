// --- App BLoC (for Start/Stop и Mode1/Mode2) ---
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppEvent {}

class ToggleRunningEvent extends AppEvent {}

class ToggleModeEvent extends AppEvent {}

class AppState {
  final bool isRunning;
  final bool isServer;

  AppState({
    required this.isRunning,
    required this.isServer,
  });

  AppState copyWith({
    bool? isRunning,
    bool? isServer,
  }) {
    return AppState(
      isRunning: isRunning ?? this.isRunning,
      isServer: isServer ?? this.isServer,
    );
  }
}

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState(isRunning: false, isServer: true)) {
    on<ToggleRunningEvent>((event, emit) {
      emit(state.copyWith(isRunning: !state.isRunning));
    });

    on<ToggleModeEvent>((event, emit) {
      emit(state.copyWith(isServer: !state.isServer));
    });
  }
}
