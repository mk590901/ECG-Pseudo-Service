import 'simulator_wrapper.dart';

class ServiceMock {
  static ServiceMock? _instance;

  final Map<String,SimulatorWrapper> container = {};

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

  String add() {
    SimulatorWrapper wrapper = SimulatorWrapper();
    container[wrapper.id()] = wrapper;
    return wrapper.id();
  }

  void remove(String? id) {
    if (container.containsKey(id)) {
      container.remove(id);
    }
  }

  int size() {
    return container.length;
  }

}
