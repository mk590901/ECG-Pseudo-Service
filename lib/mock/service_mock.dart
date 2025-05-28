import 'dart:async';

import 'package:synchronized/synchronized.dart';

import '../ui_blocks/app_bloc.dart';
import 'simulator_wrapper.dart';

class ServiceMock {
  static ServiceMock? _instance;

  final Map<String,SimulatorWrapper> container = {};
  final Lock _lock = Lock();

  late AppBloc? _bloc;

  static int PERIOD = 1000;
  final Duration _period = Duration(milliseconds: PERIOD);
  late Timer? _timer;

  static void initInstance() {
    _instance ??= ServiceMock();
    print ('ServiceMock.initInstance -- Ok');
  }

  static ServiceMock? instance() {
    if (_instance == null) {
      throw Exception("--- ServiceMock was not initialized ---");
    }
    return _instance;
  }

  String? add() {

      SimulatorWrapper wrapper = SimulatorWrapper();
      _lock.synchronized(() {
        container[wrapper.id()] = wrapper;
      });

      if (size() == 1) {
        start(_bloc);
      }

      return wrapper.id();

    // SimulatorWrapper wrapper = SimulatorWrapper();
    // container[wrapper.id()] = wrapper;
    // return wrapper.id();
  }

  void remove(String? id) {

    _lock.synchronized(() {
      if (container.containsKey(id)) {
        container.remove(id);
      }
    });

    if (size() == 0) {
      stop();
    }

    // if (container.containsKey(id)) {
    //   container.remove(id);
    // }
  }

  SimulatorWrapper? get(String? id) {
    SimulatorWrapper? result;
    _lock.synchronized(() {
      if (container.containsKey(id)) {
        result = container[id];
      }
    });
    return result;
  }

  int size() {
    return container.length;
  }

  void start(AppBloc? bloc) {

    _bloc = bloc;

    if (container.isEmpty) {
      return;
    }
    print ('------- ServiceMock.start -------');
    _timer = Timer.periodic(_period, (Timer t) {
      callbackFunction();
    });
  }

  void callbackFunction() {
    print ('------- ServiceMock.callbackFunction -------');
    container.forEach((key, value) {
      _bloc?.add(UpdateDataEvent(key, []));
    });
  }

  void stop() {

    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
    _timer = null;
    print ('------- callbackFunction.stop -------');

  }

}
