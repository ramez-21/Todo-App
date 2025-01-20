import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_app/home.dart';
import 'package:to_do_app/todo_bloc/todo_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.white,
          onPrimary: Colors.teal,
          secondary: Colors.teal,
          surface: Colors.white,
        ),
      ),
      home: BlocProvider(
        create: (context) => TodoBloc()
          ..add(
            TodoStarted(),
          ),
        child: HomeScreen(),
      ),
    );
  }
}
