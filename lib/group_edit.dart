import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fairteams/model.dart';
import 'package:fairteams/state.dart';

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
  List<Player> _players = [];

  @override
  void initState() {
    super.initState();
    if (widget.group == null) {
      _name = '';
      _sport = 'football';
    } else {
      _name = widget.group?.name ?? '';
      _sport = widget.group?.sport ?? '';
      _players = widget.group?.players ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.group == null) ? 'New Group' : 'Edit Group'),
        actions: [
          IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => _handleSubmitted(context),
              tooltip: 'Save Group'),
        ],
      ),
      body: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.values[_autoValidateModeIndex],
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              sizedBoxSpace,
              _nameInput(),
              sizedBoxSpace,
              _sportInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nameInput() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: TextFormField(
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            filled: false,
            icon: Icon(Icons.group),
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
            icon: Group(sport: _sport).icon(),
            labelText: 'Sport',
          ),
          items: <String>['Basketball', 'Football']
              .map((String value) => DropdownMenuItem(
                    value: value.toLowerCase(),
                    child: Text(value),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() => _sport = value.toString());
          },
          onSaved: (value) {
            setState(() => _sport = value.toString());
          },
        ));
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
          id: widget.group?.id, name: _name, sport: _sport, players: _players);
      if (_sport == 'football') {
        group.skillNames = ['Defence', 'Attack', 'Savvy', 'Fitness'];
      }
      form?.save();
      Provider.of<AppState>(context, listen: false).addOrUpdateGroup(group);
      Navigator.of(context).pop();
    }
  }
}
