import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../utils/constants.dart';
import '../utils/logging.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  final mainTextStyle = const TextStyle(
      decoration: TextDecoration.none,
      color: Colors.black54,
      fontSize: 33.0,
      letterSpacing: 6,
      fontFamily: "MouseMemoirs");

  @override
  void initState() {
    super.initState();
  }

  Future<void> getPhotos() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      // Granted.
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();
      paths.forEach((element) async {
        var range = await element.getAssetListRange(start: 0, end: 10);
        range.forEach((element) async {
          var fff = await element.originFile;
          lol(fff?.path ?? "NON");
        });
      });
    } else {
      // Limited(iOS) or Rejected, use `==` for more precise judgements.
      // You can call `PhotoManager.openSetting()` to open settings for further steps.
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();
      paths.forEach((element) async {
        var range = await element.getAssetListRange(start: 0, end: 10);
        range.forEach((element) async {
          var fff = await element.originFile;
          lol(fff?.path ?? "NON");
        });
      });
      lol('here 1');
      Navigator.pushNamed(context, permScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100, height: 40,
      child: Scaffold(
        body: Align(
            alignment: const Alignment(0, 0),
            child: InkWell(
              onTap: () {
                getPhotos();
              },
              onLongPress: (){
                Navigator.pushNamed(context, permScreen);
              },
              child: Text('Press \n or \n LongPress \n me', textAlign: TextAlign.center, style: mainTextStyle),
            )),
      ),
    );
  }
}

/// A Flutter application demonstrating the functionality of this plugin
class PermissionHandlerWidget extends StatefulWidget {
  const PermissionHandlerWidget({Key? key}) : super(key: key);

  /// Create a page containing the functionality of this plugin
  // static ExamplePage createPage() {
  //   return ExamplePage(
  //       Icons.location_on, (context) => const PermissionHandlerWidget());
  // }

  @override
  _PermissionHandlerWidgetState createState() => _PermissionHandlerWidgetState();
}

class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
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
                .map((permission) => PermissionWidget(permission))
                .toList()),
      ),
    );
  }
}

/// Permission widget containing information about the passed [Permission]
class PermissionWidget extends StatefulWidget {
  /// Constructs a [PermissionWidget] for the supplied [Permission]
  const PermissionWidget(this._permission);

  final Permission _permission;

  @override
  _PermissionState createState() => _PermissionState(_permission);
}

class _PermissionState extends State<PermissionWidget> {
  _PermissionState(this._permission);

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
      title: Text(
        _permission.toString(),
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: Text(
        _permissionStatus.toString(),
        style: TextStyle(color: getPermissionColor()),
      ),
      trailing: (_permission is PermissionWithService)
          ? IconButton(
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text((await permission.serviceStatus).toString()),
    ));
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }
}
