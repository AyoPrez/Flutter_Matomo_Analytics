import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_matomo/flutter_matomo.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetTrackingBanner extends StatefulWidget {
  final String bannerText;
  final String readMoreButtonText;
  final String readMoreButtonLinkUrl;
  final String negativeButtonText;
  final Color negativeButtonColor;
  final String positiveButtonText;
  final Color positiveButtonColor;
  final bool displayTrackingBanner;
  final Function(bool) buttonPressed;

  const WidgetTrackingBanner({Key key,
    @required this.bannerText,
    this.readMoreButtonText,
    this.readMoreButtonLinkUrl,
    @required this.negativeButtonText,
    this.negativeButtonColor,
    @required this.positiveButtonText,
    this.positiveButtonColor,
    @required this.displayTrackingBanner,
    this.buttonPressed
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WidgetTrackingBannerState();
}

class _WidgetTrackingBannerState extends State<WidgetTrackingBanner> {

  bool displayBanner;

  @override
  void initState() {
    displayBanner = widget.displayTrackingBanner;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return displayBanner ? Container(
        width: MediaQuery.of(context).size.width,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black54)),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              spreadRadius: 1,
              blurRadius: 17,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),

        child: Stack(
          children: [
            Positioned(
              bottom: 2,
              top: 2,
              left: 0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Text(
                    _checkStringNullability(widget.bannerText) ? "" : widget.bannerText,
                    style: TextStyle(fontSize: 18),
                    maxLines: 3,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 2,
              top: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 20),
                  child: Row(
                    children: [
                      _checkStringNullability(widget.readMoreButtonLinkUrl) || _checkStringNullability(widget.readMoreButtonText) ?
                      Container() :
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                        child: FlatButton(
                            onPressed: () => _launchURL(),
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Text(widget.readMoreButtonText)
                        ),
                      ),
                      _button(context,
                          _checkStringNullability(widget.negativeButtonText) ? "No" : widget.negativeButtonText,
                          widget.negativeButtonColor != null
                          ? widget.negativeButtonColor
                          : Colors.red.shade300,
                              () => allowTracking(false)),
                      _button(context,
                          _checkStringNullability(widget.positiveButtonText) ? "Yes" : widget.positiveButtonText,
                          widget.positiveButtonColor != null
                          ? widget.positiveButtonColor
                          : Colors.green.shade300,
                          () => allowTracking(true)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )) : Container();
  }

  Widget _button(BuildContext context, String text, Color color, buttonClickListener()) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: DecoratedBox(
        decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(), color: color),
        child: Theme(
          data: Theme.of(context).copyWith(
              buttonTheme: ButtonTheme.of(context).copyWith(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap)),
          child: OutlineButton(
              onPressed: buttonClickListener,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Text(text)),
        ),
      ),
    );
  }

  bool _checkStringNullability(String string) {
    return string == null || string.isEmpty;
  }

  void _launchURL() async {
    final url = widget.readMoreButtonLinkUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showBanner() {
    setState(() {
      displayBanner = true;
    });
  }

  void allowTracking(bool allow) {
    widget.buttonPressed(allow);
    FlutterMatomo.activateTracking(allow);
    hideBanner();
  }

  void hideBanner() {
    setState(() {
      displayBanner = false;
    });
  }
}
