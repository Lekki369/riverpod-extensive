import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

const names = [
  'Ade',
  'Bola',
  'Fummi',
  'Mercy',
  'Goodness',
  'Favour',
  'Lekan',
  'Tobi',
  'Kike',
  'Victor',
  'Oba',
];

final countStreamProvider = StreamProvider(
  (ref) => Stream.periodic(
    const Duration(seconds: 1),
    (value) => value + 1,
  ),
);

final nameProvider = StreamProvider(
  (ref) => ref.watch(countStreamProvider.future).asStream().map(
        (count) => names.getRange(0, count),
      ),
);

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(nameProvider);

    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: names.when(
          data: (data) => ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => ListTile(
              leading: Text(
                data.elementAt(index),
              ),
            ),
          ),
          error: (error, stackTrace) {
            return const Text('End of List');
          },
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
        )),
      ),
    );
  }
}
