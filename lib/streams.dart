import 'dart:async';

void main() {
  // final Stream<int> stream = numberCreator();
  final Stream<int> stream = NumberCreator().stream;
  stream.listen((event) {
    print(event);
  });
}

Stream<int> numberCreator() async* {
  int value = 1;
  while (true) {
    yield value++;
    await Future.delayed(const Duration(seconds: 1));
  }
}

class NumberCreator {
  final StreamController<int> streamController = StreamController();
  int value = 1;

  NumberCreator() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      streamController.add(value++);
    });
  }

  Stream<int> get stream => streamController.stream;
}
