import 'package:fairteams/model.dart';

Map<String, Group> loadSampleGroups() {
  final defence = Skill(name: 'Defending', importance: 1.0);
  final passing = Skill(name: 'Passing', importance: 1.0);
  final physical = Skill(name: 'Pace', importance: 1.0);
  final dribbling = Skill(name: 'Dribbling', importance: 1.0);
  final shooting = Skill(name: 'Shooting', importance: 2.0);
  Group group =
      Group(name: 'Example Football League', sport: 'football', skills: [
    defence,
    passing,
    physical,
    dribbling,
    shooting,
  ], players: [
    Player(name: 'Archie', abilities: {
      // Alan
      defence.id: 9.0,
      passing.id: 9.0,
      physical.id: 6.0,
      dribbling.id: 6.0,
      shooting.id: 4.0,
    }),
    Player(name: 'Barclay', abilities: {
      // Andi
      defence.id: 6.0,
      passing.id: 6.0,
      physical.id: 4.0,
      dribbling.id: 7.0,
      shooting.id: 6.0,
    }),
    Player(name: 'Edna', abilities: {
      // Chris
      defence.id: 6.0,
      passing.id: 6.0,
      physical.id: 7.0,
      dribbling.id: 7.0,
      shooting.id: 6.0,
    }),
    Player(name: 'Fenella', abilities: {
      // Craig
      defence.id: 4.0,
      passing.id: 7.0,
      physical.id: 5.0,
      dribbling.id: 7.0,
      shooting.id: 8.0,
    }),
    Player(name: 'Fingal', abilities: {
      // Eugene
      defence.id: 4.0,
      passing.id: 6.0,
      physical.id: 6.0,
      dribbling.id: 8.0,
      shooting.id: 9.0,
    }),
    Player(name: 'Gilchrist', abilities: {
      // Evan
      defence.id: 7.0,
      passing.id: 7.0,
      physical.id: 7.0,
      dribbling.id: 10.0,
      shooting.id: 8.0,
    }),
    Player(name: 'Gillespie', abilities: {
      // Dil
      defence.id: 3.0,
      passing.id: 3.0,
      physical.id: 3.0,
      dribbling.id: 2.0,
      shooting.id: 3.0,
    }),
    Player(name: 'Grier', abilities: {
      // Dougal
      defence.id: 5.0,
      passing.id: 5.0,
      physical.id: 9.0,
      dribbling.id: 5.0,
      shooting.id: 6.0,
    }),
    Player(name: 'Irving', abilities: {
      // Greg
      defence.id: 6.0,
      passing.id: 7.0,
      physical.id: 7.0,
      dribbling.id: 6.0,
      shooting.id: 5.0,
    }),
    Player(name: 'Jamie', abilities: {
      // JL
      defence.id: 7.0,
      passing.id: 4.0,
      physical.id: 6.0,
      dribbling.id: 5.0,
      shooting.id: 5.0,
    }),
    Player(name: 'Kirsten', abilities: {
      // Joe
      defence.id: 9.0,
      passing.id: 4.0,
      physical.id: 8.0,
      dribbling.id: 5.0,
      shooting.id: 4.0,
    }),
    Player(name: 'Lindsay', abilities: {
      // Josh
      defence.id: 6.0,
      passing.id: 6.0,
      physical.id: 3.0,
      dribbling.id: 7.0,
      shooting.id: 4.0,
    }),
    Player(name: 'Niven', abilities: {
      // Mark Spicer
      defence.id: 5.0,
      passing.id: 7.0,
      physical.id: 5.0,
      dribbling.id: 8.0,
      shooting.id: 7.0,
    }),
    Player(name: 'Mairead', abilities: {
      // Mark Spybey
      defence.id: 7.0,
      passing.id: 8.0,
      physical.id: 7.0,
      dribbling.id: 6.0,
      shooting.id: 4.0,
    }),
    Player(name: 'Morag', abilities: {
      // Peter
      defence.id: 4.0,
      passing.id: 4.0,
      physical.id: 8.0,
      dribbling.id: 7.0,
      shooting.id: 6.0,
    }),
    Player(name: 'Moyna', abilities: {
      // Robin
      defence.id: 6.0,
      passing.id: 6.0,
      physical.id: 6.0,
      dribbling.id: 7.0,
      shooting.id: 6.0,
    }),
    Player(name: 'Rabbie', abilities: {
      // Stefan
      defence.id: 3.0,
      passing.id: 3.0,
      physical.id: 5.0,
      dribbling.id: 3.0,
      shooting.id: 3.0,
    }),
    Player(name: 'Ramsay', abilities: {
      // Steve
      defence.id: 8.0,
      passing.id: 9.0,
      physical.id: 8.0,
      dribbling.id: 9.0,
      shooting.id: 8.0,
    }),
    Player(name: 'Roderick', abilities: {
      // Tim
      defence.id: 7.0,
      passing.id: 9.0,
      physical.id: 9.0,
      dribbling.id: 10.0,
      shooting.id: 10.0,
    }),
    Player(name: 'Rory', abilities: {
      // Tom
      defence.id: 8.0,
      passing.id: 6.0,
      physical.id: 9.0,
      dribbling.id: 6.0,
      shooting.id: 5.0,
    }),
  ]);
  return {group.id: group};
}
