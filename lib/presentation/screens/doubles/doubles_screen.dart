import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/doubles/bloc/photos_filter_logic.dart';
import 'package:hello_flutter/themes/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/logging.dart';

class PhotoModel {
  PhotoModel({
    required this.absolutePath,
    required this.size,
    required this.timeInSeconds,
    required this.isSelected,
  });

  String absolutePath;
  int size;
  int timeInSeconds;
  bool isSelected = false;
  ValueNotifier<bool> isSelectedVN = ValueNotifier(false);
}

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {

  var _photosCount = 0;
  var _videoCount = 0;
  final List<AssetEntity> _allPhotosEntities = [];
  final List<PhotoModel> _allPhotos = [];
  final List<PhotoModel> _plainDoubles = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var img = Image.file(
      File('/storage/emulated/0/Download/test.jpg'),
      width: 100,
      height: 100,
      fit: BoxFit.fill,
    );

    return Scaffold(
      body: Column(children: [
        Container(
          color: Colors.red,
          child: SizedBox(
            width: 300,
            height: 50,
            child: Align(
                alignment: const Alignment(0, 0),
                child: InkWell(
                  onTap: () {
                    // loadPhotos();
                  },
                  onLongPress: () {
                    Navigator.pushNamed(context, permScreen);
                  },
                  child: const Text(
                      'Press or LongPress',
                      textAlign: TextAlign.center,
                      style: Styles.titleStyle,
                  ),
                )),
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _plainDoubles.length, // для билдера
            itemBuilder: (BuildContext context, int index) {
              // для билдера
              return Dismissible(
                key: Key(_plainDoubles[index].hashCode.toString()),
                child: Card(
                    color: Colors.red[100],
                    elevation: index.toDouble(),
                    shadowColor: Colors.blue,
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: Image.file(
                        File(_plainDoubles[index].absolutePath),
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    )),
              );
            },
          ),
        )
      ]),
    );
  }
}

class PermissionHandlerWidget extends StatefulWidget {
  const PermissionHandlerWidget({Key? key}) : super(key: key);

  @override
  PermissionHandlerWidgetState createState() => PermissionHandlerWidgetState();
}

class PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  @override
  Widget build(BuildContext context) {
    lol('here 2 build');
    return Scaffold(
      body: Center(
        child: ListView(
            children: Permission.values
                .where((permission) {
                  if (Platform.isIOS) {
                    return permission != Permission.unknown &&
                        permission != Permission.sms &&
                        permission != Permission.storage &&
                        permission != Permission.ignoreBatteryOptimizations &&
                        permission != Permission.accessMediaLocation &&
                        permission != Permission.activityRecognition &&
                        permission != Permission.manageExternalStorage &&
                        permission != Permission.systemAlertWindow &&
                        permission != Permission.requestInstallPackages &&
                        permission != Permission.accessNotificationPolicy &&
                        permission != Permission.bluetoothScan &&
                        permission != Permission.bluetoothAdvertise &&
                        permission != Permission.bluetoothConnect;
                  } else {
                    return permission != Permission.unknown &&
                        permission != Permission.mediaLibrary &&
                        permission != Permission.photos &&
                        permission != Permission.photosAddOnly &&
                        permission != Permission.reminders &&
                        permission != Permission.appTrackingTransparency &&
                        permission != Permission.criticalAlerts;
                  }
                })
                .map((permission) => PermissionItemWidget(permission))
                .toList()),
      ),
    );
  }
}

/// Permission widget containing information about the passed [Permission]
class PermissionItemWidget extends StatefulWidget {
  const PermissionItemWidget(this._permission);

  final Permission _permission;

  @override
  PermissionItemState createState() => PermissionItemState(_permission);
}

class PermissionItemState extends State<PermissionItemWidget> {
  PermissionItemState(this._permission);

  final Permission _permission;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.limited:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_permission.toString(), style: Theme.of(context).textTheme.bodyText1),
      subtitle: Text(_permissionStatus.toString(), style: TextStyle(color: getPermissionColor())),
      trailing: (_permission is PermissionWithService)
          ? IconButton(
              icon: const Icon(Icons.info, color: Colors.white),
              onPressed: () {
                checkServiceStatus(context, _permission as PermissionWithService);
              })
          : null,
      onTap: () {
        requestPermission(_permission);
      },
    );
  }

  void checkServiceStatus(BuildContext context, PermissionWithService permission) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text((await permission.serviceStatus).toString())));
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      _permissionStatus = status;
    });
  }
}
