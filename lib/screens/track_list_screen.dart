import 'package:flutter/material.dart';
import 'package:split_track/widgets/image_list_item.dart';

class TrackListScreen extends StatelessWidget {
  const TrackListScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SplitTrack",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "SplitTracks",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ImageListItem(
                    title: "Item $index",
                    imageUrl:
                        "https://media.craiyon.com/2025-06-10/yfNVNakqS5urgb1GRB11ww.webp",
                    onTap: () {
                      debugPrint('Item $index presionado');
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
                  onPressed: () => debugPrint('Botón presionado'),
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
      ),
    );
  }
}
