import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fairteams/state.dart';
import 'package:fairteams/model.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key, required this.group, this.playerId})
      : super(key: key);

  final Group group;
  final String? playerId;

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _autoValidateModeIndex = AutovalidateMode.disabled.index;

  String _name = '';
  Map<String, double> _skills = {};
  Set<String> _existingNames = {};

  @override
  void initState() {
    super.initState();
    _existingNames = widget.group.players.map((player) => player.name).toSet();
    if (widget.playerId == null) {
      _name = '';
      _skills = {};
    } else {
      _name = widget.group.player(widget.playerId!).name;
      _skills =
          Map.from(widget.group.player(widget.playerId.toString()).skills);
      _existingNames.remove(_name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, model, child) {
      String title = 'New Player';
      List<Widget> actions = [];
      if (widget.playerId != null) {
        title = 'Edit Player';
        actions = [
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removePlayer(model),
              tooltip: 'New Player'),
        ];
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: actions,
        ),
        body: _buildForm(context, model),
      );
    });
  }

  Widget _buildForm(BuildContext context, AppState model) {
    const sizedBoxSpace = SizedBox(height: 24);
    List<Widget> fields = [
      sizedBoxSpace,
      _nameInput(),
      sizedBoxSpace,
    ];
    for (final skillName in widget.group.skillNames) {
      fields += _skillSlider(context, model, skillName);
      fields += [sizedBoxSpace];
    }
    fields += [
      _submitButton(context, model),
      sizedBoxSpace,
      Text(
        '* indicates required field',
        style: Theme.of(context).textTheme.caption,
      ),
    ];
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.values[_autoValidateModeIndex],
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: fields),
        ),
      ),
    );
  }

  Widget _nameInput() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        filled: true,
        icon: Icon(Icons.person),
        hintText: 'What is their name?',
        labelText: 'Name*',
      ),
      initialValue: _name,
      onSaved: (value) {
        _name = (value == null) ? '' : value.toString();
      },
      validator: _validateName,
    );
  }

  List<Widget> _skillSlider(
      BuildContext contex, AppState state, String skillName) {
    var value = _skills[skillName] ?? 5;
    return [
      Text(skillName, style: Theme.of(context).textTheme.bodyText1),
      Slider(
        value: value,
        min: 0,
        max: 10,
        divisions: 10,
        label: value.round().toString(),
        activeColor: skillColor(value),
        onChanged: (double value) {
          setState(() {
            _skills[skillName] = value;
          });
        },
      ),
    ];
  }

  Widget _submitButton(BuildContext context, AppState model) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _handleSubmitted(context, model),
        child: const Text('Save'),
      ),
    );
  }

  String? _validateName(String? value) {
    String val = (value == null) ? '' : value.toString();
    if (val.isEmpty) {
      return 'Name required';
    }
    final nameExp = RegExp(r'^[A-Za-z0-9\- ]+$');
    if (!nameExp.hasMatch(val)) {
      return 'Alphanumeric characters only';
    }
    if (_existingNames.contains(value)) {
      return 'There is already a "$value"';
    }
    return null;
  }

  void _handleSubmitted(BuildContext context, AppState state) {
    final form = _formKey.currentState;
    final bool isValid = form?.validate() ?? false;
    if (!isValid) {
      _autoValidateModeIndex = AutovalidateMode.always.index;
    } else {
      form?.save();
      Player player = Player(id: widget.playerId, name: _name, skills: _skills);
      state.addOrUpdatePlayer(widget.group.id, player);
      Navigator.of(context).pop();
    }
  }

  void _removePlayer(AppState state) {
    state.removePlayer(widget.group.id, widget.playerId ?? '');
    Navigator.of(context).pop();
  }
}
