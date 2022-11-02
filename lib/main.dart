 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'screens/screens.dart';

void main() => runApp(AppState());



class AppState extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider (
        providers:[ChangeNotifierProvider(create:(_) => MoviesProvider(), lazy:false,)],
      child: MyApp(),

    );

  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
   debugShowCheckedModeBanner: false,
      title:  "Peliculas",
      initialRoute: 'home',
      routes: {
     'home':(_)=> const HomeScreen(),
      'details':(_)=> const DetailsScreen()
      },
      theme: ThemeData.light().copyWith(
        appBarTheme:  const AppBarTheme(
          color: Color(0xff0E172A)
        )
      ),

    );
  }
}