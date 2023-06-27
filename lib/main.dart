import 'package:dumbkey/database/database_handler.dart';
import 'package:dumbkey/logic/settings_handler.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/model/settings.dart';
import 'package:dumbkey/ui/home/home.dart';
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
    [SettingsSchema, PassKeySchema],
    directory: dir.path,
  );

  GetIt.I
    ..registerSingleton<Logger>(log)
    ..registerLazySingleton<Isar>(() => isar)
    ..registerSingleton<SettingsHandler>(await SettingsHandler.initSettings(isar))
    ..registerSingleton<DatabaseHandler>(DatabaseHandler());
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
