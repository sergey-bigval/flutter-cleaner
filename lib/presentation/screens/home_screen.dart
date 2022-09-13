import 'package:flutter/material.dart';
import 'package:hello_flutter/ads/AdBanner.dart';
import 'package:hello_flutter/presentation/screens/contacts/bloc/contacts_category_list.dart';
import 'device_info/device_info.dart';
import 'old_events/old_events.dart';
import 'videos/videos_screen.dart';
import 'doubles/duplicates_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController controller = PageController();
  String _title = "1 Function";
  final mainTextStyle = const TextStyle(
      decoration: TextDecoration.none,
      color: Colors.black54,
      fontSize: 33.0,
      letterSpacing: 6,
      fontFamily: "MouseMemoirs");

  _onPageViewChange(int page) {
    setState(() {
      _title = "${page + 1} Function";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Text(_title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: 33.0,
                      ))),
              Expanded(
                child: PageView(
                  controller: controller,
                  onPageChanged: _onPageViewChange,
                  children: const <Widget>[
                    OldCalendarEvents(),
                    DuplicatesScreen(),
                    MyVideosScreen(),
                    BatteryInfoPage(),
                    ContactsInfo(),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 4), child: BannerBlock()),
            ],
          ),
        ),
      ),
    );
  }
}
