import 'package:flutter/material.dart';
import 'package:split_track/widgets/image_list_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SplitTrack",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("SplitTracks"),
          backgroundColor: Colors.indigo,
        ),
        body: Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: 10,
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

            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint('Botón presionado');
                  },
                  child: const Text('Botón inferior'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
