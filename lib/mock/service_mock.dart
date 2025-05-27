import 'package:synchronized/synchronized.dart';

import 'simulator_wrapper.dart';

class ServiceMock {
  static ServiceMock? _instance;

  final Map<String,SimulatorWrapper> container = {};
  final Lock _lock = Lock();

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

    // if (container.containsKey(id)) {
    //   container.remove(id);
    // }
  }

  int size() {
    return container.length;
  }

}
