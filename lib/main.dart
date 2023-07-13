import 'package:dumbkey/logic/database_auth.dart';
import 'package:dumbkey/logic/settings_handler.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/settings_model/settings.dart';
import 'package:dumbkey/ui/auth_page/auth_page.dart';
import 'package:dumbkey/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

Future<void> initDatabase() async {
  final log = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 3,
      lineLength: 80,
    ),
  );
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [SettingsSchema, PasswordSchema, NotesSchema, CardDetailsSchema],
    directory: dir.path,
  );

  GetIt.I
    ..registerSingleton<Logger>(log)
    ..registerLazySingleton<Isar>(() => isar)
    ..registerSingleton<SettingsHandler>(await SettingsHandler.initSettings(isar))
    ..registerSingleton<DatabaseAuth>(DatabaseAuth());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DumbKey',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: SafeArea(
        child: GetIt.I.get<DatabaseAuth>().isSignedIn ? const HomePage() : const LoginScreen(),
      ),
    );
  }
}
