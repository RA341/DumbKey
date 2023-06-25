import 'package:dumbkey/database/firestore_dekstop.dart';
import 'package:dumbkey/database/firestore_stub.dart';
import 'package:dumbkey/logic/settings_handler.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/model/settings.dart';
import 'package:dumbkey/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

Future<void> initDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [SettingsSchema, PassKeySchema],
    directory: dir.path,
  );

  GetIt.I
    ..registerSingleton<SettingsHandler>(await SettingsHandler.initSettings(isar))
    ..registerSingleton<FireStoreBase>(DesktopFireStore(isar));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ignore: cascade_invocations

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
