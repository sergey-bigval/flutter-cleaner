import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/doubles/widgets/duplicate_button.dart';
import 'package:hello_flutter/presentation/screens/doubles/widgets/filtering_info.dart';
import 'package:hello_flutter/presentation/screens/doubles/widgets/photo_list.dart';

import 'bloc/photos_filter_logic.dart';

class DuplicatesScreen extends StatelessWidget {
  const DuplicatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 10),
            Center(child: DuplicateButton()),
            SizedBox(height: 5),
            InkWell(
              onTap: () {
                PhotosFilerLogic.deletePhotos();
              },
              child: Center(
                  child: SizedBox(
                width: 100,
                height: 50,
                child: Center(child: Text("Delete")),
              )),
            ),
            SizedBox(height: 10),
            FilteringInfo(),
            SizedBox(height: 10),
            Expanded(child: PhotoList()),
          ],
        ),
      ),
    );
  }
}
