import 'package:flutter/material.dart';
import 'package:peliculas/helpers/colors.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return Scaffold(
        backgroundColor: const Color(UtilsColors.cover),
        body: CustomScrollView(
          slivers: [
            _CustomAppBar(movie),
            SliverList(
                delegate: SliverChildListDelegate([
                  _PosterAndTitle(movie),
                  _Overriew(movie),
                  _Overriew(movie),
                  CastingCards(movie.id)
                ]))
          ],
        ));
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomAppBar(this.movie);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          color: Colors.black12,
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          child: Text(movie.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16)),
          padding: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullPoaterImg),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle(this.movie);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPoaterImg),
                height: 150,
                width: 110,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 190),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(movie.title,
                  style: textTheme.headline6
                      ?.merge(const TextStyle(color: Colors.white)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2),
              Text(movie.originalTitle,
                  style: textTheme.subtitle1
                      ?.merge(const TextStyle(color: Colors.white)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2),
              Row(
                children: [
                  const Icon(Icons.star_outline, size: 20, color: Colors.green),
                  const SizedBox(height: 10),
                  Text(
                    movie.voteCount.toString(),
                    style: textTheme.caption
                        ?.merge(const TextStyle(color: Colors.white)),
                  )
                ],
              )
            ]),
          )
        ],
      ),
    );
  }
}

class _Overriew extends StatelessWidget {
  final Movie movie;

  const _Overriew(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.merge(const TextStyle(color: Colors.white)),
      ),
    );
  }
}
