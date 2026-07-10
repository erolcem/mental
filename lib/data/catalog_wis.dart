// data/catalog_wis.dart — the WIS stat: its skills in
// display order. The trees live in catalog_<skill>.dart part files.
part of 'skill_data.dart';

final StatDomain wisDomain = StatDomain('WIS', 'Wisdom', 0xFFC084FC, [
  geographyTree,
  historyTree,
  businessTree,
  socialSciTree,
]);
