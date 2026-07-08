// main.dart — app entry. Loads the persistent repository before first frame,
// then overrides the provider so all state reads from on-device storage
// (same startup pattern as physical).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/persistent_repository.dart';
import 'data/sync.dart';
import 'state/providers.dart';
import 'state/sync_controller.dart';
import 'ui/galaxy_screen.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = await PersistentProgressRepository.create();
  final journalRepo = await PersistentJournalRepository.create();
  final syncStore = await PrefsSyncKeyStore.create();
  // Stars ignited before the review system existed get a schedule from today.
  backfillReviewSchedules(repo);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark, // iOS: dark bg → light content
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(ProviderScope(
    overrides: [
      repositoryProvider.overrideWithValue(repo),
      journalRepositoryProvider.overrideWithValue(journalRepo),
      syncKeyStoreProvider.overrideWithValue(syncStore),
    ],
    child: const MentalApp(),
  ));
}

class MentalApp extends StatelessWidget {
  const MentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      // iOS: multiline fields have no Done key, so tapping anywhere outside
      // a field is the way to lower the keyboard.
      builder: (context, child) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: child,
      ),
      home: const GalaxyScreen(),
    );
  }
}
