// dev/preview_main.dart — development-only entrypoint for visual review and
// screenshots. Not shipped: the app builds from lib/main.dart.
//
//   flutter build linux -t lib/dev/preview_main.dart \
//     --dart-define=PREVIEW=constellation
//
// PREVIEW = galaxy | constellation | sheet   (default: galaxy)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repository.dart';
import '../data/skill_data.dart';
import '../state/providers.dart';
import '../ui/constellation_screen.dart';
import '../ui/galaxy_screen.dart';
import '../ui/node_sheet.dart';
import '../ui/theme.dart';

const _preview = String.fromEnvironment('PREVIEW', defaultValue: 'galaxy');

void main() {
  // Seed a believable mid-journey state: the first chunk of maths ignited,
  // a couple of roots elsewhere.
  final repo = InMemoryProgressRepository();
  void lit(String skillId, String nodeId) => repo.save(
      progressKey(skillId, nodeId),
      NodeProgress(
          completedAt: DateTime(2026, 6, 1),
          summary: 'Seeded preview progress.'));
  for (final id in ['m1', 'm2', 'm3', 'm4', 'm5', 'm6', 'm7']) {
    lit('maths', id);
  }
  lit('science', 'sc1');
  lit('piano', 'p1');
  lit('karate', 'k1');
  lit('karate', 'k2');

  runApp(ProviderScope(
    overrides: [repositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      title: 'Mental (preview)',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: switch (_preview) {
        'constellation' =>
          const ConstellationScreen(statId: 'INT', skillId: 'maths'),
        'sheet' => const _SheetPreview(),
        _ => const GalaxyScreen(),
      },
    ),
  ));
}

/// Opens the maths m8 node sheet (unlocked, unlit) over its constellation.
class _SheetPreview extends ConsumerStatefulWidget {
  const _SheetPreview();
  @override
  ConsumerState<_SheetPreview> createState() => _SheetPreviewState();
}

class _SheetPreviewState extends ConsumerState<_SheetPreview> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final skill = skillById('maths');
      showNodeSheet(context, ref,
          stat: statById('INT'), skill: skill, node: skill.nodeById('m8'));
    });
  }

  @override
  Widget build(BuildContext context) =>
      const ConstellationScreen(statId: 'INT', skillId: 'maths');
}
