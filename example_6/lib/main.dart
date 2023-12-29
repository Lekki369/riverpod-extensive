// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

@immutable
class Film {
  final String id;
  final String description;
  final String title;
  final bool isFavourite;

  const Film(
      {required this.id,
      required this.description,
      required this.title,
      required this.isFavourite});

  Film copyWith({
    required bool isFavourite,
  }) =>
      Film(
        id: id,
        description: description,
        title: title,
        isFavourite: isFavourite,
      );

  @override
  String toString() => 'Film(id: $id, description: $description, '
      'title: $title, isFavorite: $isFavourite)';

  @override
  bool operator ==(covariant Film other) =>
      id == other.id && isFavourite == other.isFavourite;

  @override
  int get hashCode => Object.hashAll([
        id,
        isFavourite,
      ]);
}

enum FavouriteStatus {
  all,
  favourite,
  notFavourite,
}

const List<Film> films = [
  Film(
    id: '001',
    description:
        'A heartwarming tale of friendship and adventure as a group of kids embarks on a quest to find a lost treasure.',
    title: 'The Treasure Hunters',
    isFavourite: true,
  ),
  Film(
    id: '002',
    description:
        'An epic science fiction saga set in a distant galaxy, following the journey of a reluctant hero to save the universe.',
    title: 'Galactic Odyssey',
    isFavourite: false,
  ),
  Film(
    id: '003',
    description:
        'A romantic comedy about two strangers who swap houses for the holidays and find unexpected love.',
    title: 'Holiday Swap',
    isFavourite: true,
  ),
  Film(
    id: '004',
    description:
        'A gripping psychological thriller that keeps you on the edge of your seat with its unexpected twists and turns.',
    title: 'Mind Games',
    isFavourite: false,
  ),
  Film(
    id: '005',
    description:
        'A heart-wrenching drama portraying the struggles and triumphs of a young musician striving for success in the big city.',
    title: 'Melody of Dreams',
    isFavourite: true,
  ),
  Film(
    id: '006',
    description:
        'A historical epic depicting the rise and fall of an ancient empire amidst political intrigue and betrayal.',
    title: "Empire's Legacy",
    isFavourite: false,
  ),
  Film(
    id: '007',
    description:
        'A laugh-out-loud comedy following the chaotic adventures of a dysfunctional family on a road trip.',
    title: 'Crazy Roadsters',
    isFavourite: true,
  ),
  Film(
    id: '008',
    description:
        'A gripping courtroom drama that explores the complexities of justice and morality in a high-profile murder case.',
    title: 'Beyond Reasonable Doubt',
    isFavourite: false,
  ),
  Film(
    id: '009',
    description:
        'An animated fantasy adventure where mythical creatures and heroes unite to save their enchanted world from darkness.',
    title: 'Realm of Legends',
    isFavourite: true,
  ),
  Film(
    id: '010',
    description:
        'A thrilling action-packed spy film that follows an undercover agent on a mission to stop a global threat.',
    title: 'Code Red',
    isFavourite: false,
  ),
  Film(
    id: '011',
    description:
        "A heartwarming story of a dog's unwavering loyalty and courage as he searches for his lost owner.",
    title: "Fido's Journey",
    isFavourite: true,
  ),
  Film(
    id: '012',
    description:
        'A captivating documentary showcasing the wonders of nature in remote and untouched landscapes.',
    title: 'Wild Explorations',
    isFavourite: false,
  ),
  Film(
    id: '013',
    description:
        'A coming-of-age drama about a group of friends navigating the challenges of adolescence and self-discovery.',
    title: 'Teenage Chronicles',
    isFavourite: true,
  ),
  Film(
    id: '014',
    description:
        'A suspenseful horror film set in a haunted mansion where a group of friends faces terrifying paranormal encounters.',
    title: 'Eerie Manor',
    isFavourite: false,
  ),
  Film(
    id: '015',
    description:
        'A musical extravaganza featuring dazzling performances and heartfelt stories set in the vibrant world of Broadway.',
    title: 'Stage Rhythms',
    isFavourite: true,
  ),
  Film(
    id: '016',
    description:
        "A gripping sports drama following the underdog team's journey to victory against all odds.",
    title: 'Against the Odds',
    isFavourite: false,
  ),
  Film(
    id: '017',
    description:
        'A whimsical fantasy adventure about a young magician on a quest to restore magic to a world plagued by darkness.',
    title: 'Enchanted Spells',
    isFavourite: true,
  ),
  Film(
    id: '018',
    description:
        'A thought-provoking science fiction film exploring the ethical dilemmas of artificial intelligence and its impact on humanity.',
    title: 'Synthetic Conscience',
    isFavourite: false,
  ),
  Film(
    id: '019',
    description:
        'A heartrending war drama depicting the sacrifices and courage of soldiers on the battlefield.',
    title: 'Courageous Valor',
    isFavourite: true,
  ),
  Film(
    id: '020',
    description:
        'A light-hearted family comedy about a mischievous pet causing chaos in a suburban neighborhood.',
    title: 'Paws and Whiskers',
    isFavourite: false,
  ),
];

final favouriteStatusProvider = StateProvider<FavouriteStatus>(
  (ref) => FavouriteStatus.all,
);

final allFilmsProvider =
    StateNotifierProvider<FilmsNofifier, List<Film>>((ref) {
  ref.watch(favouriteStatusProvider);
  return FilmsNofifier();
});

final favouriterFilmProvider = Provider(
  (ref) => ref.watch(allFilmsProvider).where(
        (film) => film.isFavourite,
      ),
);
final notfavouriterFilmProvider = Provider(
  (ref) => ref.watch(allFilmsProvider).where(
        (film) => !film.isFavourite,
      ),
);

class FilmsNofifier extends StateNotifier<List<Film>> {
  FilmsNofifier() : super(films);

  void update(Film film, bool isFavourite) {
    state = state
        .map(
          (thisFilm) => thisFilm == film
              ? thisFilm.copyWith(isFavourite: isFavourite)
              : thisFilm,
        )
        .toList();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: FilterWidget(),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final filter = ref.watch(favouriteStatusProvider);
                  switch (filter) {
                    case FavouriteStatus.all:
                      return FilmsList(provider: allFilmsProvider);
                    case FavouriteStatus.favourite:
                      return FilmsList(provider: favouriterFilmProvider);
                    case FavouriteStatus.notFavourite:
                      return FilmsList(provider: notfavouriterFilmProvider);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FilmsList extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;
  const FilmsList({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
      child: ListView.builder(
        itemCount: films.length,
        itemBuilder: (context, index) {
          final film = films.elementAt(index);
          final filmFavourite = film.isFavourite
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              : const Icon(Icons.favorite_outline);
          return ListTile(
            title: Text(film.title),
            subtitle: Text(film.description),
            trailing: IconButton(
              onPressed: () {
                final isFavourite = !film.isFavourite;
                ref.read(allFilmsProvider.notifier).update(
                      film,
                      isFavourite,
                    );
              },
              icon: filmFavourite,
            ),
          );
        },
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final currentFavouriteStatus = ref.watch(favouriteStatusProvider);
        final filters = FavouriteStatus.values.map(
          (filter) => DropdownMenuItem(
            value: filter,
            child: Text(
              filter.name.split('.').last,
            ),
          ),
        );
        return DropdownButton(
          value: currentFavouriteStatus,
          items: [...filters],
          onChanged: (favouriteStatus) {
            ref.read(favouriteStatusProvider.notifier).state = favouriteStatus!;
          },
        );
      },
    );
  }
}
