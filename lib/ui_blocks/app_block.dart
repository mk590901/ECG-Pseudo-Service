// --- App BLoC (for Start/Stop и Mode1/Mode2) ---
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppEvent {}

class ToggleRunningEvent extends AppEvent {}

class ToggleModeEvent extends AppEvent {}

class AppState {
  final bool isRunning;
  final bool isMode1;

  AppState({
    required this.isRunning,
    required this.isMode1,
  });

  AppState copyWith({
    bool? isRunning,
    bool? isMode1,
  }) {
    return AppState(
      isRunning: isRunning ?? this.isRunning,
      isMode1: isMode1 ?? this.isMode1,
    );
  }
}

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState(isRunning: false, isMode1: true)) {
    on<ToggleRunningEvent>((event, emit) {
      emit(state.copyWith(isRunning: !state.isRunning));
    });

    on<ToggleModeEvent>((event, emit) {
      emit(state.copyWith(isMode1: !state.isMode1));
    });
  }
}
