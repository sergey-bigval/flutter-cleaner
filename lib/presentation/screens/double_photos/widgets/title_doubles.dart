import 'package:flutter/material.dart';

import '../../../../themes/styles.dart';

class DoublePhotosTitle extends StatelessWidget {
  const DoublePhotosTitle(
    this.title, {
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Styles.textWhiteBold20,
            ),
            const SizedBox(),
          ],
        ));
  }
}
