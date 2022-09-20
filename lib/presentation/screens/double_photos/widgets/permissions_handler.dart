import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../utils/logging.dart';

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
