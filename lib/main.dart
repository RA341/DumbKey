import 'package:dumbkey/controllers/auth_controller.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/settings_model/settings.dart';
import 'package:dumbkey/services/auth/database_auth.dart';
import 'package:dumbkey/services/database/local/secure_storage_handler.dart';
import 'package:dumbkey/services/firebase.dart';
import 'package:dumbkey/services/settings_handler.dart';
import 'package:dumbkey/ui/auth_page/auth_page.dart';
import 'package:dumbkey/ui/home.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

Future<void> initServices() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [SettingsSchema, PasswordSchema, NotesSchema, CardDetailsSchema],
    directory: dir.path,
  );

  dep
    ..registerLazySingleton(SecureStorageHandler.new)
    ..registerLazySingleton<Isar>(() => isar)
    ..registerSingleton<SettingsHandler>(await SettingsHandler.initSettings(isar));

  initFirebaseServices();
  dep.registerSingleton<DatabaseAuth>(DatabaseAuth());

  if (dep.get<DatabaseAuth>().isSignedIn) {
    await initDatabaseHandlers(signup: false);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await initServices();
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
        child: dep.get<DatabaseAuth>().isSignedIn ? const HomePage() : const LoginScreen(),
      ),
    );
  }
}
