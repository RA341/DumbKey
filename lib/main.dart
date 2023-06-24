import 'dart:io';
import 'package:dumbkey/logic/abstract_firestore.dart';
import 'package:dumbkey/logic/firestore_desktop.dart';
import 'package:dumbkey/logic/firestore_mobile.dart';
import 'package:dumbkey/ui/home.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final getIt = GetIt.instance;
  if (Platform.isWindows || Platform.isLinux) {
    getIt.registerLazySingleton<FireStoreBase>(
      DesktopFirestore.new,
      instanceName: Constants.database,
    );
  } else {
    getIt.registerLazySingletonAsync<FireStoreBase>(
      () async => await MobileFireStore.init(),
      instanceName: Constants.database,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DumbKey',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SafeArea(child: HomePage()),
    );
  }
}
