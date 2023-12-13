import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: MainApp()),
  );
}

final counterProvider = StateNotifierProvider<CounterNoitifier, int>(
  (ref) => CounterNoitifier(0),
);

/*
StateNotifier notifier you of state changes.
Most(If not all) providers are generics.
Rx dart????
 */
class CounterNoitifier extends StateNotifier<int> {
  CounterNoitifier(super.state);
  void increment() => state = state + 1;
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return MaterialApp(
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count.toString(),
              ),
              OutlinedButton(
                // onPressed: () => ref.read(counterProvider.notifier).increment(),
                onPressed: ref.read(counterProvider.notifier).increment,
                // another syntax to write function with a void return type
                child: const Text('Increment'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
