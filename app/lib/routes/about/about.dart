import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import '../../styles/theme.dart';
import '../../components/buttons/RoundedBackButton.dart';
import '../../components/buttons/BackToStartButton.dart';
import '../../components/buttons/PageButton.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/StickyHeading.dart';
import '../../components/misc/ImageWithCaption.dart';
import '../../components/misc/Paragraphs.dart';
import '../../components/misc/DividerNew.dart';
import '../../db/GameData.dart';
import './components.dart';

class AboutPage extends StatefulWidget {
  const AboutPage();
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  static final GameData _gameData = GameData();
  final _scrollController = ScrollController();
  FlutterLogoStyle _flutterLogoStyle = FlutterLogoStyle.markOnly;
  double _flutterLogoSize = 50.0;

  bool _showBackToStartFAB = false;

  @override
  void initState() {
    super.initState();
    _scrollController..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _scrollListener() async {
    final double _position = _scrollController.offset;
    final double _threshold =
        historyFABThreshold * _scrollController.position.maxScrollExtent;
    if (_position <= _threshold && _showBackToStartFAB == true)
      setState(() => _showBackToStartFAB = false);
    else if (_position > _threshold && !_showBackToStartFAB)
      setState(() => _showBackToStartFAB = true);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50 &&
        _flutterLogoSize == 50.0) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _flutterLogoStyle = FlutterLogoStyle.horizontal;
        _flutterLogoSize = 130.0;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: informationPageScrollDuration),
        curve: Curves.easeInOut,
      );
    } else if (_scrollController.position.pixels <
            _scrollController.position.maxScrollExtent - 220 &&
        _flutterLogoStyle == FlutterLogoStyle.horizontal) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _flutterLogoStyle = FlutterLogoStyle.markOnly;
        _flutterLogoSize = 50.0;
      });
    }
  }

  void _openURL(String url) async {
    String _message;
    if (await canLaunch(url)) {
      _message = 'Opening link...';
      await launch(url);
    } else {
      _message = 'Cannot open link';
    }
    Fluttertoast.showToast(
      msg: _message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 3,
      backgroundColor: _gameData.getColor('toastBackground'),
      textColor: _gameData.getColor('toastForeground'),
      fontSize: toastFontSize,
    );
  }

  void _sendEmail(String emailAddress) {
    FlutterEmailSender.send(Email(
      subject: 'Kulitan Handwriting Font Inquiry',
      recipients: [emailAddress],
    ));
    Fluttertoast.showToast(
      msg: 'Composing email...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 3,
      backgroundColor: _gameData.getColor('toastBackground'),
      textColor: _gameData.getColor('toastForeground'),
      fontSize: toastFontSize,
    );
  }

  void _shareApp() {
    try {
      final String _link = Platform.isIOS ? learnKulitanIOSLink : learnKulitanAndroidlink;
      Share.share('Kulitan has gone digital!\nManigáral tá nang Súlat Kapampángan!\n$_link');

      Fluttertoast.showToast(
        msg: 'Thanks for sharing! Luíd ka!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: _gameData.getColor('toastBackground'),
        textColor: _gameData.getColor('toastForeground'),
        fontSize: toastFontSize,
      );
    } catch (_) {
      Fluttertoast.showToast(
        msg: 'Unable to share',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: _gameData.getColor('toastBackground'),
        textColor: _gameData.getColor('toastForeground'),
        fontSize: toastFontSize,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final double _screenWidth = _mediaQuery.size.width;
    final double _screenHorizontalPadding = _screenWidth > maxPageWidth ? 0.0 : aboutHorizontalScreenPadding;
    final double _width = _mediaQuery.size.width > maxPageWidth ? maxPageWidth : _mediaQuery.size.width;

    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding,
          headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: RoundedBackButton(),
        right: SizedBox(width: 48.0, height: 48.0),
      ),
    );

    final Widget _about = Column(
      children: <Widget>[
        Paragraphs(
          padding: 0.0,
          paragraphs: <TextSpan>[
            RomanText(
                'This mobile application was developed with the goal of providing an easily accessible way for learning the Kulitan script (Súlat Kapampángan) with ease of use in mind. This application was not meant as a substitute for formal learning of the script through workshops and seminars. It provides just a glimpse of what the script has to offer aside from being the perfect and most appropriate script for writing the Kapampangan language.'),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: aboutSubtitleTopPadding),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('The Developer', style: _gameData.getStyle('textAboutSubtitle')),
          ),
        ),
        ImageWithCaption(
          filename: _gameData.getColorScheme() == 'default' ? 'keith.jpg' : 'keith_sablay.jpg',
          screenWidth: _width,
        ),
        Paragraphs(
          paragraphs: [
            RomanText(
                'Keith Liam Manaloto studied Computer Science at the University of the Philippines Los Baños. He is a Kapampangan from Angeles City. His development of this application was primarily driven by his passion to preserve the culture and heritage of his hometown. During his free time, he likes to travel, take photographs, listen to podcasts, learn new languages, and read tech news & articles.'),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: paragraphTopPadding),
          child: IntrinsicWidth(
            child: Column(
              children: <Widget>[
                SocialMediaLink(
                  filename: 'twitter.png',
                  name: 'KeithManaloto_',
                  link: 'https://bit.ly/LearnKulitan-About-Twitter',
                  topPadding: 0.0,
                ),
                SocialMediaLink(
                  filename: 'instagram.png',
                  name: 'keithliam',
                  link: 'https://bit.ly/LearnKulitan-About-Instagram',
                ),
                SocialMediaLink(
                  filename: 'behance.png',
                  name: 'keithliam',
                  link: 'https://bit.ly/LearnKulitan-About-Behance',
                ),
                SocialMediaLink(
                  filename: 'github.png',
                  name: 'keithliam',
                  link: 'https://bit.ly/LearnKulitan-About-GitHub',
                ),
                SocialMediaLink(
                  filename: 'gmail.png',
                  name: 'keithliamm@gmail.com',
                  emailAddress: 'keithliamm@gmail.com',
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: aboutSubtitleTopPadding),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Acknowledgements', style: _gameData.getStyle('textAboutSubtitle')),
          ),
        ),
        ImageWithCaption(
          filename: 'mike.jpeg',
          screenWidth: _width,
          captionAlignment: TextAlign.center,
          caption: TextSpan(
            text: 'Michael Raymon M. Pangilinan\n(Siuálâ ding Meángûbié)',
          ),
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Special thanks to the “living Kapampangan culture resource center”, Mr. Mike Pangilinan for his extensive research regarding the Kulitan script, for making sure that the application\'s contents were correct, and for his big contribution to the Information pages. His comments and suggestions led to significant improvements of this mobile application. Visit his website at '),
                RomanText(
                  'siuala.com',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL('https://bit.ly/LearnKulitan-Siuala'),
                ),
                RomanText(
                    ' for more information about Kapampangan language, script, history, cuisine, culture, and heritage.'),
              ],
            ),
            RomanText(
                'I would also like to thank Mr. Kevin Bätscher of University of Hawaiʻi for his contributions to the Kulitan keyboard made for the application.'),
            RomanText(
                'Lastly, I am most grateful to my girlfriend, Shaira Lapus, for motivating me to do my best and to deliver the best application that I could possibly create. She also did most of the laborous plotting work for the Kulitan strokes in the writing page. Thank you, love.'),
          ],
        ),
        ImageWithCaption(
          filename: 'dakal_a_salamat.png',
          caption: TextSpan(text: 'Thank you so much 😊🎉'),
          orientation: Axis.horizontal,
          screenWidth: _width,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            _width * 0.31,
            37.0,
            _width * 0.31,
            18.0,
          ),
          child: DividerNew(
            height: 3.0,
            color: _gameData.getColor('informationDivider'),
            boxShadow: BoxShadow(
              offset: Offset(2.0, 2.0),
              color: _gameData.getColor('informationDividerShadow'),
            ),
          ),
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              children: <TextSpan>[
                RomanText('This mobile application took '),
                BoldRomanText('hundreds of hours'),
                RomanText(
                    ' to develop.'), // In-app advertisements were not included to provide you the best experience as possible.
              ],
            ),
            RomanText(
                'If you would like to support the developer for future updates and improvements of this application, feel free to donate! You may also express your support using the social media links above!'),
          ],
        ),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 5.0),
        //   child: PageButton(
        //     onPressed: () => _openURL('https://bit.ly/LearnKulitan-About-PayPal'),
        //     isColored: true,
        //     text: 'DONATE',
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            _width * 0.31,
            35.0,
            _width * 0.31,
            18.0,
          ),
          child: DividerNew(
            height: 3.0,
            color: _gameData.getColor('informationDivider'),
            boxShadow: BoxShadow(
              offset: Offset(2.0, 2.0),
              color: _gameData.getColor('informationDividerShadow'),
            ),
          ),
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              children: <TextSpan>[
                RomanText('The success animation used in the tutorials was made by '),
                RomanText(
                  'Guido Rosso',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL('https://bit.ly/LearnKulitan-About-Flare'),
                ),
                RomanText(', licensed under '),
                RomanText(
                  'CC BY',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL('https://bit.ly/LearnKulitan-About-FlareLicense'),
                ),
                RomanText('.'),
              ],
            ),
            TextSpan(
              style: _gameData.getStyle('textAboutFooter'),
              children: <TextSpan>[
                RomanText('This application was developed using '),
                RomanText(
                  'Flutter',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL('https://bit.ly/LearnKulitan-About-Flutter'),
                ),
                RomanText('.'),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: FlutterLogo(
            size: _flutterLogoSize,
            style: _flutterLogoStyle,
            textColor: _gameData.getColor('paragraphText'),
          ),
        ),
        Paragraphs(
          padding: 0.0,
          paragraphs: [
            TextSpan(
              children: <TextSpan>[
                RomanText('Found a problem? Report it to '),
                RomanText(
                  'keithliamm@gmail.com',
                  TapGestureRecognizer()
                    ..onTap = () => _sendEmail('keithliamm@gmail.com'),
                ),
                RomanText('. Attach screenshots if applicable. Suggestions are also welcome!')
              ],
            ),
            RomanText(''),
            RomanText('Loved the app? Share it! Promote Kulitan!'),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              20.0, 25.0, 20.0, aboutVerticalScreenPadding - 10.0),
          child: PageButton(
            onPressed: _shareApp,
            text: 'SHARE',
            icon: Icons.share,
          ),
        ),
      ],
    );

    List<Widget> _pageStack = [
      Scrollbar(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxPageWidth),
              child: Column(
                children: <Widget>[
                  StickyHeading(
                    headingText: 'Reng Gínawá',
                    content: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(
                        _screenHorizontalPadding,
                        aboutVerticalScreenPadding,
                        _screenHorizontalPadding,
                        aboutVerticalScreenPadding - headerVerticalPadding + 8.0,
                      ),
                      child: _about,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      _header,
    ];

    if (_showBackToStartFAB) {
      _pageStack.add(
        BackToStartButton(
          onPressed: () {
            _scrollController.animateTo(
              0.0,
              duration:
                  const Duration(milliseconds: informationPageScrollDuration),
              curve: informationPageScrollCurve,
            );
          },
        ),
      );
    }

    return Material(
      color: _gameData.getColor('background'),
      child: SafeArea(
        child: Stack(children: _pageStack),
      ),
    );
  }
}
