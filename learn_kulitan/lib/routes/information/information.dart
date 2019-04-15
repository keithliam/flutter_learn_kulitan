import 'package:flutter/material.dart';
import '../../styles/theme.dart';
import '../../components/buttons/IconButtonNew.dart';
import '../../components/buttons/CustomButton.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/DividerNew.dart';
import './components.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding,
          headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: IconButtonNew(
          icon: Icons.arrow_back_ios,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: () => Navigator.pushNamed(context, '/'),
        ),
        middle: Padding(
          padding: const EdgeInsets.only(bottom: headerVerticalPadding),
          child: Center(
            child: Text('Information', style: textPageTitle),
          ),
        ),
        right: IconButtonNew(
          icon: Icons.settings,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: null,
        ),
      ),
    );

    final Widget _historyButton = CustomButton(
      onPressed: () => Navigator.pushNamed(context, '/information/history'),
      height: 60.0,
      borderRadius: 30.0,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      elevation: 10.0,
      child: Center(
          child: Row(
        children: <Widget>[
          Text('History of Kulitan', style: textInfoButton),
          Spacer(),
          Text('>', style: textInfoButton.copyWith(color: accentColor)),
        ],
      )),
    );
    final Widget _writingInstructionsButton = CustomButton(
      onPressed: () => Navigator.pushNamed(context, '/information/guide'),
      height: 60.0,
      borderRadius: 30.0,
      marginTop: 10.0,
      elevation: 10.0,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Center(
          child: Row(
        children: <Widget>[
          Text('Writing Guide', style: textInfoButton),
          Spacer(),
          Text('>', style: textInfoButton.copyWith(color: accentColor)),
        ],
      )),
    );

    final Widget _indungSulatTable = Table(
      defaultColumnWidth: FlexColumnWidth(1.0),
      children: <TableRow>[
        TableRow(children: <Widget>[
          KulitanInfoCell('ga', 'ga'),
          KulitanInfoCell('ka', 'ka'),
          KulitanInfoCell('nga', 'nga'),
          KulitanInfoCell('ta', 'ta'),
        ]),
        TableRow(children: <Widget>[
          KulitanInfoCell('da', 'da'),
          KulitanInfoCell('na', 'na'),
          KulitanInfoCell('la', 'la'),
          KulitanInfoCell('sa', 'sa'),
        ]),
        TableRow(children: <Widget>[
          KulitanInfoCell('ma', 'ma'),
          KulitanInfoCell('pa', 'pa'),
          KulitanInfoCell('ba', 'ba'),
          Container(),
        ]),
      ],
    );
    final Widget _indungSulatVowelTable = Table(
      defaultColumnWidth: FlexColumnWidth(1.0),
      children: <TableRow>[
        TableRow(children: <Widget>[
          KulitanInfoCell('a', 'a'),
          KulitanInfoCell('i', 'ka'),
          KulitanInfoCell('u', 'u'),
          KulitanInfoCell('e', 'e'),
          KulitanInfoCell('o', 'o'),
        ]),
        TableRow(children: <Widget>[
          KulitanInfoCell('aa', 'á/â'),
          KulitanInfoCell('ii', 'í/î'),
          KulitanInfoCell('uu', 'ú/û'),
          Container(),
          Container(),
        ]),
      ],
    );

    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _cellWidth =
        (_screenWidth - (informationHorizontalScreenPadding * 2)) / 4;

    final Widget _anakSulatTable = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: informationHorizontalScreenPadding),
        child: Table(
          defaultColumnWidth: FixedColumnWidth(_cellWidth),
          children: <TableRow>[
            TableRow(children: <Widget>[
              KulitanInfoCell('gaa', 'gá/gâ'),
              KulitanInfoCell('gi', 'gi'),
              KulitanInfoCell('gii', 'gí/gî'),
              KulitanInfoCell('gu', 'gu'),
              KulitanInfoCell('guu', 'gú/gû'),
              KulitanInfoCell('ge', 'ge'),
              KulitanInfoCell('go', 'go'),
              KulitanInfoCell('gang', 'gang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('kaa', 'ká/kâ'),
              KulitanInfoCell('ki', 'ki'),
              KulitanInfoCell('kii', 'kí/kî'),
              KulitanInfoCell('ku', 'ku'),
              KulitanInfoCell('kuu', 'kú/kû'),
              KulitanInfoCell('ke', 'ke'),
              KulitanInfoCell('ko', 'ko'),
              KulitanInfoCell('kang', 'kang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('ngaa', 'ngá/ngâ'),
              KulitanInfoCell('ngi', 'ngi'),
              KulitanInfoCell('ngii', 'ngí/ngî'),
              KulitanInfoCell('ngu', 'ngu'),
              KulitanInfoCell('nguu', 'ngú/ngû'),
              KulitanInfoCell('nge', 'nge'),
              KulitanInfoCell('ngo', 'ngo'),
              KulitanInfoCell('ngang', 'ngang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('taa', 'tá/tâ'),
              KulitanInfoCell('ti', 'ti'),
              KulitanInfoCell('tii', 'tí/tî'),
              KulitanInfoCell('tu', 'tu'),
              KulitanInfoCell('tuu', 'tú/tû'),
              KulitanInfoCell('te', 'te'),
              KulitanInfoCell('to', 'to'),
              KulitanInfoCell('tang', 'tang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('daa', 'dá/dâ'),
              KulitanInfoCell('di', 'di'),
              KulitanInfoCell('dii', 'dí/dî'),
              KulitanInfoCell('du', 'du'),
              KulitanInfoCell('duu', 'dú/dû'),
              KulitanInfoCell('de', 'de'),
              KulitanInfoCell('do', 'do'),
              KulitanInfoCell('dang', 'dang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('naa', 'ná/nâ'),
              KulitanInfoCell('ni', 'ni'),
              KulitanInfoCell('nii', 'ní/nî'),
              KulitanInfoCell('nu', 'nu'),
              KulitanInfoCell('nuu', 'nú/nû'),
              KulitanInfoCell('ne', 'ne'),
              KulitanInfoCell('no', 'no'),
              KulitanInfoCell('nang', 'nang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('laa', 'lá/lâ'),
              KulitanInfoCell('li', 'li'),
              KulitanInfoCell('lii', 'lí/lî'),
              KulitanInfoCell('lu', 'lu'),
              KulitanInfoCell('luu', 'lú/lû'),
              KulitanInfoCell('le', 'le'),
              KulitanInfoCell('lo', 'lo'),
              KulitanInfoCell('lang', 'lang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('saa', 'sá/sâ'),
              KulitanInfoCell('si', 'si'),
              KulitanInfoCell('sii', 'sí/sî'),
              KulitanInfoCell('su', 'su'),
              KulitanInfoCell('suu', 'sú/sû'),
              KulitanInfoCell('se', 'se'),
              KulitanInfoCell('so', 'so'),
              KulitanInfoCell('sang', 'sang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('maa', 'má/mâ'),
              KulitanInfoCell('mi', 'mi'),
              KulitanInfoCell('mii', 'mí/mî'),
              KulitanInfoCell('mu', 'mu'),
              KulitanInfoCell('muu', 'mú/mû'),
              KulitanInfoCell('me', 'me'),
              KulitanInfoCell('mo', 'mo'),
              KulitanInfoCell('mang', 'mang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('paa', 'pá/pâ'),
              KulitanInfoCell('pi', 'pi'),
              KulitanInfoCell('pii', 'pí/pî'),
              KulitanInfoCell('pu', 'pu'),
              KulitanInfoCell('puu', 'pú/pû'),
              KulitanInfoCell('pe', 'pe'),
              KulitanInfoCell('po', 'po'),
              KulitanInfoCell('pang', 'pang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('baa', 'bá/bâ'),
              KulitanInfoCell('bi', 'bi'),
              KulitanInfoCell('bii', 'bí/bî'),
              KulitanInfoCell('bu', 'bu'),
              KulitanInfoCell('buu', 'bú/bû'),
              KulitanInfoCell('be', 'be'),
              KulitanInfoCell('bo', 'bo'),
              KulitanInfoCell('bang', 'bang'),
            ]),
          ],
        ),
      ),
    );

    final _indungSulatDivider = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _screenWidth * 0.25,
        vertical: informationSubtitleBottomPadding,
      ),
      child: DividerNew(
        height: 3.0,
        color: informationDividerColor,
        boxShadow: BoxShadow(
          offset: Offset(2.0, 2.0),
          color: informationDividerShadowColor,
        ),
      ),
    );

    const Widget _indungSulatTitle = Padding(
      padding: const EdgeInsets.only(
        top: informationVerticalScreenPadding,
        bottom: informationSubtitleBottomPadding,
      ),
      child: Center(
        child: Text(
          'Indûng Súlat',
          style: textPageTitle,
        ),
      ),
    );
    const Widget _anakSulatTitle = Padding(
      padding: const EdgeInsets.only(
        top: informationVerticalScreenPadding,
        bottom: informationSubtitleBottomPadding,
      ),
      child: Center(
        child: Text(
          'Anak Súlat',
          style: textPageTitle,
        ),
      ),
    );

    return Material(
      color: backgroundColor,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _header,
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: informationVerticalScreenPadding),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: informationHorizontalScreenPadding),
                        child: Column(children: <Widget>[
                          _historyButton,
                          _writingInstructionsButton,
                          _indungSulatTitle,
                          _indungSulatTable,
                          _indungSulatDivider,
                          _indungSulatVowelTable,
                          _anakSulatTitle,
                        ]),
                      ),
                      _anakSulatTable,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}