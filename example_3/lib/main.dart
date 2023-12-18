import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//goal to use futureProvider and futures
//and to make a provider depend on other (dependency injection)

enum City {
  lagos,
  abuja,
  portHacourt,
  kano,
}

typedef WeatherEmoji = String;

void main() {
  runApp(
    const ProviderScope(child: MainApp()),
  );
}

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
      const Duration(seconds: 1),
      () => switch (city) {
            City.abuja => '☀️',
            City.kano => '🥵',
            City.lagos => '🌤️',
            City.portHacourt => '🌦️',
          });
  // another way to retun values of enum
  //  {
  //   City.lagos: '🌤️',
  //   City.abuja: '☀️',
  //   City.kano: '🥵',
  //   City.portHacourt: '🌦️',
  // }[city]!
  // unwraping values through the key [city] of this map
}

const unknownWeather = '🤷‍♂️';
final currentCityProvider = StateProvider<City?>((ref) => null);

final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getWeather(city);
  } else {
    return unknownWeather;
  }
});

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      home: const Homepage(),
    );
  }
}

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: Column(
        children: [
          currentWeather.when(
              data: (weather) => Text(
                    weather,
                    style: const TextStyle(fontSize: 50),
                  ),
              error: (_, __) => const Text('Not Available 😭'),
              loading: () => const CircularProgressIndicator.adaptive()),
          Expanded(
            child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: (context, index) {
                final currentCity = City.values[index];
                final isSelceted =
                    currentCity == ref.watch(currentCityProvider);
                return ListTile(
                  title: Text(
                    currentCity.toString(),
                  ),
                  trailing: isSelceted ? const Icon(Icons.check) : null,
                  onTap: () => ref.read(currentCityProvider.notifier).state =
                      currentCity,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
