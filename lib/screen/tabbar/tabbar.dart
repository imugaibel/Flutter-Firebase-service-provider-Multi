import 'package:flutter/material.dart';
import 'package:maintenance/enums/user-type.dart';
import 'package:maintenance/screen/tabbar/all-service-admin.dart';
import 'package:maintenance/screen/tabbar/home-technican.dart';
import 'package:maintenance/screen/tabbar/home.dart';
import 'package:maintenance/screen/tabbar/my-order.dart';
import 'package:maintenance/screen/tabbar/profile.dart';
import 'package:maintenance/screen/tabbar/request-services.dart';
import 'package:maintenance/screen/tabbar/service.dart';
import 'package:maintenance/screen/tabbar/home-admin.dart';
import 'package:maintenance/screen/tabbar/users.dart';
import 'package:maintenance/utils/app_localization.dart';

class TabBarItem {

  final IconData icon;
  final String label;
  final Widget page;

  TabBarItem(this.icon, this.label, this.page);

}

class TabBarPage extends StatefulWidget {

  final Object?  userType;

  const TabBarPage({Key? key, this.userType}) : super(key: key);

  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {

  final PageController _pageController = PageController();

  int indexTap = 0;

  List<TabBarItem> tabItems = [
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    switch (widget.userType) {
      case UserType.ADMIN:
        tabItems = [];
        tabItems.add(TabBarItem(Icons.home, "Home", const HomeAdmin()));
        tabItems.add(TabBarItem(Icons.home_repair_service_rounded, "All Services", const AllServiceAdmin()));
        tabItems.add(TabBarItem(Icons.supervised_user_circle_sharp, "Users", const Users()));
        tabItems.add(TabBarItem(Icons.person, "Profile", const Profile()));
        break;
      case UserType.TECHNICIAN:
        tabItems = [];
        tabItems.add(TabBarItem(Icons.home, "Home", const HomeTechnican()));
        tabItems.add(TabBarItem(Icons.home_repair_service_rounded, "My Services", const Service()));
        tabItems.add(TabBarItem(Icons.home_repair_service_rounded, "Requests", const RequestServices()));
        tabItems.add(TabBarItem(Icons.person, "Profile", const Profile()));
        break;
      case UserType.USER:
        tabItems = [];
        tabItems.add(TabBarItem(Icons.home, "Home", const Home()));
        tabItems.add(TabBarItem(Icons.home_repair_service_rounded, "Services", const Service()));
        tabItems.add(TabBarItem(Icons.sticky_note_2_sharp, "My Orders", const MyOrder()));
        tabItems.add(TabBarItem(Icons.person, "Profile", const Profile()));
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabItems.length,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: _getChildrenTabBar(),
          onPageChanged: (index) {
            setState(() {
              indexTap = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: (index) {
            setState(() {
              indexTap = index;
            });
            _pageController.animateToPage(indexTap,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn
            );
          },
          type: BottomNavigationBarType.fixed,
          currentIndex: indexTap,
          items: _renderTaps(),
        ),
      ),
    );
  }

  List<Widget> _getChildrenTabBar() {

    List<Widget> items = [];

    for (var item in tabItems) {
      items.add(item.page);
    }

    return items;
  }

  List<BottomNavigationBarItem> _renderTaps() {

    List<BottomNavigationBarItem> items = [];

    for (var i = 0; i < tabItems.length; i++) {
      BottomNavigationBarItem obj = BottomNavigationBarItem(icon: Icon(tabItems[i].icon, color: indexTap == i ? Theme.of(context).primaryColor : Colors.black26,), label: AppLocalization.of(context)!.translate(tabItems[i].label));
      items.add(obj);
    }

    return items;

  }

}