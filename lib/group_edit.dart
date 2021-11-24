import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fairteams/model.dart';
import 'package:fairteams/state.dart';
import 'package:fairteams/utils.dart';

class GroupEdit extends StatefulWidget {
  const GroupEdit({Key? key, this.group}) : super(key: key);

  final Group? group;

  @override
  _GroupEditState createState() => _GroupEditState();
}

class _GroupEditState extends State<GroupEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _autoValidateModeIndex = AutovalidateMode.disabled.index;

  String _name = '';
  String _sport = '';
  List<Skill> _skills = [];
  List<Player> _players = [];

  static final _defaultSkills = {
    'basketball': [
      Skill(id: '1', name: 'Passing'),
      Skill(id: '2', name: 'Positioning'),
      Skill(id: '3', name: 'Shooting'),
      Skill(id: '4', name: 'Fitness'),
    ],
    'charades': [
      Skill(id: '1', name: 'Acting'),
      Skill(id: '2', name: 'Guessing'),
    ],
    'cricket': [
      Skill(id: '1', name: 'Batting'),
      Skill(id: '2', name: 'Bowling'),
      Skill(id: '3', name: 'Fielding'),
      Skill(id: '4', name: 'Wicket-keeping'),
    ],
    'football': [
      Skill(id: '1', name: 'Defending'),
      Skill(id: '2', name: 'Passing'),
      Skill(id: '3', name: 'Pace'),
      Skill(id: '4', name: 'Dribbling'),
      Skill(id: '5', name: 'Shooting'),
    ],
    'hockey': [
      Skill(id: '1', name: 'Passing'),
      Skill(id: '2', name: 'Positioning'),
      Skill(id: '3', name: 'Shooting'),
      Skill(id: '4', name: 'Fitness'),
    ],
    'netball': [
      Skill(id: '1', name: 'Passing'),
      Skill(id: '2', name: 'Positioning'),
      Skill(id: '3', name: 'Shooting'),
      Skill(id: '4', name: 'Fitness'),
    ],
    'rugby': [
      Skill(id: '1', name: 'Passing'),
      Skill(id: '2', name: 'Positioning'),
      Skill(id: '3', name: 'Tackling'),
      Skill(id: '4', name: 'Kicking'),
      Skill(id: '5', name: 'Catching'),
      Skill(id: '6', name: 'Fitness'),
    ],
    'shinty': [
      Skill(id: '1', name: 'Dribbling'),
      Skill(id: '2', name: 'Hitting'),
      Skill(id: '3', name: 'Tackling'),
      Skill(id: '4', name: 'Fitness'),
    ],
    'quiz': [
      Skill(id: '1', name: 'General'),
      Skill(id: '2', name: 'Geography'),
      Skill(id: '3', name: 'History'),
      Skill(id: '4', name: 'Music'),
      Skill(id: '5', name: 'Pop Culture'),
      Skill(id: '6', name: 'Science'),
      Skill(id: '7', name: 'Sport'),
    ],
    'other': [],
  };

  @override
  void initState() {
    super.initState();
    if (widget.group == null) {
      _name = '';
      _sport = 'football';
      _skills = List.from(_defaultSkills[_sport]!);
    } else {
      _name = widget.group?.name ?? '';
      _sport = widget.group?.sport ?? '';
      _skills = List.from(widget.group?.skills ?? []);
      _players = widget.group?.players ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.group == null) ? 'New Group' : 'Edit Group'),
      ),
      body: Box(
          child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.values[_autoValidateModeIndex],
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: Column(
              children: [
                    _nameInput(),
                    const SizedBox(height: 16),
                    _sportInput(),
                    const SizedBox(height: 24),
                    Text('SKILLS', style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 8),
                  ] +
                  _skillsInput(context) +
                  [
                    const SizedBox(height: 8),
                    IconButton(
                        icon: Icon(Icons.add_circle,
                            color: primaryColor(context), size: 32.0),
                        onPressed: () => setState(() => _skills.add(Skill())),
                        tooltip: 'New Skill'),
                  ],
            ),
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleSubmitted(context),
        label: const Text('Save'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _nameInput() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: TextFormField(
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            filled: false,
            icon: Icon(Icons.group, color: primaryColor(context)),
            hintText: 'What is the group called?',
            labelText: 'Group Name*',
          ),
          initialValue: _name,
          onChanged: (value) {
            setState(() => _name = value.toString());
          },
          onSaved: (value) {
            setState(() => _name = value?.toString() ?? '');
          },
          validator: _validateName,
        ));
  }

  Widget _sportInput() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: DropdownButtonFormField(
          value: _sport,
          decoration: InputDecoration(
            filled: false,
            icon: Group(sport: _sport).icon(color: primaryColor(context)),
            labelText: 'Sport',
          ),
          items: <String>[
            'Basketball',
            'Charades',
            'Cricket',
            'Football',
            'Hockey',
            'Netball',
            'Quiz',
            'Rugby',
            'Shinty',
            'Quiz',
            'Other',
          ]
              .map((String value) => DropdownMenuItem(
                    value: value.toLowerCase(),
                    child: Text(value),
                  ))
              .toList(),
          onChanged: (value) => setState(() {
            _sport = value.toString();
            _skills = List.from(_defaultSkills[_sport.toLowerCase()] ?? []);
          }),
          onSaved: (value) => setState(() => _sport = value.toString()),
        ));
  }

  List<Widget> _skillsInput(BuildContext context) {
    void onNameSaved(index, value) {
      _skills[index].name = value.toString();
    }

    void onImportanceSaved(index, value) {
      _skills[index].importance = (value == 'high')
          ? 2.0
          : (value == 'low')
              ? 0.5
              : 1.0;
    }

    return _skills
        .asMap()
        .entries
        .map((e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(children: [
              // Skill name
              Expanded(
                  child: TextFormField(
                key: Key(_sport + e.value.id),
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  filled: false,
                  icon: Icon(Icons.flash_on, color: primaryColor(context)),
                  labelText: 'Skill',
                  hintText: 'Name of this skill?',
                ),
                initialValue: e.value.name,
                onChanged: (value) => setState(() => onNameSaved(e.key, value)),
                onSaved: (value) => setState(() => onNameSaved(e.key, value)),
                validator: _validateName,
              )),
              const SizedBox(width: 10),
              // Importance
              SizedBox(
                  width: 100,
                  child: DropdownButtonFormField(
                    value: (e.value.importance > 1)
                        ? 'high'
                        : (e.value.importance < 1)
                            ? 'low'
                            : 'medium',
                    decoration: const InputDecoration(
                      filled: false,
                      labelText: 'Importance',
                    ),
                    items: <String>['High', 'Medium', 'Low']
                        .map((String value) => DropdownMenuItem(
                              value: value.toLowerCase(),
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => onImportanceSaved(e.key, value)),
                    onSaved: (value) =>
                        setState(() => onImportanceSaved(e.key, value)),
                  )),
              // Delete button
              SizedBox(
                width: 50,
                child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.grey[600]),
                    onPressed: () => setState(() => _skills.removeAt(e.key)),
                    tooltip: 'Delete Skill'),
              ),
            ])))
        .toList();
  }

  String? _validateName(String? value) {
    String val = (value == null) ? '' : value.toString();
    if (val.isEmpty) {
      return 'Name required';
    }
    final nameExp = RegExp(r'^[A-Za-z0-9 ]+$');
    if (!nameExp.hasMatch(val)) {
      return 'Alphanumeric characters only';
    }
    return null;
  }

  void _handleSubmitted(BuildContext context) {
    final form = _formKey.currentState;
    final bool isValid = form?.validate() ?? false;
    if (!isValid) {
      _autoValidateModeIndex = AutovalidateMode.always.index;
    } else {
      Group group = Group(
          id: widget.group?.id,
          name: _name,
          sport: _sport,
          skills: _skills,
          players: _players);
      print(_skills.map((s) => s.name).toList().toString());
      form?.save();
      Provider.of<AppState>(context, listen: false).addOrUpdateGroup(group);
      Navigator.of(context).pop();
    }
  }
}
