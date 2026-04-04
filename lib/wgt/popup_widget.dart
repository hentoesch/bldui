import 'package:flutter/material.dart';

class PopupWidget extends StatefulWidget {
  final Widget child;
  final double top;
  final double left;
  final Function handler;
  const PopupWidget(
      {required this.child,
      required this.handler,
      this.top = 100,
      this.left = 100,
      Key? key})
      : super(key: key);

  @override
  State<PopupWidget> createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  var _overlayController = OverlayPortalController();
  // @override
  // void didUpdateWidget(covariant PopupWidget oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  //   widget.handler(_overlayController);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _overlayController.show();
    //_overlayController.show();
    widget.handler(_overlayController);
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      overlayChildBuilder: (context) => Positioned(
          top: widget.top,
          left: widget.left,
          child: Center(
            child: widget.child,
          )),
      controller: _overlayController,
    );
  }
}
