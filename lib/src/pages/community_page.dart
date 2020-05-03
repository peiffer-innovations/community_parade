import 'package:community_parade/src/theme/app_color.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  BottomNavigationBarItem _buildBottomNavBarItem({
    @required BuildContext context,
    @required String label,
    @required Widget icon,
  }) {
    return BottomNavigationBarItem(
      icon: icon,
      title: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          SizedBox(),
          SizedBox(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        selectedItemColor: AppColor.primaryColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(
            () => _tabController.index = index,
          );
        },
        unselectedItemColor: AppColor.divider,
        items: [
          _buildBottomNavBarItem(
            context: context,
            label: 'Parade',
            icon: Icon(Icons.map),
          ),
          _buildBottomNavBarItem(
            context: context,
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
