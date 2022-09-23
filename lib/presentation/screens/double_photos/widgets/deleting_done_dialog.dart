import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/constants.dart';
import 'package:lottie/lottie.dart';

class DeletingDoneDialog extends StatefulWidget {
  const DeletingDoneDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<DeletingDoneDialog> createState() => _DeletingDoneDialogState();
}

class _DeletingDoneDialogState extends State<DeletingDoneDialog>
    with TickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this);
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.popUntil(context, ModalRoute.withName(homeScreen));
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      //this right here
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Lottie.asset(
          'assets/lottie/deleting_done.json',
          fit: BoxFit.cover,
          repeat: false,
          onLoaded: (composition) {
            _animController
              ..duration = composition.duration
              ..forward();
          },
        ),
      ]),
    );
  }
}
