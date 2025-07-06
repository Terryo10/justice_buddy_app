import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../routes/app_router.dart';
import '../shared_widgets/desktop_nav_bar.dart';
import '../shared_widgets/mobile_bottom_nav.dart';

@RoutePage()
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;
    return AutoTabsRouter(
      routes: [HomeRoute(), LaborRoute(), TrafficRoute(), AskLegalRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          backgroundColor: const Color(0xFF0A0E1A),
          appBar:
              isWide
                  ? DesktopNavBar(
                    selectedTab: tabsRouter.activeIndex,
                    tabs: const ['Home', 'Labor', 'Traffic', 'Ask Legal'],
                    onTabSelected: (index) => tabsRouter.setActiveIndex(index),
                  )
                  : null,
          bottomNavigationBar:
              !isWide
                  ? MobileBottomNav(
                    selectedTab: tabsRouter.activeIndex,
                    onTabSelected: (index) => tabsRouter.setActiveIndex(index),
                  )
                  : null,
          body: child,
        );
      },
    );
  }
}
