// --- Items BLoC (control elements list) ---
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../mock/service_mock.dart';
import 'item_model.dart';

abstract class ItemsEvent {}


class CreateItemEvent extends ItemsEvent {
  final Function(String) onObjectCreated;

  CreateItemEvent(this.onObjectCreated);
}

class AddItemEvent extends ItemsEvent {
  final String id;

  AddItemEvent(this.id);
}

//class AddItemEvent extends ItemsEvent {}

class RemoveItemEvent extends ItemsEvent {
  final String id;
  final DismissDirection direction;

  RemoveItemEvent(this.id, this.direction);
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

    // on<AddItemEvent>((event, emit) {
    //   String id = ServiceMock.instance()?.add()?? const Uuid().v4().toString();
    //   final Item newItem = Item(
    //     id: id, title: "ECG Diagram [${id.substring(0, 8)}]",
    //   );
    //   emit(state.copyWith(items: [...state.items, newItem]));
    //   print('Add [$id] simulator -> # ${ServiceMock.instance()?.size()}');
    // });


    on<AddItemEvent>((event, emit) {
      final newItem = Item(id: event.id,
        title: "ECG Diagram [${event.id.substring(0, 8)}]",
      );
      emit(state.copyWith(items: [...state.items, newItem]));
    });

    on<CreateItemEvent>((event, emit) async {
      String objectId = ServiceMock.instance()?.add()?? const Uuid().v4().toString();
      event.onObjectCreated(objectId);
    });

    on<RemoveItemEvent>((event, emit) {

      emit(state.copyWith(
        items: state.items.where((item) => item.id != event.id).toList(),
      ));

      if (event.direction == DismissDirection.endToStart) {
        ServiceMock.instance()?.remove(event.id);
        print('Remove [${event.id}] simulator -> # ${ServiceMock.instance()?.size()}');
      }

    });
  }
}
