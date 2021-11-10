import 'package:fairteams/model.dart';

Map<String, Group> loadSampleGroups() {
  final defence = Skill(name: 'Defence', importance: 1.0);
  final passing = Skill(name: 'Passing', importance: 1.0);
  final physical = Skill(name: 'Physical', importance: 1.0);
  final dribbling = Skill(name: 'Dribbling', importance: 1.0);
  final shooting = Skill(name: 'Shooting', importance: 2.0);
  Group group = Group(name: 'Tuesday Football', sport: 'football', skills: [
    defence,
    passing,
    physical,
    dribbling,
    shooting,
  ], players: [
    Player(name: 'Alan', abilities: {
      defence.id: 9.0,
      passing.id: 9.0,
      physical.id: 6.0,
      dribbling.id: 6.0,
      shooting.id: 4.0,
    }),
    Player(name: 'Andi', abilities: {
      defence.id: 6.0,
      passing.id: 8.0,
      physical.id: 4.0,
      dribbling.id: 7.0,
      shooting.id: 6.0,
    }),
    Player(name: 'Chris', abilities: {
      defence.id: 6.0,
      passing.id: 8.0,
      physical.id: 7.0,
      dribbling.id: 7.0,
      shooting.id: 6.0,
    }),
    Player(name: 'Craig', abilities: {
      defence.id: 7.0,
      passing.id: 7.0,
      physical.id: 5.0,
      dribbling.id: 7.0,
      shooting.id: 7.0,
    }),
    Player(name: 'Dil', abilities: {
      defence.id: 3.0,
      passing.id: 3.0,
      physical.id: 3.0,
      dribbling.id: 2.0,
      shooting.id: 3.0,
    }),
    Player(name: 'Dougal', abilities: {
      defence.id: 5.0,
      passing.id: 8.0,
      physical.id: 9.0,
      dribbling.id: 5.0,
      shooting.id: 6.0,
    }),
    Player(name: 'Eugene', abilities: {
      defence.id: 4.0,
      passing.id: 5.0,
      physical.id: 6.0,
      dribbling.id: 8.0,
      shooting.id: 9.0,
    }),
    Player(name: 'Evan', abilities: {
      defence.id: 7.0,
      passing.id: 7.0,
      physical.id: 5.0,
      dribbling.id: 10.0,
      shooting.id: 8.0,
    }),
    Player(name: 'Greig', abilities: {
      defence.id: 9.0,
      passing.id: 9.0,
      physical.id: 8.0,
      dribbling.id: 6.0,
      shooting.id: 6.0,
    }),
    Player(name: 'John-Luke', abilities: {
      defence.id: 7.0,
      passing.id: 7.0,
      physical.id: 6.0,
      dribbling.id: 5.0,
      shooting.id: 5.0,
    }),
    Player(name: 'Joe', abilities: {
      defence.id: 9.0,
      passing.id: 7.0,
      physical.id: 8.0,
      dribbling.id: 5.0,
      shooting.id: 4.0,
    }),
    Player(name: 'Josh', abilities: {
      defence.id: 6.0,
      passing.id: 6.0,
      physical.id: 3.0,
      dribbling.id: 7.0,
      shooting.id: 4.0,
    }),
    Player(name: 'Mark', abilities: {
      defence.id: 3.0,
      passing.id: 7.0,
      physical.id: 5.0,
      dribbling.id: 8.0,
      shooting.id: 7.0,
    }),
    Player(name: 'Peter', abilities: {
      defence.id: 4.0,
      passing.id: 8.0,
      physical.id: 8.0,
      dribbling.id: 7.0,
      shooting.id: 6.0,
    }),
    Player(name: 'Robin', abilities: {
      defence.id: 6.0,
      passing.id: 8.0,
      physical.id: 6.0,
      dribbling.id: 7.0,
      shooting.id: 6.0,
    }),
    Player(name: 'Spybey', abilities: {
      defence.id: 7.0,
      passing.id: 8.0,
      physical.id: 7.0,
      dribbling.id: 6.0,
      shooting.id: 4.0,
    }),
    Player(name: 'Stefan', abilities: {
      defence.id: 3.0,
      passing.id: 3.0,
      physical.id: 5.0,
      dribbling.id: 3.0,
      shooting.id: 3.0,
    }),
    Player(name: 'Steve', abilities: {
      defence.id: 8.0,
      passing.id: 9.0,
      physical.id: 8.0,
      dribbling.id: 10.0,
      shooting.id: 10.0,
    }),
    Player(name: 'Tim', abilities: {
      defence.id: 7.0,
      passing.id: 8.0,
      physical.id: 9.0,
      dribbling.id: 10.0,
      shooting.id: 10.0,
    }),
    Player(name: 'Tom', abilities: {
      defence.id: 8.0,
      passing.id: 6.0,
      physical.id: 9.0,
      dribbling.id: 6.0,
      shooting.id: 5.0,
    }),
  ]);
  return {group.id: group};
}
