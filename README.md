# flutter_matomo

Matomo tracking for flutter web

It has not been tested with Android or iOS. 
It uses http to make a request to the Matomo user's server.

## How to use 

#### Initialize Matomo/Piwik

```$xslt
FlutterMatomo.initializeTracker('https://YOUR_URL/matomo.php', 'https://MY_SITE/TRACKED', SITE_ID);
```
 
#### Adding a screen open event

If you have the BuildContext this will automatically add the widget name

```$xslt
FlutterMatomo.trackScreen(context, "Screen opened")
``` 

If not or you want to enter a custom name then use this 

```$xslt
FlutterMatomo.trackScreenWithName("SomeWidgetName", "Screen opened");
```

#### Extending out of the box TraceableWidgets

You can also use `TraceableStatefulWidget`, `TraceableStatelessWidget` & `TraceableInheritedWidget` Where you get a screen open event with the name of the widget out of the box

##### Example

Replace 
```$xslt
class HomeWidget extends StatefulWidget {
...
```
with this
```$xslt
class HomeWidget extends TraceableStatefulWidget {
...
```

Or you can override the tracking name of the widget by overriding the `name` attribute
```$xslt
class HomeWidget extends TraceableStatefulWidget {
  HomeWidget({Key key}) : super(key: key, name: 'ONLY_IF_YOU_WANT_TO_OVERRIDE_THE_WIDGET_NAME');

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}
```


#### Tracking an event

If you have the BuildContext this will automatically add the widget name

```$xslt
FlutterMatomo.trackEvent(context, "Test", "Sign up button", "Clicked");
``` 

If not or you want to enter a custom name then use this 

```$xslt
FlutterMatomo.trackEventWithName("SomeWidgetName", "Sign up button", "Clicked");
```



#### Track app download (ONLY ON ANDROID)

```$xslt
FlutterMatomo.trackDownload("https://DOWNLOADED_URL/");
``` 



#### Track goal with id (ONLY ON ANDROID)

```$xslt
FlutterMatomo.goal(GOAL_ID);
``` 



