import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:paml_20190140086_ewallet/config/color.dart';
import 'package:paml_20190140086_ewallet/presentation/pages/dashboard/dashboard_page.dart';
import 'package:paml_20190140086_ewallet/presentation/pages/income/income_page.dart';
import 'package:paml_20190140086_ewallet/presentation/pages/outcome/outcome_page.dart';
import 'package:paml_20190140086_ewallet/presentation/pages/profile/profile_page.dart';
import 'package:paml_20190140086_ewallet/presentation/pages/report/report_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PersistentTabController _tabController = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _tabController,
      screens: const [DashboardPage(), IncomePage(), OutcomePage(), ReportPage(), ProfilePage()],
      items: _navBarItems(),
      backgroundColor: Colors.white,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      confineInSafeArea: true,
      handleAndroidBackButtonPress: true, 
      resizeToAvoidBottomInset: true,
      hideNavigationBarWhenKeyboardShows: true,
      stateManagement: false,
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home, size: 20),
        title: ("Dashboard"),
        activeColorPrimary: mainDarkBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.money_dollar, size: 20),
        title: ("Incomes"),
        activeColorPrimary: mainDarkBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.shopping_cart, size: 20),
        title: ("Outcomes"),
        activeColorPrimary: mainDarkBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.chart_bar, size: 20),
        title: ("Report"),
        activeColorPrimary: mainDarkBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.profile_circled, size: 20),
        title: ("Profile"),
        activeColorPrimary: mainDarkBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}