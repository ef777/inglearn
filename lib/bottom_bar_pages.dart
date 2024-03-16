import 'package:english_learn/pages/bottom_bar_pages/home_page.dart';
import 'package:english_learn/pages/bottom_bar_pages/onevone_pages/match_page.dart';
import 'package:english_learn/pages/bottom_bar_pages/profile_pages/profil_page.dart';
import 'package:english_learn/pages/bottom_bar_pages/quiz_page.dart';
import 'package:english_learn/pages/bottom_bar_pages/status_page.dart';
import 'package:english_learn/service/notifi_service.dart';
import 'package:english_learn/service/spin_service.dart';
import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';

int spinQu = 0;
const List<TabItem> items = [
  TabItem(
    icon: Icons.home,
    title: 'Öğren',
  ),
  TabItem(
    icon: Icons.people,
    title: '1v1',
  ),
  TabItem(
    icon: Icons.view_list_rounded,
    title: 'Quiz',
  ),
  TabItem(
    icon: Icons.switch_access_shortcut_add_sharp,
    title: 'Stats',
  ),
  TabItem(
    icon: Icons.account_box,
    title: 'profile',
  ),
];
final List<Widget> bottomBarPages = [
  const HomePage(),
  const MatchPage(),
  const QuizLoad(),
  const StatusPage(),
  const ProfilPage()
];

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({
    Key? key,
    this.index,
  }) : super(key: key);
  final int? index;
  @override
  // ignore: library_private_types_in_public_api
  _BottomBarPageState createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  late int visit;

  final _service = FirebaseNotificationService();
  final _spin = SpinController();
  spin() async {
    spinQu = await _spin.getSpinCount();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    spin();
    _spin.resetSpinCountIfNewDay();
    _service.connectNotification();
    visit = widget.index ?? 0;
    super.initState();
  }

  double height = 30;
  Color colorSelect = const Color(0XFF0686F8);
  Color color = const Color(0XFF7AC0FF);
  Color color2 = const Color(0XFF96B1FD);
  Color bgColor = const Color(0XFF1752FE);
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: bottomBarPages[visit],
        bottomNavigationBar: BottomBarInspiredFancy(
          enableShadow: true,
          boxShadow: [
            BoxShadow(
                blurRadius: 4,
                spreadRadius: 1,
                color: Colors.grey.withOpacity(.2))
          ],
          items: items,
          backgroundColor: Colors.white,
          color: color,
          colorSelected: colorSelect,
          indexSelected: visit,
          styleIconFooter: StyleIconFooter.dot,
          onTap: (int index) => setState(() {
            visit = index;
            // _pageController.jumpToPage(
            //   index,
            // );
          }),
        ));
  }
}
