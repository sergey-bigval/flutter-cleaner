import 'package:flutter/material.dart';

class VisibilityWidget extends StatelessWidget {
  const VisibilityWidget({
    super.key,
    required this.notifier,
    required this.child,
  });//the same, nedawno poyavylos

  final ValueNotifier<bool> notifier;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: notifier,
        builder: (context, visible, _) {
          return Visibility(
            visible: visible,
            child: child);
        });
  }
}
