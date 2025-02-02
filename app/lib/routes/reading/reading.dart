import 'package:flutter/material.dart';
import 'dart:async';
import '../../styles/theme.dart';
import '../../components/buttons/CustomButton.dart';
import '../../components/buttons/RoundedBackButton.dart';
import '../../components/buttons/TextButton.dart';
import '../../components/buttons/CustomSwitch.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/CircularProgressBar.dart';
import '../../components/misc/LinearProgressBar.dart';
import '../../components/misc/GameLogicManager.dart';
import '../../db/GameData.dart';
import './components.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage();
  @override
  ReadingPageState createState() => ReadingPageState();
}

class ReadingPageState extends State<ReadingPage> {
  static final GameData _gameData = GameData();
  final GameLogicManager _gameLogicManager = GameLogicManager();
  final _tutorialKey1 = GlobalKey();
  final _tutorialKey2 = GlobalKey();
  final _tutorialKey3 = GlobalKey();
  final _tutorialKey4 = GlobalKey();
  final _tutorialKey5 = GlobalKey();
  CustomButtonGroup _buttonGroup;
  int _tutorialNo = 0;
  bool _isTutorial = true;
  int _overallProgressCount = 0;
  Size _screenSize;
  List<Map<String, dynamic>> _cards = [
    {
      'kulitan': 'pie',
      'answer': 'pí',
      'progress': 0,
      'stackNumber': 1,
    },
    {
      'kulitan': 'du',
      'answer': 'du',
      'progress': 0,
      'stackNumber': 2,
    },
    {
      'kulitan': 'No',
      'answer': 'ngo',
      'progress': 0,
      'stackNumber': 3,
    }
  ];
  List<Map<String, dynamic>> _choices = [
    {
      'text': 'pí',
      'type': ChoiceButton.right,
      'onTap': null,
    },
    {
      'text': 'da',
      'type': ChoiceButton.wrong,
      'onTap': null,
    },
    {
      'text': 'ko',
      'type': ChoiceButton.wrong,
      'onTap': null,
    },
    {
      'text': 'su',
      'type': ChoiceButton.wrong,
      'onTap': null,
    },
  ];

  bool _disableChoices = false;

  GlobalKey _pageKey = GlobalKey();
  GlobalKey _quizCardsKey = GlobalKey();
  double _quizCardWidth = 100.0;
  double _heightToQuizCardTop = 200.0;
  double _quizCardStackHeight = 100.0;
  double _heightToCardStackBottom = 500.0;
  bool _updatedHeights = false;
  bool _kulitanSwitch = true;
  bool _isKulitan = true;
  bool _disableSwitch = false;
  bool _disableSwipe = false;
  List<bool> _disableButtons = [false, false, false, false];

  final _resetChoicesController = StreamController.broadcast();
  final _showAnswerChoiceController = StreamController.broadcast();
  final _flipStreamController = StreamController<bool>.broadcast();

  get cards => _cards;
  get choices => _choices;
  get overallProgressCount => _overallProgressCount;
  get mode => _isKulitan;
  get modeChanged => _kulitanSwitch != _isKulitan;

  set overallProgressCount(int n) => setState(() => _overallProgressCount = n);
  set choices(List<Map<String, dynamic>> choices) => setState(() => _choices = choices);
  set disableSwipe(bool i) => setState(() => _disableSwipe = i);
  set disableChoices(bool i) => setState(() => _disableChoices = i);
  set isTutorial(bool i) => setState(() => _isTutorial = i);
  set tutorialNo(int i) => setState(() => _tutorialNo = i);
  set mode(bool i) => setState(() { _kulitanSwitch = i; _isKulitan = i; });
  void changeMode() => setState(() => _isKulitan = _kulitanSwitch);
  void setCard(Map<String, dynamic> card, int i) => setState(() => _cards[i] = card);
  void setChoice(Map<String, dynamic> choice, int i) => setState(() => _choices[i] = choice);
  void shuffleChoices() => setState(() => _choices.shuffle());
  void flipCard() => _flipStreamController.sink.add(true);
  void unflipCard() => _flipStreamController.sink.add(false);
  void showAnswer() => _showAnswerChoiceController.sink.add(null);
  void resetChoices() => _resetChoicesController.sink.add(null);
  void incOverallProgressCount() => setState(() => _overallProgressCount++);
  void decOverallProgressCount() => setState(() => _overallProgressCount--);
  void incCurrCardProgress() => setState(() => _cards[0]['progress']++);
  void decCurrCardProgress() => setState(() => _cards[0]['progress']--);
  void enableAllChoices() => setState(() {
    _disableButtons = [false, false, false, false];
    _disableChoices = false;
  });
  void disableWrongChoices(String answer) => setState(() {
    _disableChoices = false;
    _disableButtons[0] = _choices[0]['text'] == answer ? false : true;
    _disableButtons[1] = _choices[1]['text'] == answer ? false : true;
    _disableButtons[2] = _choices[2]['text'] == answer ? false : true;
    _disableButtons[3] = _choices[3]['text'] == answer ? false : true;
  });
  void disableCorrectChoice(String answer) => setState(() {
    _disableChoices = false;
    _disableButtons[0] = _choices[0]['text'] == answer ? true : false;
    _disableButtons[1] = _choices[1]['text'] == answer ? true : false;
    _disableButtons[2] = _choices[2]['text'] == answer ? true : false;
    _disableButtons[3] = _choices[3]['text'] == answer ? true : false;
  });

  void _swipingCard() {
    setState(() {
      _disableSwitch = true;
      _disableChoices = true;
    });
  }

  void _swipingCardDone() {
    setState(() {
      _disableSwitch = false;
      if (!_isTutorial) _disableChoices = false;
    });
  }

  void startGame() => _gameLogicManager.init(this);

  @override
  void initState() {
    super.initState();
    _buttonGroup = CustomButtonGroup(
      onTapDown: () => setState(() => _disableSwipe = true),
      onTapUp: () {
        if(!_isTutorial) setState(() => _disableSwipe = false);
      },
    );
    startGame();
  }

  @override
  void dispose() {
    _resetChoicesController.close();
    _showAnswerChoiceController.close();
    _flipStreamController.close();
    super.dispose();
  }

  void _getQuizCardsSize() {
    final RenderBox _screenBox = _pageKey.currentContext.findRenderObject();
    final RenderBox _cardBox = _quizCardsKey.currentContext.findRenderObject();
    final double _aspectRatio = _screenSize.aspectRatio;
    final double _padMultiplier = _aspectRatio > smallMaxAspect && _screenSize.height <= smallHeight
      ? (_aspectRatio * 2.0)
      : _aspectRatio > mediumMaxAspect
        ? ((_aspectRatio / 0.75) * 4.0)
        : 1.0;
    final double _horizontalPadding = quizHorizontalScreenPadding * _padMultiplier * 2.0;
    double _cardWidth = _cardBox.size.width - _horizontalPadding;

    final _buttonElevation = _screenSize.height < smallHeight ? 7.0 : _screenSize.height < 950.0 ? quizChoiceButtonElevation : 12.0;
    final _buttonHeight = _screenSize.height < smallHeight ? 45.0 : _screenSize.height < 950.0 ? quizChoiceButtonHeight : 70.0;

    setState(() {
      _quizCardWidth = _cardWidth;
      _heightToCardStackBottom = _screenBox.size.height - quizVerticalScreenPadding - ((_buttonHeight + _buttonElevation) * 2) - choiceSpacing - cardQuizStackBottomPadding;
      _heightToQuizCardTop = _heightToCardStackBottom - _quizCardWidth - (quizCardStackTopSpace * (_cardWidth / 400.0));
      _quizCardStackHeight = _heightToCardStackBottom - _heightToQuizCardTop + cardQuizStackBottomPadding;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final double _aspectRatio = _size.aspectRatio;
    final double _padMultiplier = _aspectRatio > smallMaxAspect && _size.height <= smallHeight
      ? (_aspectRatio * 2.0)
      : _aspectRatio > mediumMaxAspect
        ? ((_aspectRatio / 0.75) * 4.0)
        : 1.0;
    final double _horizontalPadding = quizHorizontalScreenPadding * _padMultiplier;

    if (!_updatedHeights) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if ((_screenSize.height - _size.height).abs() < 80) {
          _getQuizCardsSize();
          _updatedHeights = true;
        }
      });
    } else _updatedHeights = false;
    _screenSize = _size;

    final Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding, headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: RoundedBackButton(alignment: Alignment.centerLeft),
        middle: SizedBox(
          height: 48.0,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _isTutorial ? 'Tutorial' : 'Syllables Learned',
                style: _gameData.getStyle('textQuizHeader'),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        right: _isTutorial ? TextButton(
          text: 'Skip',
          height: headerIconSize,
          color: _gameData.getColor('headerNavigation'),
          onPressed: _gameLogicManager.finishTutorial,
          width: 80.0,
          alignment: Alignment.centerRight,
        ) : CustomSwitch(
          value: _kulitanSwitch,
          onChanged: (bool val) => setState(() => _kulitanSwitch = val),
          disabled: _disableSwitch,
        ),
      ),
    );

    final bool _isTall = MediaQuery.of(context).size.height > smallHeight;
    final Widget _progressBar = Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(
          _horizontalPadding,
          _isTall ? 25.0 : 5.0,
          _horizontalPadding,
          _isTall ? 25.0 : 15.0,
        ),
        alignment: Alignment.center,
        child: _isTall
          ? CircularProgressBar(numerator: _overallProgressCount, denominator: totalGlyphCount)
          : LinearProgressBar(
            progress: _overallProgressCount / totalGlyphCount,
            color: _gameData.getColor('white'),
          ),
      ),
    );

    final Widget _buttonChoices = Padding(
      padding: EdgeInsets.fromLTRB(_horizontalPadding, 0.0, _horizontalPadding, quizVerticalScreenPadding),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ChoiceButton(
                  isKulitan: _isKulitan,
                  text: _choices[0]['text'],
                  type: _choices[0]['type'],
                  onTap: _choices[0]['onTap'],
                  disable: _disableChoices || _disableButtons[0],
                  resetStream: _resetChoicesController.stream,
                  showAnswerStream: _showAnswerChoiceController.stream,
                  buttonGroup: _buttonGroup,
                ),
              ),
              Container(
                width: choiceSpacing,
              ),
              Expanded(
                child: ChoiceButton(
                  isKulitan: _isKulitan,
                  text: _choices[1]['text'],
                  type: _choices[1]['type'],
                  onTap: _choices[1]['onTap'],
                  disable: _disableChoices || _disableButtons[1],
                  resetStream: _resetChoicesController.stream,
                  showAnswerStream: _showAnswerChoiceController.stream,
                  buttonGroup: _buttonGroup,                  
                ),
              ),
            ],
          ),
          Container(
            height: choiceSpacing,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ChoiceButton(
                  isKulitan: _isKulitan,
                  text: _choices[2]['text'],
                  type: _choices[2]['type'],
                  onTap: _choices[2]['onTap'],
                  disable: _disableChoices || _disableButtons[2],
                  resetStream: _resetChoicesController.stream,
                  showAnswerStream: _showAnswerChoiceController.stream,
                  buttonGroup: _buttonGroup,                  
                ),
              ),
              Container(
                width: choiceSpacing,
              ),
              Expanded(
                child: ChoiceButton(
                  isKulitan: _isKulitan,
                  text: _choices[3]['text'],
                  type: _choices[3]['type'],
                  onTap: _choices[3]['onTap'],
                  disable: _disableChoices || _disableButtons[3],
                  resetStream: _resetChoicesController.stream,
                  showAnswerStream: _showAnswerChoiceController.stream,
                  buttonGroup: _buttonGroup,                  
                ),
              ),
            ],
          ),
        ],
      ),
    );
    final Widget _quizCards = Container(
      height: _heightToCardStackBottom,
      child: Stack(
        key: _quizCardsKey,
        children: <Widget>[
          AnimatedQuizCard(
            isKulitan: _isKulitan,
            kulitan: _cards[2]['kulitan'],
            answer: _cards[2]['answer'],
            progress: _cards[2]['progress'] / maxQuizGlyphProgress,
            stackNumber: _cards[2]['stackNumber'],
            stackWidth: _quizCardWidth,
            heightToStackTop: _heightToQuizCardTop,
            horizontalScreenPadding: _horizontalPadding,
          ),
          AnimatedQuizCard(
            isKulitan: _isKulitan,
            kulitan: _cards[1]['kulitan'],
            answer: _cards[1]['answer'],
            progress: _cards[1]['progress'] / maxQuizGlyphProgress,
            stackNumber: _cards[1]['stackNumber'],
            stackWidth: _quizCardWidth,
            heightToStackTop: _heightToQuizCardTop,
            horizontalScreenPadding: _horizontalPadding,
          ),
          AnimatedQuizCard(
            isKulitan: _isKulitan,
            kulitan: _cards[0]['kulitan'],
            answer: _cards[0]['answer'],
            progress: _cards[0]['progress'] / maxQuizGlyphProgress,
            stackNumber: _cards[0]['stackNumber'],
            stackWidth: _quizCardWidth,
            heightToStackTop: _heightToQuizCardTop,
            flipStream: _flipStreamController.stream,
            revealAnswer: _gameLogicManager.revealAnswer,
            swipedLeft: _gameLogicManager.swipedLeft,
            swipingCard: _swipingCard,
            swipingCardDone: _swipingCardDone,
            disableSwipe: _disableSwipe,
            horizontalScreenPadding: _horizontalPadding,
          ),
        ],
      ),
    );

    List<Widget> _pageStack = [
      Column(
        children: [
          _header,
          _progressBar,
          Container(
            height: _quizCardStackHeight,
          ),
          _buttonChoices,
        ],
      ),
      _quizCards,
    ];

    if (_isTutorial) {
      if (_tutorialNo == 0) _pageStack.add(
        IgnorePointer(
          child: TutorialOverlay(
            key: _tutorialKey1,
            quizCardTop: _heightToQuizCardTop + (quizCardStackTopSpace * (_quizCardWidth / 400.0)),
            quizCardBottom: _heightToCardStackBottom,
            width: _quizCardWidth,
            flare: 'swipe_down.flr',
            animation: 'down',
            tutorialNo: _tutorialNo,
            horizontalScreenPadding: _horizontalPadding,
          ),
        ),
      );
      else if (_tutorialNo == 1) _pageStack.add(
        IgnorePointer(
          child: TutorialOverlay(
            key: _tutorialKey2,
            quizCardTop: _heightToQuizCardTop + (quizCardStackTopSpace * (_quizCardWidth / 400.0)),
            quizCardBottom: _heightToCardStackBottom,
            width: _quizCardWidth,
            flare: 'swipe_down.flr',
            animation: 'left',
            tutorialNo: _tutorialNo,
            horizontalScreenPadding: _horizontalPadding,
          ),
        ),
      );
      else if (_tutorialNo == 2) _pageStack.add(
        IgnorePointer(
          child: TutorialOverlay(
            key: _tutorialKey3,
            quizCardTop: _heightToQuizCardTop + (quizCardStackTopSpace * (_quizCardWidth / 400.0)),
            quizCardBottom: _heightToCardStackBottom,
            width: _quizCardWidth,
            flare: 'shaking_pointer.flr',
            animation: 'shake',
            tutorialNo: _tutorialNo,
            horizontalScreenPadding: _horizontalPadding,
          ),
        ),
      );
      else if (_tutorialNo == 3) _pageStack.add(
        IgnorePointer(
          child: TutorialOverlay(
            key: _tutorialKey4,
            quizCardTop: _heightToQuizCardTop + (quizCardStackTopSpace * (_quizCardWidth / 400.0)),
            quizCardBottom: _heightToCardStackBottom,
            width: _quizCardWidth,
            flare: 'shaking_pointer.flr',
            animation: 'shake',
            tutorialNo: _tutorialNo,
            horizontalScreenPadding: _horizontalPadding,
          ),
        ),
      );
      else if (_tutorialNo == 4) _pageStack.add(
        IgnorePointer(
          child: TutorialOverlay(
            key: _tutorialKey5,
            quizCardTop: _heightToQuizCardTop + (quizCardStackTopSpace * (_quizCardWidth / 400.0)),
            quizCardBottom: _heightToCardStackBottom,
            width: _quizCardWidth,
            flare: 'shaking_pointer.flr',
            animation: 'shake',
            tutorialNo: _tutorialNo,
            horizontalScreenPadding: _horizontalPadding,
          ),
        ),
      );
      else if (_tutorialNo == 5) _pageStack.add(
        IgnorePointer(
          child: TutorialSuccess(
            text: 'Congratulations, you have just finished the tutorial! 😁\nYou\'re good to go! 👌\n\nTap anywhere to continue',
            onTap: _gameLogicManager.finishTutorial,
          ),
        ),
      );
    }
    

    return Material(
      color: _gameData.getColor('background'),
      child: SafeArea(
        child: Stack(
          key: _pageKey,
          children: _pageStack,
        ),
      ),
    );
  }
}
