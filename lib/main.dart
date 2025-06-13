import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/recipe/recipe_bloc.dart';
import 'bloc/favorite/favorite_bloc.dart';
import 'repositories/recipe_repository.dart';
import 'repositories/favorite_repository.dart';
import 'models/recipe.dart';
import 'screens/recipe_detail_screen.dart';
import 'screens/main_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyD01umSwp2Q9UpSLcQCYz6c6NtocIJwZLQ",
        authDomain: "flutter-83894.firebaseapp.com",
        projectId: "flutter-83894",
        storageBucket: "flutter-83894.appspot.com",
        messagingSenderId: "557147264910",
        appId: "1:557147264910:web:2338d11da784a1e548f6df",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FavoriteBloc(
            favoriteRepository: FavoriteRepository(),
            recipeRepository: RecipeRepository(),
          )..add(LoadFavoritesEvent()),
        ),
        BlocProvider(
          create: (context) => RecipeBloc(RecipeRepository())
            ..add(LoadRecipesEvent()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кулинарные рецепты',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const MainNavigator(),
      routes: {
        '/recipe-detail': (context) => RecipeDetailScreen(
              recipe: ModalRoute.of(context)!.settings.arguments as Recipe,
            ),
      },
    );
  }
}
