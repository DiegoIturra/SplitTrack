import 'package:flutter/material.dart';
import 'package:split_track/widgets/participant_input.dart';

class NewTrackScreen extends StatefulWidget {
  const NewTrackScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NewTrackScreenState();
}

class _NewTrackScreenState extends State<NewTrackScreen> {
  final List<TextEditingController> _controllers = [];
  final List<String> _avatars = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _addParticipant();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _addParticipant() {
    final focusNode = FocusNode();
    final textEditingController = TextEditingController();

    setState(() {
      _controllers.add(textEditingController);
      _focusNodes.add(focusNode);
      _avatars.add(_generateAvatar('user${_controllers.length}'));
    });

    Future.delayed(Duration.zero, () {
      focusNode.requestFocus();
    });
  }

  String _generateAvatar(String seed) {
    return 'https://api.dicebear.com/7.x/avataaars/png?seed=$seed';
  }

  void _finish(BuildContext context) {
    final participants = [];

    for (int i = 0; i < _controllers.length; i++) {
      final String name = _controllers[i].text.trim();

      if (name.isNotEmpty) {
        participants.add({'name': name, 'avatar': _avatars[i]});
      }
    }

    debugPrint(participants.toString());

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Track', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _controllers.length,
              itemBuilder: (context, index) {
                return ParticipantInput(
                  controller: _controllers[index],
                  avatarUrl: _avatars[index],
                  focusNode: _focusNodes[index],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addParticipant,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Agregar participante'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _finish(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Finish'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
