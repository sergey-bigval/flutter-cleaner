import 'package:flutter/material.dart';
import 'package:hello_flutter/ads/AdBanner.dart';

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
      child: Container(
        color: Colors.pink[200],
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
                children: <Widget>[
                  Align(
                      alignment: const Alignment(0, 0),
                      child: Text(
                          'The first functionality of the new super cleaner written in Flutter \n\n\n <<<- SWIPE ->>>',
                          textAlign: TextAlign.center,
                          style: mainTextStyle)),
                  Align(
                    alignment: const Alignment(0, 0),
                    child: Text('Second functionality of the new super cleaner written in Flutter',
                        textAlign: TextAlign.center, style: mainTextStyle),
                  ),
                  Align(
                      alignment: const Alignment(0, 0),
                      child: Text('Third functionality of the new super cleaner written in Flutter',
                          textAlign: TextAlign.center, style: mainTextStyle))
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 4), child: BannerBlock()),
          ],
        ),
      ),
    );
  }
}
