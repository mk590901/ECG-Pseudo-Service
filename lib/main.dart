import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Data model for list item
class Item {
  final String id;
  final String title;

  Item({required this.id, required this.title});
}

// Event BLoC
abstract class AppEvent {}

class ToggleRunningEvent extends AppEvent {}

class ToggleModeEvent extends AppEvent {}

class AddItemEvent extends AppEvent {}

class RemoveItemEvent extends AppEvent {
  final String id;

  RemoveItemEvent(this.id);
}

// State BLoC
class AppState {
  final bool isRunning;
  final bool isMode1;
  final List<Item> items;

  AppState({
    required this.isRunning,
    required this.isMode1,
    required this.items,
  });

  AppState copyWith({
    bool? isRunning,
    bool? isMode1,
    List<Item>? items,
  }) {
    return AppState(
      isRunning: isRunning ?? this.isRunning,
      isMode1: isMode1 ?? this.isMode1,
      items: items ?? this.items,
    );
  }
}

// BLoC
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState(isRunning: false, isMode1: true, items: [])) {
    on<ToggleRunningEvent>((event, emit) {
      emit(state.copyWith(isRunning: !state.isRunning));
    });

    on<ToggleModeEvent>((event, emit) {
      emit(state.copyWith(isMode1: !state.isMode1));
    });

    on<AddItemEvent>((event, emit) {
      final newItem = Item(
        id: DateTime.now().toString(),
        title: 'Item ${state.items.length + 1}',
      );
      emit(state.copyWith(items: [...state.items, newItem]));
    });

    on<RemoveItemEvent>((event, emit) {
      emit(state.copyWith(
        items: state.items.where((item) => item.id != event.id).toList(),
      ));
    });
  }
}

// Main App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

// Main page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create ScrollController
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter BLoC App'),
      ),
      body: Column(
        children: [
          const ControlPanel(),
          Expanded(
            child: BlocConsumer<AppBloc, AppState>(
              listener: (context, state) {
                // When adding a new element, scroll to the end
                if (state.items.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                }
              },
              builder: (context, state) {
                return ListView.builder(
                  controller: scrollController,
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return Dismissible(
                      key: Key(item.id),
                      onDismissed: (direction) {
                        context.read<AppBloc>().add(RemoveItemEvent(item.id));
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: CustomCardView(item: item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AppBloc>().add(AddItemEvent());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Control panel (Start/Stop и Switch)
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
                  Text(state.isMode1 ? 'Mode1' : 'Mode2'),
                  const SizedBox(width: 8),
                  Switch(
                    value: state.isMode1,
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

// Custom card view
class CustomCardView extends StatelessWidget {
  final Item item;

  const CustomCardView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(item.title),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
