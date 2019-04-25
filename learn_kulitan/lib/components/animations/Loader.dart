import 'package:flutter/material.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import '../../styles/theme.dart';

class Loader extends StatefulWidget {
  const Loader({
    @required this.isVisible,
    @required this.child,
  });

  final bool isVisible;
  final Widget child;

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with FlareController {
  OverlayEntry _overlay;
  double _animationTime = 0.0;

  @override
  void initState() {
    super.initState();
    _overlay = _createLoader();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Overlay.of(context).insert(_overlay),
    );
  }

  @override
  void initialize(FlutterActorArtboard artboard) {}

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _animationTime += elapsed / 2;
    if (_animationTime >= 3.5167) {
      _overlay?.remove();
      setState(() => _overlay = null);
    }
    return true;
  }

  OverlayEntry _createLoader() {
    return OverlayEntry(
      builder: (context) {
        return Align(
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(top: 5.0, left: 5.0),
                  constraints: BoxConstraints(minWidth: 175.0),
                  width: MediaQuery.of(context).size.width * loaderWidthPercent,
                  child: FlareActor(
                    'assets/flares/loader.flr',
                    animation: 'load',
                    color: loaderStrokeShadowColor,
                    controller: this,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: BoxConstraints(minWidth: 175.0),
                  width: MediaQuery.of(context).size.width * loaderWidthPercent,
                  child: FlareActor(
                    'assets/flares/loader.flr',
                    animation: 'load',
                    color: loaderStrokeColor,
                    controller: this,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _overlay?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        IgnorePointer(
          child: AnimatedOpacity(
            opacity: _overlay == null ? 0.0 : 1.0,
            duration: const Duration(milliseconds: loaderOpacityDuration),
            curve: loaderOpacityCurve,
            child: Container(color: loaderBackgroundColor),
          ),
        ),
      ],
    );
  }
}