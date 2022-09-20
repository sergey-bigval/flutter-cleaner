import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/double_photos_bloc.dart';
import 'package:hello_flutter/presentation/screens/double_photos/bloc/events.dart';
import 'package:hello_flutter/presentation/screens/double_photos/widgets/filtering_info.dart';
import 'package:hello_flutter/presentation/screens/double_photos/widgets/photo_list.dart';

class DoublePhotosScreen extends StatefulWidget {
  const DoublePhotosScreen({super.key});

  @override
  State<DoublePhotosScreen> createState() => _DoublePhotosScreenState();
}

class _DoublePhotosScreenState extends State<DoublePhotosScreen> {
  late final DoublePhotosBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = DoublePhotosBloc();
    _bloc.add(DoublePhotosLoadPhotosEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const SizedBox(height: 5),
              ElevatedButton(
                  onPressed: () {
                    _bloc.add(DoublePhotosDeletePhotosEvent());
                  },
                  child: const Text("Delete")),
              const SizedBox(height: 10),
              FilteringInfo(bloc: _bloc),
              const SizedBox(height: 10),
              Expanded(child: PhotoList(bloc: _bloc)),
            ],
          ),
        ),
      ),
    );
  }
}
