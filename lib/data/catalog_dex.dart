// data/catalog_dex.dart — the DEX stat: its skills in
// display order. The trees live in catalog_<skill>.dart part files.
part of 'skill_data.dart';

final StatDomain dexDomain = StatDomain('DEX', 'Dexterity', 0xFF4ADE80, [
  drawingTree,
  writingTree,
  cookingTree,
  mechanicsTree,
  memoryTree,
  karateTree,
]);
