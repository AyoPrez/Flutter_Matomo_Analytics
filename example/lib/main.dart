import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_matomo/flutter_matomo.dart';
import 'package:flutter_matomo/widget_tracking_banner.dart';

void main() => runApp(MyApp());

const MATOMO_URL = 'https://analytics.example.com/matomo.php';
const SITE_ID = 1;
const SITE_URL = "https://example.site.com/";

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _matomoStatus = 'Starting ...';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    FlutterMatomo.initializeTracker(MATOMO_URL, SITE_URL, SITE_ID);
    setState(() {});

    FlutterMatomo.trackEvent(context, "Tests", 1, "Testing in app");
    _matomoStatus = "Passed track event";

    FlutterMatomo.trackScreenEvent(context, "Screen opened");
    _matomoStatus = "Passed track screen";

    FlutterMatomo.trackEventWithName("This uses a name MyAppWidget", "LOGIIIN button", 0, "Clicked");
    _matomoStatus = "Passed track event with name";

    FlutterMatomo.trackDownload("https://example.download.com");
    _matomoStatus = "Passed track download";

    FlutterMatomo.trackGoal(1);
    _matomoStatus = "Passed track goal";


    _matomoStatus = "Passed all trackers";

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(_matomoStatus, textAlign: TextAlign.center),
              ),
            ),
            Positioned(bottom: 0, child: WidgetTrackingBanner(
              readMoreButtonText: "Read more",
              negativeButtonText: "No",
              positiveButtonText: "Yes",
              readMoreButtonLinkUrl: "https://example.com",
              bannerText: "Do you allow this site to use cookies to track all your movements in the site?",
              displayTrackingBanner: true,
              buttonPressed: (value) {
                print("Button pressed value: " + value.toString());
              },
            ))
          ],
        ),
      ),
    );
  }
}
