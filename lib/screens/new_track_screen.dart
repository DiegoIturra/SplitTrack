import 'package:flutter/material.dart';
import 'package:split_track/models/track_model.dart';
import 'package:split_track/providers/db_provider.dart';
import 'package:split_track/widgets/participant_input.dart';

class NewTrackScreen extends StatefulWidget {
  const NewTrackScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NewTrackScreenState();
}

class _NewTrackScreenState extends State<NewTrackScreen> {
  final TextEditingController trackNameController = TextEditingController();
  final String trackBackgroundUrl =
      'https://mir-s3-cdn-cf.behance.net/project_modules/max_632/c0922f19537399.562e975f2a2f1.gif';
  final FocusNode trackNameFocusNode = FocusNode();

  final List<TextEditingController> _controllers = [];
  final List<String> _avatars = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();

    _addParticipant(requestFocus: false);

    Future.delayed(Duration.zero, () {
      trackNameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    trackNameController.dispose();
    trackNameFocusNode.dispose();

    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _addParticipant({bool requestFocus = false}) {
    final focusNode = FocusNode();
    final textEditingController = TextEditingController();

    setState(() {
      _controllers.add(textEditingController);
      _focusNodes.add(focusNode);
      _avatars.add(_generateAvatar('user${_controllers.length}'));
    });

    if (requestFocus) {
      Future.delayed(Duration.zero, () {
        focusNode.requestFocus();
      });
    }
  }

  String _generateAvatar(String seed) {
    return 'https://api.dicebear.com/7.x/avataaars/png?seed=$seed';
  }

  void _finish(BuildContext context) async {
    final trackName = trackNameController.text.trim();
    final participants = <Map<String, dynamic>>[];

    if (trackName.isEmpty) return;

    for (int i = 0; i < _controllers.length; i++) {
      final String name = _controllers[i].text.trim();

      if (name.isNotEmpty) {
        participants.add({'name': name, 'avatar': _avatars[i]});
      }
    }

    final track = Track(
      name: trackName,
      participants: participants,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    final id = await DbProvider.db.insertTrack(track);

    debugPrint('Track $id has been saved');

    if (!mounted) return;

    // ignore: use_build_context_synchronously
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: trackNameController,
              focusNode: trackNameFocusNode,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                if (_focusNodes.isNotEmpty) {
                  _focusNodes.first.requestFocus();
                }
              },
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre del Track',
                hintText: 'Ej: Vacaciones',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  trackBackgroundUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.image_not_supported),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

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
