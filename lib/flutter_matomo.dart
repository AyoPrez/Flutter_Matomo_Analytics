import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class FlutterMatomo {

  static String _startingUrl;
  static bool _trackingState = false;

  static initializeTracker(String matomoUrl, String siteUrl, int siteId) {
    _startingUrl = matomoUrl + "?idsite="+ siteId.toString()+"&rec=1&url=" + siteUrl + "&set_image=0&";
  }

  static activateTracking(bool state){
    _trackingState = state;
  }

  static bool isTrackingActivated() {
    return _trackingState;
  }

  static trackEvent(BuildContext context, String eventCategory, int eventValue, String eventAction) {
    if(_trackingState) {
      var widgetName = context.widget.toStringShort();

      http.post(_startingUrl +
          "&action_name=TrackEvent " +
          "&e_c=" + eventCategory +
          "&e_v=" + eventValue.toString() +
          "&e_n=" + widgetName +
          "&e_a=" + eventAction);
    }
  }

  static trackEventWithName(String eventCategory, String eventName, int eventValue, String eventAction) {
    if(_trackingState) {
      http.post(_startingUrl +
          "&action_name=TrackEventWithName " +
          "&e_c=" + eventCategory +
          "&e_v=" + eventValue.toString() +
          "&e_n=" + eventName +
          "&e_a=" + eventAction);
    }
  }

  static trackEventWithCategory(String eventCategory, String eventName, String eventAction) {
    if(_trackingState) {
      http.post(_startingUrl +
          "&action_name=TrackEventWithCategory " +
          "&e_c=" + eventCategory +
          "&e_n=" + eventName +
          "&e_a=" + eventAction);
    }
  }

  static trackEventAction(String eventName, String eventAction) {
    if(_trackingState) {
      http.post(_startingUrl +
          "&action_name=TrackEventAction " +
          "&e_n=" + eventName +
          "&e_a=" + eventAction);
    }
  }

  static trackAction(String eventName, String action) {
    if(_trackingState) {
      http.post(_startingUrl +
          "&action_name=TrackAction " + action);
    }
  }

  static trackScreenEvent(BuildContext context, String eventName) {
    if(_trackingState) {
      var widgetName = context.widget.toStringShort();

      http.post(_startingUrl +
          "&action_name=TrackScreenEvent " +
          "&e_v=" + widgetName +
          "&e_n=" + eventName);
    }
  }

  static trackScreen(BuildContext context) {
    if(_trackingState) {
      var widgetName = context.widget.toStringShort();

      http.post(_startingUrl + "&action_name=TrackScreen " + widgetName);
    }
  }

  static trackScreenWithName(String screenName) {
    if(_trackingState) {
      http.post(_startingUrl +
          "&action_name=TrackScreenWithName " + screenName);
    }
  }

  static trackScreenWithNameEvent(String screenName, String eventName) {
    if(_trackingState) {
      http.post(_startingUrl +
          "&action_name=TrackScreenWithNameEvent " +
          "&e_n=" + screenName +
          "&e_v=" + eventName);
    }
  }

  static trackDownload(String downloadUrl) {
    if(_trackingState) {
      http.post(_startingUrl +
          "&action_name=TrackDownload " +
          "&download=" + downloadUrl);
    }
  }

  static trackGoal(int goalId) {
    if(_trackingState) {
      http.post(_startingUrl +
          "&action_name=TrackGoal " +
          "&idgoal=" + goalId.toString());
    }
  }

}

abstract class TraceableStatelessWidget extends StatelessWidget {
  final String name;
  final String title;

  TraceableStatelessWidget({this.name = '', this.title = 'WidgetCreated', Key key}) : super(key: key);

  @override
  StatelessElement createElement() {
    FlutterMatomo.trackScreenWithName(this.name.isEmpty ? this.runtimeType.toString() : this.name);
    return StatelessElement(this);
  }
}

abstract class TraceableStatefulWidget extends StatefulWidget {
  final String name;
  final String title;

  TraceableStatefulWidget({this.name = '', this.title = 'WidgetCreated', Key key}) : super(key: key);

  @override
  StatefulElement createElement() {
    FlutterMatomo.trackScreenWithName(this.name.isEmpty ? this.runtimeType.toString() : this.name);
    return StatefulElement(this);
  }
}

abstract class TraceableInheritedWidget extends InheritedWidget {
  final String name;
  final String title;

  TraceableInheritedWidget({this.name = '', this.title = 'WidgetCreated', Key key, Widget child}) : super(key: key, child: child);

  @override
  InheritedElement createElement() {
    FlutterMatomo.trackScreenWithName(this.name.isEmpty ? this.runtimeType.toString() : this.name);
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
