import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_track/providers/track_list_provider.dart';
import 'package:split_track/routes/route_names.dart';
import 'package:split_track/screens/screens.dart';
import 'package:split_track/widgets/image_list_item.dart';

class TrackListScreen extends StatefulWidget {
  const TrackListScreen({super.key});
  
  @override
  State<StatefulWidget> createState() => _TrackListScreenState();
}

class _TrackListScreenState extends State<TrackListScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if(!mounted) return;
      context.read<TrackListProvider>().loadTracks();
    });
  }

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
                  return const Center(child: Text('No Tracks yet'));
                }

                return ListView.builder(
                  itemCount: provider.tracks.length,
                  itemBuilder: (context, index) {
                    final track = provider.tracks[index];

                    return Dismissible(
                      key: Key(track.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text("Confirmar"),
                            content: Text("¿Estás seguro de que quieres borrar el track '${track.name}'? Se borrarán todos sus gastos."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(dialogContext).pop(false), 
                                child: const Text("CANCELAR")
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(dialogContext).pop(true), 
                                child: const Text("BORRAR", style: TextStyle(color: Colors.red))
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) {
                        final String trackName = track.name;
                        context.read<TrackListProvider>().deleteTrack(track.id!);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("$trackName eliminado"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      child: ImageListItem(
                        title: track.name,
                        imageUrl:
                            "https://media.craiyon.com/2025-06-10/yfNVNakqS5urgb1GRB11ww.webp",
                        onTap: () async {
                          debugPrint("se selecciona el track con trackId = ${track.id}");
                          await Navigator.pushNamed(
                            context,
                            RouteNames.expenseList,
                            arguments: track.id
                          );
                        },
                      
                      )
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
