// data/skill_data.dart — the mastery catalog's spine: 4 stats → 21 skills →
// 1,000+ nodes. The model lives in catalog/model.dart; the node data lives in
// catalog/{int,wis,cha,dex}_skills.dart; this file re-exports the model and
// assembles the whole sky.
//
// GRAND BRAID overhaul 2026-07-07 (docs/curriculum/PARALLEL.md). Six laws
// govern every constellation:
//
//   1. PARALLEL — each tree is 6–9 named branches that can be worked at the
//      same time; a stuck branch never blocks the whole sky. Real mastery is
//      broad before it is tall.
//   2. SELF-ACHIEVABLE — books, free courses, released exams, video-assessed
//      certificates, public arenas, logged practice. Exam mimicry wherever
//      the official gate is closed; no institution's permission anywhere.
//   3. QUEST-BEARING — every node carries a `guide` (what to do) and a
//      `proof` (the completion standard the Examiner demands evidence against
//      and the Reviewer quizzes from). A star is a quest, not a checkbox.
//   4. CONVERGENT — branches braid at synthesis stars and every path ends at
//      one crown: no orphan stars, everything you light matters at the top.
//   5. SAFE — nothing demands unsupervised danger: dead-circuit electrics,
//      dojo-supervised sparring, vocal health before power, jack-stand
//      discipline, food safety first.
//   6. HONEST HOURS — every node carries a researched deliberate-practice
//      estimate, so the analytics in tool/analyze_catalog.dart stay real.
//
// Node ids are unique per tree but NOT globally (maths and mechanics both use
// m1..); persistence keys progress by `skillId.nodeId` — see [progressKey].
//
// Pure Dart by design (no dart:ui) so `dart tool/analyze_catalog.dart` can
// compute over the catalog without a Flutter toolchain.
import 'catalog/cha_skills.dart';
import 'catalog/dex_skills.dart';
import 'catalog/int_skills.dart';
import 'catalog/model.dart';
import 'catalog/wis_skills.dart';

export 'catalog/model.dart';

final List<StatDomain> catalog = [
  StatDomain('INT', 'Intelligence', 0xFF00D4FF, intSkills),
  StatDomain('WIS', 'Wisdom', 0xFFC084FC, wisSkills),
  StatDomain('CHA', 'Charisma', 0xFFFB923C, chaSkills),
  StatDomain('DEX', 'Dexterity', 0xFF4ADE80, dexSkills),
];

StatDomain statById(String id) => catalog.firstWhere((s) => s.id == id);

Skill skillById(String id) =>
    catalog.expand((s) => s.skills).firstWhere((sk) => sk.id == id);

/// Total node count across every constellation (the "lifetime mastery" count).
final int totalNodeCount = catalog.fold(
    0, (sum, s) => sum + s.skills.fold(0, (x, sk) => x + sk.tree.length));
