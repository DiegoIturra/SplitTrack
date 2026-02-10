import 'package:flutter/material.dart';
import 'package:split_track/models/track.dart';
import 'package:split_track/providers/db_provider.dart';

class TrackListProvider extends ChangeNotifier {
  final List<Track> _tracks = [];
  bool isLoading = false;

  List<Track> get tracks => _tracks;

  Future<void> loadTracks() async {
    isLoading = true;
    final data = await DbProvider.db.getAllTracks();

    _tracks
      ..clear()
      ..addAll(data);

    isLoading = false;
    notifyListeners();
  }

  Future<void> addTrack(Track track) async {
    await DbProvider.db.insertTrack(track);
    await loadTracks();
  }
}
