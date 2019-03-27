import 'package:flutter/material.dart';
import 'dart:math' show pow, sqrt;
import '../../components/misc/CustomCard.dart';
import '../../components/misc/LinearProgressBar.dart';
import '../../styles/theme.dart';

class _ShadowPainter extends CustomPainter {
  _ShadowPainter({
    this.paths,
  });

  final List<Path> paths;

  @override
  bool shouldRepaint(_ShadowPainter oldDelegate) {
    if(oldDelegate.paths != this.paths) return true;
    else return false;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    if(this.paths.length > 0) {
      Paint _shadowPaint = Paint()
        ..color = writingShadowColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = writingDrawPointIdleWidth;
      for(Path _path in this.paths)
        canvas.drawPath(_path, _shadowPaint);
    }
  }
}

class _CurrPathPainter extends CustomPainter {
  _CurrPathPainter({
    this.paths,
  });

  final List<Path> paths;

  @override
  bool shouldRepaint(_CurrPathPainter oldDelegate) {
    if(oldDelegate.paths != this.paths) return true;
    else return false;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    if(this.paths.length > 0) {
      Paint _pathPaint = Paint()
        ..color = writingDrawColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = writingDrawPointIdleWidth;
      for(Path _path in this.paths)
        canvas.drawPath(_path, _pathPaint);
    }
  }
}

class _CurrPointPainter extends CustomPainter {
  _CurrPointPainter({
    this.point,
    this.pointSize,
  });

  final Offset point;
  final double pointSize;

  @override
  bool shouldRepaint(_CurrPointPainter oldDelegate) {
    if(oldDelegate.point != this.point || oldDelegate.pointSize != this.pointSize) return true;
    else return false;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    if(this.point != null) {
      Paint _strokeStartPaint = Paint()
        ..color = writingGuideColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill;
      canvas.drawCircle(this.point, this.pointSize, _strokeStartPaint);
    }
  }
}

class _KulitanPainter extends CustomPainter {
  _KulitanPainter({
    this.path,
  });

  final Path path;

  @override
  bool shouldRepaint(_KulitanPainter oldDelegate) {
    if(oldDelegate.path != this.path) return true;
    else return false;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    if(this.path != null) {
      Paint _strokePaint = Paint()
        ..color = writingDrawColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = writingDrawPointIdleWidth;
      canvas.drawPath(this.path, _strokePaint);
    }
  }
}

class AnimatedWritingCard extends StatefulWidget {
  AnimatedWritingCard({
    @required this.kulitan,
    @required this.progress,
    @required this.cardNumber,
  });

  final String kulitan;
  final double progress;
  final int cardNumber;

  @override
  _AnimatedWritingCardState createState() => _AnimatedWritingCardState();
}

class _AnimatedWritingCardState extends State<AnimatedWritingCard> with SingleTickerProviderStateMixin {
  Offset _currPoint;
  Path _drawPath;
  List<Path> _prevDrawPaths = [];
  int _currPathNo = 0;
  int _currSubPathNo = 0;
  double _currBezierT = 0.0;
  List<Path> _shadowPaths = [];
  GlobalKey _canvasKey = GlobalKey();
  double _canvasWidth = 50.0;
  double _stepLength = 0.01;
  bool _hitTarget = false;
  var _cubicBezier;
  var _splitCubicBezier;
  bool _disableSwipe = true;

  AnimationController _pointController;
  CurvedAnimation _pointCurve;
  Tween<double> _pointTween;
  Animation<double> _pointAnimation;
  Curve _touchPointOpacityCurve = drawGuidesOpacityDownCurve;
  double _touchPointOpacity = 1.0;
  double _shadowOffset = 0.0;

  void _setCubicBezier(double x0, double y0, double x1, double y1, double x2, double y2, double x3, double y3) {
    x0 *= _canvasWidth;
    y0 *= _canvasWidth;
    x1 *= _canvasWidth;
    y1 *= _canvasWidth;
    x2 *= _canvasWidth;
    y2 *= _canvasWidth;
    x3 *= _canvasWidth;
    y3 *= _canvasWidth;
    setState(() {
      _cubicBezier = (double t) {
        double _getPoint(double z0, double z1, double z2, double z3) => (pow(1 - t, 3) * z0) + (3 * t * pow(1 - t, 2) * z1) + (3 * pow(t, 2) * (1 - t) * z2) + (pow(t, 3) * z3);
        return Offset(_getPoint(x0, x1, x2, x3), _getPoint(y0, y1, y2, y3));
      };
      _splitCubicBezier = (double t) {
        double _interp(double num1, double num2) => ((num1 - num2) * t) + num2;
        final double _x01 = _interp(x1, x0);
        final double _y01 = _interp(y1, y0);
        final double _x12 = _interp(x2, x1);
        final double _y12 = _interp(y2, y1);
        final double _x23 = _interp(x3, x2);
        final double _y23 = _interp(y3, y2);
        final double _x012 = _interp(_x12, _x01);
        final double _y012 = _interp(_y12, _y01);
        final double _x123 = _interp(_x23, _x12);
        final double _y123 = _interp(_y23, _y12);
        final double _x0123 = _interp(_x123, _x012);
        final double _y0123 = _interp(_y123, _y012);
        return {
          'p0': Offset(x0, y0),
          'a0': Offset(x1, y1),
          'a1': Offset(_x012, _y012),
          'p1': Offset(_x0123, _y0123),
        };
      };
    });
  }

  void _cardTouched(BuildContext context, Offset offset) {
    if(!_disableSwipe) {
      final RenderBox _box = context.findRenderObject();
      final Offset _localOffset = _box.globalToLocal(offset);
      final Offset _touchLoc = Offset(_localOffset.dx, _localOffset.dy - 20.0);
      if(_isWithinTouchArea(_touchLoc)){
        _animateTouchPoint();
        setState(() {
          _hitTarget = true;
        });
      }
    }
  }

  void _cardTouchEnded() {
    if(_hitTarget) {
      _animateTouchPoint(isScaleUp: false);
      setState(() {
        _hitTarget = false;
      });
    }
    if(_currBezierT == 1.0)
      getNextPath();
  }

  double _getPointsDist(Offset p1, Offset p2) => sqrt(pow(p2.dx - p1.dx, 2) + pow(p2.dy - p1.dy, 2));  

  bool _isWithinTouchArea(Offset p1) => writingCardTouchRadius >= _getPointsDist(_currPoint, p1);

  Future<Map<String, double>> _getNearestPointInCurve(Offset p1) async {  // optimize algorithm using sorting
    double _shortestDistance = double.infinity;
    double _shortestPoint;
    bool _evalDist(double i) {
      final double _dist = _getPointsDist(_cubicBezier(i), p1);
      if(_dist == _shortestDistance) {
        return false;
      } else {
        if(_dist < _shortestDistance) {
          _shortestDistance = _dist;
          _shortestPoint = i;
        }
        return true;
      }
    }
    for(double i = 0.0; i < 1.0; i += _stepLength)
      if(_evalDist(i) == false)
        return null;
    if(_evalDist(1) == false)
        return null;
    else
      return {
        'point': _shortestPoint,
        'distance': _shortestDistance,
      };
  }

  Offset _adjustAnchor0(Offset p0, Offset a0, double pathRatio) {
    final double _newDist = (_getPointsDist(p0, a0) * pathRatio);
    final double _slope = (a0.dy - p0.dy) / (a0.dx - p0.dx);
    if(_slope == 0) {
      return Offset(p0.dx + (a0.dx < p0.dx? -_newDist :_newDist), p0.dy);
    } else if(_slope.isNaN) {
      return Offset(p0.dx, p0.dy + (a0.dy < p0.dy? -_newDist : _newDist));
    } else {
      double _dx = _newDist / sqrt(1 + pow(_slope, 2));
      double _dy = _slope * _dx;
      if(_slope < 0)
        return Offset(p0.dx + _dx, p0.dy + _dy);
      else
        return Offset(p0.dx + (a0.dx < p0.dx? -_dx : _dx), p0.dy + (a0.dy < p0.dy? -_dy : _dy));
    }
  }

  bool _hasNextSubStroke() => _currSubPathNo + 6 < kulitanPaths[widget.kulitan][_currPathNo].length;

  void getNextPath() async {
    setState(() => _disableSwipe = true);
    final List<List<double>> _tempGlyph = kulitanPaths[widget.kulitan];
    if(_hasNextSubStroke()) {
      final List<double> _tempPath = _tempGlyph[_currPathNo];
      final int _prevSubPathNo = _currSubPathNo;
      setState(() => _currSubPathNo += 6);
      setState(() {
        _prevDrawPaths.add(Path()..moveTo(_tempPath[_prevSubPathNo - 2] * _canvasWidth, _tempPath[_prevSubPathNo - 1] * _canvasWidth)..cubicTo(_tempPath[_prevSubPathNo] * _canvasWidth, _tempPath[_prevSubPathNo + 1] * _canvasWidth, _tempPath[_prevSubPathNo + 2] * _canvasWidth, _tempPath[_prevSubPathNo + 3] * _canvasWidth, _tempPath[_prevSubPathNo + 4] * _canvasWidth, _tempPath[_prevSubPathNo + 5] * _canvasWidth));
        _currPoint = Offset(_tempPath[_currSubPathNo - 2] * _canvasWidth, _tempPath[_currSubPathNo - 1] * _canvasWidth);
        _currBezierT = 0.0;
        _disableSwipe = false;
      });
      _setCubicBezier(_tempPath[_currSubPathNo - 2], _tempPath[_currSubPathNo - 1], _tempPath[_currSubPathNo], _tempPath[_currSubPathNo + 1], _tempPath[_currSubPathNo + 2], _tempPath[_currSubPathNo + 3], _tempPath[_currSubPathNo + 4], _tempPath[_currSubPathNo + 5]);
    } else if(_currPathNo + 1 < _tempGlyph.length) {
      await Future.delayed(const Duration(milliseconds: nextDrawPathDelay));
      setState(() {
        _touchPointOpacityCurve = drawGuidesOpacityDownCurve;
        _touchPointOpacity = 0.0;
      });
      await Future.delayed(const Duration(milliseconds: drawGuidesOpacityChangeProgressUpdateDuration * 2));
      final List<double> _prevPath = _tempGlyph[_currPathNo];
      final List<double> _tempPath = _tempGlyph[_currPathNo + 1];
      _setCubicBezier(_tempPath[0], _tempPath[1], _tempPath[2], _tempPath[3], _tempPath[4], _tempPath[5], _tempPath[6], _tempPath[7]);
      setState(() {
        _prevDrawPaths.add(Path()..moveTo(_prevPath[0] * _canvasWidth, _prevPath[1] * _canvasWidth)..cubicTo(_prevPath[2] * _canvasWidth, _prevPath[3] * _canvasWidth, _prevPath[4] * _canvasWidth, _prevPath[5] * _canvasWidth, _prevPath[6] * _canvasWidth, _prevPath[7] * _canvasWidth));
        _currPoint = Offset(_tempPath[0] * _canvasWidth, _tempPath[1] * _canvasWidth);
        _currBezierT = 0.0;
        _currPathNo++;
        _currSubPathNo = 2;
        _touchPointOpacityCurve = drawGuidesOpacityDownCurve;
        _touchPointOpacity = 1.0;
        _disableSwipe = false;
      });
    } else {
      await Future.delayed(const Duration(milliseconds: drawShadowOffsetChangeDelay));
      setState(() => _shadowOffset = 0.03 * _canvasWidth);
      await Future.delayed(const Duration(milliseconds: drawShadowOffsetChangeDuration));
      setState((){
        _touchPointOpacityCurve = drawGuidesOpacityDownCurve;
        _touchPointOpacity = 0.0;
      });
      // TODO: hide guides
      // TODO: Update progressbar
    }
  }

  void _updateTouchOffset(BuildContext context, Offset offset) async {
    if(_hitTarget && !_disableSwipe) {
      final RenderBox _box = context.findRenderObject();
      final Offset _localOffset = _box.globalToLocal(offset);
      final Offset _touchLoc = Offset(_localOffset.dx, _localOffset.dy - 20.0);
      Map<String, double> _touchDetails = await _getNearestPointInCurve(_touchLoc);
      if(_touchDetails != null) {
        if(_isWithinTouchArea(_cubicBezier(_touchDetails['point'])) && _touchDetails['distance'] < writingCardTouchRadius && _touchDetails['point'] - _currBezierT < 0.5) {
          if(_touchDetails['point'] >= _currBezierT) {
            final Map<String, Offset> _points = _splitCubicBezier(_touchDetails['point']);
            final _anchor0 = _adjustAnchor0(_points['p0'], _points['a0'], _touchDetails['point']);
            setState(() {
              _drawPath = Path()..moveTo(_points['p0'].dx, _points['p0'].dy)..cubicTo(_anchor0.dx, _anchor0.dy, _points['a1'].dx, _points['a1'].dy, _points['p1'].dx, _points['p1'].dy);
              _currPoint = _points['p1'];
              _currBezierT = _touchDetails['point'];
            });
            if(_currBezierT == 1.0 && _hasNextSubStroke())
              getNextPath();
          }
        } else {
          _animateTouchPoint(isScaleUp: false);
          setState(() {
            _hitTarget = false;
          });
        }
      }
    }
  }

  void _getPaths() {
    final RenderBox _canvasBox = _canvasKey.currentContext.findRenderObject();
    final double _width = _canvasBox.size.width;
    setState(() => _canvasWidth = _width);
    List<Path> _manyPaths = [];
    List<List<double>> _thisKulitanPaths = kulitanPaths[widget.kulitan];
    for(List<double> _path in _thisKulitanPaths) {
      for(int i = 2; i < _path.length; i += 6)
        _manyPaths.add(Path()..moveTo(_path[i - 2] * _width, _path[i - 1] * _width)..cubicTo(_path[i] * _width, _path[i + 1] * _width, _path[i + 2] * _width, _path[i + 3] * _width, _path[i + 4] * _width, _path[i + 5] * _width));
    }

    List<double> _path = kulitanPaths[widget.kulitan][0];
    setState(() => _currPoint = Offset(_path[0] * _width, _path[1] * _width));
    _path = _thisKulitanPaths[0];
    _setCubicBezier(_path[0], _path[1], _path[2], _path[3], _path[4], _path[5], _path[6], _path[7]);

    setState(() {
      _shadowPaths = _manyPaths;
      _disableSwipe = false;
      _currSubPathNo = 2;
    });
  }

  void _animateTouchPoint({ bool isScaleUp: true }) {
    if(isScaleUp) {
      _pointCurve.curve = drawTouchPointScaleUpCurve;
      _pointController.forward();
    } else {
      _pointCurve.curve = drawTouchPointScaleDownCurve;
      _pointController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _pointController = AnimationController(duration: Duration(milliseconds: drawTouchPointScaleDuration), vsync: this);
    _pointCurve = CurvedAnimation(parent: _pointController, curve:drawTouchPointScaleUpCurve);
    _pointTween = Tween<double>(begin: writingDrawPointIdleWidth / 2, end: writingDrawPointTouchWidth / 2);
    _pointAnimation = _pointTween.animate(_pointCurve)
      ..addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _getPaths()); 
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.only(bottom: cardWritingVerticalPadding),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: AspectRatio(
              aspectRatio: 0.9248554913,
              child: Stack(
                fit:StackFit.expand,
                children: <Widget>[
                  AnimatedPositioned(
                    top: _shadowOffset,
                    left: _shadowOffset,
                    curve: drawShadowOffsetChangeCurve,
                    duration: const Duration(milliseconds: drawShadowOffsetChangeDuration),
                    child: CustomPaint(
                      painter: _ShadowPainter(
                        paths: _shadowPaths,
                      ),
                    ),
                  ),
                  CustomPaint(
                    key: _canvasKey,
                    painter: _CurrPathPainter(
                      paths: _prevDrawPaths,
                    ),
                  ),
                  CustomPaint(
                    painter: _KulitanPainter(
                      path: _drawPath,
                    ),
                  ),
                  AnimatedOpacity(
                    curve: _touchPointOpacityCurve,
                    opacity: _touchPointOpacity,
                    duration: const Duration(milliseconds: drawGuidesOpacityChangeProgressUpdateDuration),
                    child: CustomPaint(
                      painter:  _CurrPointPainter(
                        point: _currPoint,
                        pointSize: _pointAnimation.value,
                      ),
                      child: GestureDetector(
                        onPanDown: (DragDownDetails details) => _cardTouched(context, details.globalPosition),
                        onPanEnd: (_) => _cardTouchEnded(),
                        onPanCancel: () => _cardTouchEnded(),
                        onPanStart: (DragStartDetails details) => _updateTouchOffset(context, details.globalPosition),
                        onPanUpdate: (DragUpdateDetails details) => _updateTouchOffset(context, details.globalPosition),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: cardWritingHorizontalPadding,
              right: cardWritingHorizontalPadding,
            ),
            child: LinearProgressBar(
              progress: widget.progress,
            ),
          ),
        ],
      ),
    );
  }
}
