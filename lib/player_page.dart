import 'package:flutter/material.dart';

import 'package:fairteams/model.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage(
      {Key? key, required this.group, required this.player, this.mode = 'new'})
      : super(key: key);

  final Group group;
  final Player player;
  final String mode;

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _autoValidateModeIndex = AutovalidateMode.disabled.index;
  Set<String> validNames = {};

  @override
  Widget build(BuildContext context) {
    String title = 'New Player';
    List<Widget> actions = [];
    validNames = {};
    if (widget.mode == 'edit') {
      title = 'Edit Player';
      actions = [
        IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _removePlayer,
            tooltip: 'New Player'),
      ];
      validNames = {widget.player.name};
    }
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
    for (final skillName in widget.group.skillNames) {
      fields += _skillSlider(context, skillName);
      fields += [sizedBoxSpace];
    }
    fields += [
      _submitButton(context),
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
      initialValue: (widget.player.name == '') ? null : widget.player.name,
      onSaved: (value) {
        widget.player.name = (value == null) ? '' : value.toString();
      },
      validator: _validateName,
    );
  }

  List<Widget> _skillSlider(BuildContext contex, String skillName) {
    var value = widget.player.skills[skillName] ?? 5;
    return [
      Text(skillName, style: Theme.of(context).textTheme.bodyText1),
      Slider(
        value: value,
        min: 0,
        max: 10,
        divisions: 10,
        label: value.round().toString(),
        activeColor: widget.player.skillColor(value),
        onChanged: (double value) {
          setState(() {
            widget.player.skills[skillName] = value;
          });
        },
      ),
    ];
  }

  Widget _submitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _handleSubmitted(context),
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
    Set<String> existing =
        widget.group.players.map((player) => player.name).toSet();
    existing = existing.difference(validNames);
    if (existing.contains(value)) {
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
      Navigator.of(context).pop(widget.player);
    }
  }

  void _removePlayer() {
    // Hidous way of letting caller know to delete
    Navigator.of(context).pop(Player(name: 'DELETE'));
  }
}
