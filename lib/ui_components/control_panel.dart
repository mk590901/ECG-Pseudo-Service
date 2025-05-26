// Control panel (Start/Stop и Switch)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ui_blocks/app_block.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<AppBloc>().add(ToggleRunningEvent());
                },
                child: Text(state.isRunning ? 'Stop' : 'Start'),
              ),
              Row(
                children: [
                  Text(state.isServer ? 'Server' : 'Client'),
                  const SizedBox(width: 8),
                  Switch(
                    value: state.isServer,
                    onChanged: (value) {
                      context.read<AppBloc>().add(ToggleModeEvent());
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
