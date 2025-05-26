// --- Items BLoC (control elements list) ---
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'item_model.dart';

abstract class ItemsEvent {}

class AddItemEvent extends ItemsEvent {}

class RemoveItemEvent extends ItemsEvent {
  final String id;

  RemoveItemEvent(this.id);
}

class ItemsState {
  final List<Item> items;

  ItemsState({required this.items});

  ItemsState copyWith({List<Item>? items}) {
    return ItemsState(items: items ?? this.items);
  }
}

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  ItemsBloc() : super(ItemsState(items: [])) {
    on<AddItemEvent>((event, emit) {
      String id = const Uuid().v4().toString();
      final Item newItem = Item(
        id: id, title: "ECG Diagram [${id.substring(0, 8)}]",
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
