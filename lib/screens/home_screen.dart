import 'package:flutter/material.dart';
import 'package:peliculas/helpers/colors.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);

 /*   print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= Display Movies -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
    print(moviesProvider.onDisplayMovies);*/

    return Scaffold(
        appBar: AppBar(
          title: const Text('Peliculas en cines'),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()),
                icon: const Icon(Icons.search_outlined))
          ],
        ),
        backgroundColor:  const Color(UtilsColors.cover),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CardSwiper(movies: moviesProvider.onDisplayMovies),
              MovieSlider(
                category: "Populares",
                movies: moviesProvider.popularMovies,
                onNextPage: () => moviesProvider.getPopularMovies(),
              ),
              MovieSlider(
                category: "Top Rated",
                movies: moviesProvider.topRated,
                onNextPage: () => moviesProvider.getTopRated(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }
}
