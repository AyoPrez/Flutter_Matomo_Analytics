import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class FlutterMatomo {

  static String _startingUrl;

  static initializeTracker(String matomoUrl, String siteUrl, int siteId) {
    _startingUrl = matomoUrl + "?idsite="+ siteId.toString()+"&rec=1&url=" + siteUrl + "&set_image=0&";
  }

  static trackEvent(BuildContext context, String eventCategory, String eventValue, String eventAction) {
    var widgetName = context.widget.toStringShort();

    http.post(_startingUrl +
        "&action_name='TrackEvent'"+
        "&e_c="+eventCategory +
        "&e_n="+eventCategory +
        "&e_v="+eventValue +
        "&e_n="+widgetName +
        "&e_a="+eventAction);
  }

  static trackEventWithName(String eventCategory, String eventName, String eventValue, String eventAction) {
    http.post(_startingUrl +
        "&action_name='TrackEventWithName'"+
        "&e_c=" + eventCategory +
        "&e_n=" + eventCategory +
        "&e_v=" + eventValue +
        "&e_n=" + eventName +
        "&e_a=" + eventAction);
  }

  static trackScreen(BuildContext context, String eventName) {
    var widgetName = context.widget.toStringShort();

    http.post(_startingUrl +
        "&action_name='TrackScreen'"+
        "&e_v=" + widgetName +
        "&e_n=" + eventName);
  }

  static trackScreenWithName(String screenName, String eventName) {
    http.post(_startingUrl +
        "&action_name='TrackScreenWithName'"+
        "&e_n=" + screenName +
        "&e_v=" + eventName);
  }

  static trackDownload(String downloadUrl) {
    http.post(_startingUrl +
        "&action_name='TrackDownload'"+
        "&download=" + downloadUrl);
  }

  static trackGoal(int goalId) {
    http.post(_startingUrl +
        "&action_name='TrackGoal'"+
        "&idgoal=" + goalId.toString());
  }

}

abstract class TraceableStatelessWidget extends StatelessWidget {
  final String name;
  final String title;

  TraceableStatelessWidget({this.name = '', this.title = 'WidgetCreated', Key key}) : super(key: key);

  @override
  StatelessElement createElement() {
    FlutterMatomo.trackScreenWithName(this.name.isEmpty ? this.runtimeType.toString() : this.name, this.title);
    return StatelessElement(this);
  }
}

abstract class TraceableStatefulWidget extends StatefulWidget {
  final String name;
  final String title;

  TraceableStatefulWidget({this.name = '', this.title = 'WidgetCreated', Key key}) : super(key: key);

  @override
  StatefulElement createElement() {
    FlutterMatomo.trackScreenWithName(this.name.isEmpty ? this.runtimeType.toString() : this.name, this.title);
    return StatefulElement(this);
  }
}

abstract class TraceableInheritedWidget extends InheritedWidget {
  final String name;
  final String title;

  TraceableInheritedWidget({this.name = '', this.title = 'WidgetCreated', Key key, Widget child}) : super(key: key, child: child);

  @override
  InheritedElement createElement() {
    FlutterMatomo.trackScreenWithName(this.name.isEmpty ? this.runtimeType.toString() : this.name, this.title);
    return InheritedElement(this);
  }
}

abstract class TraceableState<T extends TraceableStatefulWidget> extends State {
  DateTime openedAt = DateTime.now();
  @override
  T get widget => super.widget;

  @override
  void dispose() {
    int secondsSpent = DateTime.now().difference(openedAt).inSeconds;
    super.dispose();
  }
}
