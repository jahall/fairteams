import 'package:fairteams/model.dart';

Map<String, Group> loadSampleGroups() {
  final defence = Skill(name: 'Defence', importance: 1.0);
  final mistakes = Skill(name: 'Mistakes', importance: 1.0);
  final fitness = Skill(name: 'Fitness', importance: 1.0);
  final savvy = Skill(name: 'Savvy', importance: 1.0);
  final goals = Skill(name: 'Goals', importance: 2.0);
  Group group = Group(name: 'Tuesday Football', sport: 'football', skills: [
    defence,
    mistakes,
    fitness,
    savvy,
    goals,
  ], players: [
    Player(name: 'Alan', abilities: {
      defence.id: 9.0,
      mistakes.id: 9.0,
      fitness.id: 6.0,
      savvy.id: 6.0,
      goals.id: 4.0,
    }),
    Player(name: 'Andi', abilities: {
      defence.id: 6.0,
      mistakes.id: 8.0,
      fitness.id: 4.0,
      savvy.id: 7.0,
      goals.id: 6.0,
    }),
    Player(name: 'Chris', abilities: {
      defence.id: 6.0,
      mistakes.id: 8.0,
      fitness.id: 7.0,
      savvy.id: 7.0,
      goals.id: 6.0,
    }),
    Player(name: 'Craig', abilities: {
      defence.id: 7.0,
      mistakes.id: 7.0,
      fitness.id: 5.0,
      savvy.id: 7.0,
      goals.id: 7.0,
    }),
    Player(name: 'Dil', abilities: {
      defence.id: 3.0,
      mistakes.id: 3.0,
      fitness.id: 3.0,
      savvy.id: 2.0,
      goals.id: 3.0,
    }),
    Player(name: 'Dougal', abilities: {
      defence.id: 5.0,
      mistakes.id: 8.0,
      fitness.id: 9.0,
      savvy.id: 5.0,
      goals.id: 6.0,
    }),
    Player(name: 'Eugene', abilities: {
      defence.id: 4.0,
      mistakes.id: 5.0,
      fitness.id: 6.0,
      savvy.id: 8.0,
      goals.id: 9.0,
    }),
    Player(name: 'Evan', abilities: {
      defence.id: 7.0,
      mistakes.id: 7.0,
      fitness.id: 5.0,
      savvy.id: 10.0,
      goals.id: 8.0,
    }),
    Player(name: 'Greig', abilities: {
      defence.id: 9.0,
      mistakes.id: 9.0,
      fitness.id: 8.0,
      savvy.id: 6.0,
      goals.id: 6.0,
    }),
    Player(name: 'John-Luke', abilities: {
      defence.id: 7.0,
      mistakes.id: 7.0,
      fitness.id: 6.0,
      savvy.id: 5.0,
      goals.id: 5.0,
    }),
    Player(name: 'Joe', abilities: {
      defence.id: 9.0,
      mistakes.id: 7.0,
      fitness.id: 8.0,
      savvy.id: 5.0,
      goals.id: 4.0,
    }),
    Player(name: 'Josh', abilities: {
      defence.id: 6.0,
      mistakes.id: 6.0,
      fitness.id: 3.0,
      savvy.id: 7.0,
      goals.id: 4.0,
    }),
    Player(name: 'Mark', abilities: {
      defence.id: 3.0,
      mistakes.id: 7.0,
      fitness.id: 5.0,
      savvy.id: 8.0,
      goals.id: 7.0,
    }),
    Player(name: 'Peter', abilities: {
      defence.id: 4.0,
      mistakes.id: 8.0,
      fitness.id: 8.0,
      savvy.id: 7.0,
      goals.id: 6.0,
    }),
    Player(name: 'Robin', abilities: {
      defence.id: 6.0,
      mistakes.id: 8.0,
      fitness.id: 6.0,
      savvy.id: 7.0,
      goals.id: 6.0,
    }),
    Player(name: 'Spybey', abilities: {
      defence.id: 7.0,
      mistakes.id: 8.0,
      fitness.id: 7.0,
      savvy.id: 6.0,
      goals.id: 4.0,
    }),
    Player(name: 'Stefan', abilities: {
      defence.id: 3.0,
      mistakes.id: 3.0,
      fitness.id: 5.0,
      savvy.id: 3.0,
      goals.id: 3.0,
    }),
    Player(name: 'Steve', abilities: {
      defence.id: 8.0,
      mistakes.id: 9.0,
      fitness.id: 8.0,
      savvy.id: 10.0,
      goals.id: 10.0,
    }),
    Player(name: 'Tim', abilities: {
      defence.id: 7.0,
      mistakes.id: 8.0,
      fitness.id: 9.0,
      savvy.id: 10.0,
      goals.id: 10.0,
    }),
    Player(name: 'Tom', abilities: {
      defence.id: 8.0,
      mistakes.id: 6.0,
      fitness.id: 9.0,
      savvy.id: 6.0,
      goals.id: 5.0,
    }),
  ]);
  return {group.id: group};
}
