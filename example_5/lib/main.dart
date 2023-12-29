// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: MainApp(),
      ),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final people = ref.watch(peopleNoitfier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: ListView.builder(
        itemCount: people.index,
        itemBuilder: (context, index) {
          return ListTile(
            title: GestureDetector(
              child: Text(people.people[index].displayInfo),
              onTap: () async {
                final existingPerson = await updateOrCreatePerson(
                  context,
                  people.people[index],
                );
                if (existingPerson != null) {
                  people.updatePerson(existingPerson);
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPerson = await updateOrCreatePerson(context);
          if (newPerson != null) {
            ref.read(peopleNoitfier).addPerson(newPerson);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Person {
  final String name;
  final int age;
  final String uuid;
  Person({
    String? uuid,
    required this.name,
    required this.age,
  }) : uuid = uuid ?? const Uuid().v4();

  Person copyWith({
    String? name,
    int? age,
  }) =>
      Person(
        name: name ?? this.name,
        age: age ?? this.age,
        uuid: uuid,
      );

  String get displayInfo => '$name and age $age';
  @override
  bool operator ==(covariant Person other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() => 'Person(name:$name, age:$age, uuid:$uuid)';
}

class PeopleNoitfier extends ChangeNotifier {
  final List<Person> _people = [];
  int get index => _people.length;
// diferences between changeProviderNotifier and stateProviderNotifier
// due to the state itself modifiable we have to use make state Unmodifiable and private alike stateProviderNotifier
// in this use case changeNotifier is the right approach with the unmodifiable and _private property
  UnmodifiableListView<Person> get people => UnmodifiableListView(_people);

  void addPerson(Person person) {
    _people.add(person);
    notifyListeners();
  }

  void remove(Person person) {
    _people.remove(person);
    notifyListeners();
  }

  void updatePerson(Person updatePerson) {
    final index = _people.indexOf(updatePerson);
    final oldPerson = _people[index];
    if (oldPerson.name != updatePerson.name ||
        oldPerson.age != updatePerson.age) {
      _people[index] = oldPerson.copyWith(
        age: updatePerson.age,
        name: updatePerson.name,
      );
      notifyListeners();
    }
  }
}

// class PeopleStateNotifier extends StateNotifier<List<Person>> {
//   PeopleStateNotifier(super.state);
//   int get count => state.length;

//   void add(Person newPerson) {
//     state = [...state, newPerson];
//   }

//   void remove(Person person) {
//     state = state.where((item) => item != person).toList();
//   }

//   void update(Person existingPerson) {
//     final index = state.indexOf(existingPerson);
//     final oldPerson = state[index];
//     if (oldPerson.age != existingPerson.age ||
//         oldPerson.name != existingPerson.name) {
//       state[index] = oldPerson.copyWith(
//         name: existingPerson.name,
//         age: existingPerson.age,
//       );
//       state = [...state.where((element) => element == state[index])];
//       debugPrint(state.toString());
//     }
//   }
// }

// final peopleProviderNoitfier =
//     StateNotifierProvider<PeopleStateNotifier, List<Person>>(
//   (ref) => PeopleStateNotifier([]),
// );
final peopleNoitfier = ChangeNotifierProvider(
  (ref) => PeopleNoitfier(),
);

TextEditingController nameConntroller = TextEditingController();

TextEditingController ageConntroller = TextEditingController();

Future<Person?> updateOrCreatePerson(BuildContext context,
    [Person? existingPerson]) {
  String? name = existingPerson?.name;
  String? age = existingPerson?.age.toString();

  nameConntroller.text = name ?? '';
  ageConntroller.text = age ?? '';

  return showAdaptiveDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(existingPerson == null ? 'Create Person' : 'Update Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameConntroller,
              decoration: const InputDecoration(
                label: Text('Enter name'),
              ),
              onChanged: (value) => name = value,
            ),
            TextField(
              controller: ageConntroller,
              decoration: const InputDecoration(
                label: Text('Enter age '),
              ),
              onChanged: (value) => age = value,
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (name != null && age != null) {
                if (existingPerson != null) {
                  Navigator.pop(
                    context,
                    existingPerson.copyWith(
                      name: name,
                      age: int.tryParse(age!),
                    ),
                  );
                } else {
                  Navigator.pop(
                    context,
                    Person(
                      name: name!,
                      age: int.tryParse(age!)!,
                    ),
                  );
                }
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
