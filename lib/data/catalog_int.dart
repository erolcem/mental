// data/catalog_int.dart — the INT stat: its skills in
// display order. The trees live in catalog_<skill>.dart part files.
part of 'skill_data.dart';

final StatDomain intDomain = StatDomain('INT', 'Intelligence', 0xFF00D4FF, [
  scienceTree,
  mathsTree,
  medicineTree,
  engineeringTree,
]);
