import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fairteams/state.dart';
import 'package:fairteams/model.dart';
import 'package:fairteams/slider.dart';

class PlayerEdit extends StatefulWidget {
  const PlayerEdit({Key? key, required this.group, this.player})
      : super(key: key);

  final Group group;
  final Player? player;

  @override
  _PlayerEditState createState() => _PlayerEditState();
}

class _PlayerEditState extends State<PlayerEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _autoValidateModeIndex = AutovalidateMode.disabled.index;

  String _name = '';
  Map<String, double> _abilities = {};
  Set<String> _existingNames = {};

  @override
  void initState() {
    super.initState();
    _existingNames = widget.group.players.map((player) => player.name).toSet();
    if (widget.player == null) {
      _name = '';
      _abilities = {};
    } else {
      _name = widget.player?.name ?? '';
      _abilities = Map.from(widget.player?.abilities ?? {});
      _existingNames.remove(_name);
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = 'New Player';
    List<Widget> actions = [];
    if (widget.player != null) {
      title = 'Edit Player';
      actions = [
        IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => _removePlayer(context),
            tooltip: 'Delete Player'),
      ];
    }
    actions += [
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
          child: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => _handleSubmitted(context),
              tooltip: 'Save Player')),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);
    List<Widget> fields = [
      sizedBoxSpace,
      _nameInput(),
      sizedBoxSpace,
    ];
    for (final skill in widget.group.skills) {
      fields += _skillSlider(context, skill);
    }
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.values[_autoValidateModeIndex],
          child: Scrollbar(
            child: SingleChildScrollView(child: Column(children: fields)),
          ),
        ));
  }

  Widget _nameInput() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: TextFormField(
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            filled: false,
            //icon: Icon(Icons.person),
            hintText: 'What is their name?',
            labelText: 'Name*',
          ),
          initialValue: _name,
          onSaved: (value) {
            _name = (value == null) ? '' : value.toString();
          },
          validator: _validateName,
        ));
  }

  List<Widget> _skillSlider(BuildContext contex, Skill skill) {
    var value = _abilities[skill.id] ?? 5;
    return [
      Text(skill.name, style: Theme.of(context).textTheme.bodyText1),
      const SizedBox(height: 4),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SliderWidget(
              initialValue: value,
              fullWidth: true,
              min: 0,
              max: 10,
              onChanged: (double value) {
                setState(() {
                  _abilities[skill.id] = value;
                });
              })),
      const SizedBox(height: 16),
    ];
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

  void _handleSubmitted(BuildContext context) {
    final form = _formKey.currentState;
    final bool isValid = form?.validate() ?? false;
    if (!isValid) {
      _autoValidateModeIndex = AutovalidateMode.always.index;
    } else {
      form?.save();
      Player player =
          Player(id: widget.player?.id, name: _name, abilities: _abilities);
      Provider.of<AppState>(context, listen: false)
          .addOrUpdatePlayer(widget.group.id, player);
      Navigator.of(context).pop();
    }
  }

  void _removePlayer(BuildContext context) {
    Provider.of<AppState>(context, listen: false)
        .removePlayer(widget.group.id, widget.player?.id ?? '');
    Navigator.of(context).pop('delete');
  }
}
