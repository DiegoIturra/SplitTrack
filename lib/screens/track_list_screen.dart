import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_track/providers/track_list_provider.dart';
import 'package:split_track/screens/edit_track.dart';
import 'package:split_track/screens/screens.dart';
import 'package:split_track/widgets/image_list_item.dart';

class TrackListScreen extends StatelessWidget {
  const TrackListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SplitTracks", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<TrackListProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.tracks.isEmpty) {
                  provider.loadTracks();
                  return const Center(child: Text('No Tracks yet'));
                }
                return ListView.builder(
                  itemCount: provider.tracks.length,
                  itemBuilder: (context, index) {
                    final track = provider.tracks[index];
                    return ImageListItem(
                      title: track.name,
                      imageUrl:
                          "https://media.craiyon.com/2025-06-10/yfNVNakqS5urgb1GRB11ww.webp",
                      onTap: () async {
                        debugPrint('Track ${track.name} selected');

                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditTrackScreen()),
                        );
                      },
                    
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NewTrackScreen()),
                  );

                  if (!context.mounted) return;
                  context.read<TrackListProvider>().loadTracks();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.indigo),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                ),
                child: const Text("Add New Track"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
