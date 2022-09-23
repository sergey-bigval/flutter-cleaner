import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/double_photos_bloc.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/events.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/state.dart';
import 'package:hello_flutter/presentation/screens/double_photos/widgets/scanning_result.dart';
import 'package:hello_flutter/presentation/screens/double_photos/widgets/scanning_photos.dart';
import 'package:hello_flutter/presentation/screens/double_photos/widgets/warning_dialog.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/logging.dart';

class DoublePhotosScreen extends StatefulWidget {
  const DoublePhotosScreen({super.key});

  @override
  State<DoublePhotosScreen> createState() => _DoublePhotosScreenState();
}

class _DoublePhotosScreenState extends State<DoublePhotosScreen>
    with TickerProviderStateMixin {
  late final DoublePhotosBloc _bloc;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _bloc = DoublePhotosBloc();
    _bloc.add(DoublePhotosLoadPhotosEvent());

    _animController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Lottie.asset(
              'assets/lottie/background.json',
              controller: _animController,
              fit: BoxFit.cover,
              repeat: true,
              onLoaded: (composition) {
                _animController
                  ..duration = composition.duration
                  ..forward();
                _animController.repeat();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocConsumer<DoublePhotosBloc, DoublePhotosState>(
              bloc: _bloc,
              buildWhen: (previous, current) {
                return previous.isScanning != current.isScanning;
              },
              listener: (context, state) {
                if (!state.isScanning) {
                  _animController.stop();
                }
              },
              builder: (context, state) {
                return WillPopScope(
                  onWillPop: () async {
                    lol("BACK PRESS CLICKED");
                    if (state.isScanning) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const WarningDialog());
                    } else {
                      Navigator.pop(context);
                    }
                    return false;
                  },
                  child: state.isScanning
                      ? ScanningPhotos(bloc: _bloc)
                      : ScanningResult(bloc: _bloc),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
