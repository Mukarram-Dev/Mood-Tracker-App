import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mood_track/views/bottom_nav_home/nav_controller/nav_controller.dart';
import 'package:mood_track/views/bottom_nav_home/widget/buil_nav_bar.dart';
import 'package:mood_track/views/home/home_view.dart';

class BottomNavHome extends StatelessWidget {
  const BottomNavHome({super.key});

  @override
  Widget build(BuildContext context) {
    var navScreens = [
      const HomeView(),
      // const DepositView(),
      // const WithdrawView(),
    ];

    return Scaffold(
      bottomNavigationBar: buildBottomNavigationMenu(context),
      body: Consumer<NavPageController>(
        builder: (context, value, child) => Stack(
          children: List.generate(
            navScreens.length,
            (index) => Visibility(
              maintainState: true,
              visible: value.tabIndex.value == index,
              child: navScreens[index],
            ),
          ),
        ),
      ),
    );
  }
}
