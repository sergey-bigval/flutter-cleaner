import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/contact.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/contacts_category_list.dart';
import 'package:hello_flutter/presentation/screens/double_photos/double_photos_screen.dart';
import 'package:hello_flutter/presentation/screens/double_photos/widgets/permissions_handler.dart';
import 'package:hello_flutter/presentation/screens/home_screen.dart';
import 'package:hello_flutter/presentation/screens/old_events/old_events_screen.dart';
import 'package:hello_flutter/presentation/screens/splash/splash_screen.dart';
import 'package:hello_flutter/presentation/screens/videos/big_videos_screen.dart';
import 'package:hello_flutter/utils/constants.dart';

import 'lifecycles/nav_observer.dart';

class FlutterCleanerApp extends StatelessWidget {
  FlutterCleanerApp({Key? key}) : super(key: key);

  final _observer = NavigatorObserverWithOrientation();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(canvasColor: Colors.grey),
      initialRoute: homeScreen,
      routes: {
        splashScreen: (context) => const SplashScreen(),
        homeScreen: (context) => const HomeScreen(),
        permScreen: (context) => const PermissionHandlerWidget(),
        bigVideosScreen: (context) => const BigVideosScreen(),
        oldEventsScreen: (context) => const OldEventsScreen(),
        doublePhotosScreen: (context) => const DoublePhotosScreen(),
        contactScreen: (context) => const Contact(),
        contactsInfo: (context) => const ContactsInfo(),
      },
      navigatorObservers: [_observer],
    );
  }
}
