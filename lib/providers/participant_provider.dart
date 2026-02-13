import 'package:flutter/material.dart';
import 'package:split_track/models/participant.dart';
import 'package:split_track/providers/db_provider.dart';

class ParticipantProvider extends ChangeNotifier {
  bool isLoading = false;
  final int trackId;
  final List<Participant> _participants = [];

  ParticipantProvider({
    required this.trackId
  });

  List<Participant> get participants => _participants;

  Future<void> loadParticipants() async {
    if(isLoading) return;
    isLoading = true;
    notifyListeners();

    final data = await DbProvider.db.getAllParticipants(trackId);

    _participants..clear()..addAll(data);

    isLoading = false;
    notifyListeners();
  }
}