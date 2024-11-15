import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

final myNotifierProvider = NotifierProvider<MyNotifier, int>(MyNotifier.new);