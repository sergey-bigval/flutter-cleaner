import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyWidget extends StatelessWidget {
  const PolicyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Center(
          child: DefaultTextStyle(
            style: const TextStyle(),
            child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                    text:
                    'By proceeding, you confirm that you have read and acknowledged ',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontFamily: "CustomIcons.ttf",
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse(urlPolicy));
                            }),
                      TextSpan(
                          text: ' and ',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Terms of Service',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blueAccent,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(Uri.parse(urlTerms));
                                  }),
                          ]),
                    ])),

          )),
    );
  }
}