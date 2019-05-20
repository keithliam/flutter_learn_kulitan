import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'
    show TapGestureRecognizer, GestureRecognizer;
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import '../../styles/theme.dart';
import '../../components/buttons/IconButtonNew.dart';
import '../../components/buttons/BackToStartButton.dart';
import '../../components/buttons/CustomButton.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/StickyHeading.dart';
import '../../components/misc/ImageWithCaption.dart';
import '../../components/misc/Paragraphs.dart';
import '../../components/misc/DividerNew.dart';
import './components.dart';

class AboutPage extends StatefulWidget {
  const AboutPage();
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
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
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: toastFontSize,
    );
  }

  void _shareApp() {
    try {
      Share.share(
          'Kulitan has gone digital!\nManigáral tá nang Súlat Kapampángan!\nhttps://play.google.com');
      Fluttertoast.showToast(
        msg: 'Thanks for sharing! Luíd ka!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: toastFontSize,
      );
    } catch (_) {
      Fluttertoast.showToast(
        msg: 'Unable to share',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: toastFontSize,
      );
    }
  }

  TextSpan _romanText(String text, [GestureRecognizer recognizer]) {
    return TextSpan(
      text: text,
      style: recognizer == null ? textInfoText : textInfoLink,
      recognizer: recognizer,
    );
  }

  TextSpan _boldRomanText(String text) {
    return TextSpan(
      text: text,
      style: textInfoTextItalic.copyWith(fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;

    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding,
          headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: IconButtonNew(
          icon: Icons.arrow_back_ios,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: () => Navigator.pop(context),
        ),
        // right: IconButtonNew(
        //   icon: Icons.settings,
        //   iconSize: headerIconSize,
        //   color: headerNavigationColor,
        //   onPressed: null,
        // ),
        right: SizedBox(width: 56.0, height: 48.0),
      ),
    );

    final Widget _about = Column(
      children: <Widget>[
        Paragraphs(
          padding: 0.0,
          paragraphs: <TextSpan>[
            _romanText(
                'This mobile application was developed with the goal of providing an easily accessible way for learning the Kulitan script (Súlat Kapampángan) with ease of use in mind. This application was not meant as a substitute for formal learning of the script through workshops and seminars. It provides just a glimpse of what the script has to offer aside from being the perfect and most appropriate script for writing the Kapampangan language.'),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: aboutSubtitleTopPadding),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('The Developer', style: textAboutSubtitle),
          ),
        ),
        ImageWithCaption(
          filename: 'keith.jpg',
          screenWidth: _width,
        ),
        Paragraphs(
          paragraphs: [
            _romanText(
                'Keith Liam Manaloto is an undergraduate Computer Science student at the University of the Philippines Los Baños. He is a Kapampangan resident of Angeles City. His development of this application was primarily driven by his passion to preserve the culture and heritage of his hometown. During his free time, he likes to travel, take photographs, listen to podcasts, and read tech news & articles.'),
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
                  link: 'https://twitter.com/KeithManaloto_',
                  topPadding: 0.0,
                ),
                SocialMediaLink(
                  filename: 'instagram.png',
                  name: 'keithliam',
                  link: 'https://instagram.com/keithliam',
                ),
                SocialMediaLink(
                  filename: 'behance.png',
                  name: 'keithliam',
                  link: 'https://behance.net/keithliam',
                ),
                SocialMediaLink(
                  filename: 'github.png',
                  name: 'keithliam',
                  link: 'https://github.com/keithliam',
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
            child: Text('Acknowledgements', style: textAboutSubtitle),
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
                _romanText(
                    'Special thanks to the “living Kapampangan culture resource center”, Mr. Mike Pangilinan for his extensive research regarding the Kulitan script, for making sure that the application\'s contents were correct, and for his big contribution to the Information pages. His comments and suggestions led to significant improvements of this mobile application. Visit his website at '),
                _romanText(
                  'siuala.com',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL('http://siuala.com/'),
                ),
                _romanText(
                    ' for more information about Kapampangan language, script, history, cuisine, culture, and heritage.'),
              ],
            ),
            _romanText(
                'I would also like to thank Mr. Kevin Bätscher of University of Hawaiʻi for his contributions to the Kulitan keyboard made for the application.'),
            _romanText(
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
          padding: const EdgeInsets.only(top: aboutSubtitleTopPadding),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Resources', style: textAboutSubtitle),
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            _romanText(
                'Prior to the development of this app, a modern Kulitan font was created by the developer. This font was designed to be display-friendly, enhancing readability on mobile devices.'),
          ],
        ),
        ImageWithCaption(
          filename: 'kulitan_font.png',
          caption: TextSpan(text: 'Kulitan Handwriting Font'),
          screenWidth: _width,
          hasBorder: true,
          percentWidth: 0.65,
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'The OpenType font is free for non-commercial purposes. It is available for download at '),
                _romanText(
                  'Behance.net',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL('https://behance.net/keithliam'),
                ),
                _romanText(
                    '. For licensing inquiries, you may contact the developer via email at '),
                _romanText(
                  'keithliamm@gmail.com',
                  TapGestureRecognizer()
                    ..onTap = () => _sendEmail('keithliamm@gmail.com'),
                ),
                _romanText('.'),
              ],
            )
          ],
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
            color: informationDividerColor,
            boxShadow: BoxShadow(
              offset: Offset(2.0, 2.0),
              color: informationDividerShadowColor,
            ),
          ),
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              children: <TextSpan>[
                _romanText('This mobile application took '),
                _boldRomanText('hundreds of hours'),
                _romanText(
                    ' to develop. In-app advertisements were not included to provide you the best experience as possible.'),
              ],
            ),
            _romanText(
                'If you would like to support the developer for future updates and improvements of this application, feel free to donate by pressing the button below! You may also express your support using the social media links above!'),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 5.0),
          child: CustomButton(
            onPressed: () => _openURL('https://www.paypal.me/keithmanaloto'),
            borderRadius: 30.0,
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            elevation: 10.0,
            color: accentColor,
            child: Center(
              child: Text('DONATE', style: textAboutButton),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            _width * 0.31,
            35.0,
            _width * 0.31,
            18.0,
          ),
          child: DividerNew(
            height: 3.0,
            color: informationDividerColor,
            boxShadow: BoxShadow(
              offset: Offset(2.0, 2.0),
              color: informationDividerShadowColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: paragraphTopPadding),
          child: RichText(
            text: TextSpan(
              style: textAboutFooter,
              children: <TextSpan>[
                _romanText('This application was developed using '),
                _romanText(
                  'Flutter',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL('https://flutter.io/'),
                ),
                _romanText('.'),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: FlutterLogo(
            size: _flutterLogoSize,
            style: _flutterLogoStyle,
            textColor: paragraphTextColor,
          ),
        ),
        Paragraphs(
          padding: 0.0,
          paragraphs: [
            _romanText('Loved the app? Share it! Promote Kulitan!'),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              20.0, 25.0, 20.0, aboutVerticalScreenPadding - 10.0),
          child: CustomButton(
            onPressed: _shareApp,
            borderRadius: 30.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 10.0,
            ),
            elevation: 10.0,
            color: whiteColor,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(right: 10.0),
                    alignment: Alignment.center,
                    child: Text(
                      'SHARE',
                      style: textAboutButton.copyWith(color: foregroundColor),
                    ),
                  ),
                  Icon(Icons.share, color: accentColor),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    List<Widget> _pageStack = [
      Scrollbar(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              StickyHeading(
                headingText: 'Reng Gínawá',
                content: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    aboutHorizontalScreenPadding,
                    aboutVerticalScreenPadding,
                    aboutHorizontalScreenPadding,
                    aboutVerticalScreenPadding - headerVerticalPadding + 8.0,
                  ),
                  child: _about,
                ),
              ),
            ],
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
      color: backgroundColor,
      child: SafeArea(
        child: Stack(
          children: _pageStack,
        ),
      ),
    );
  }
}
