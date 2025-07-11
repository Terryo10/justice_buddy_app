import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../routes/app_router.dart';
import '../shared_widgets/desktop_nav_bar.dart';
import '../shared_widgets/mobile_bottom_nav.dart';
import '../shared_widgets/side_bar.dart';

@RoutePage()
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;
    final theme = Theme.of(context);

    return AutoTabsRouter(
      routes: [
        HomeRoute(),
        ChatRoute(),
        LetterTemplatesRoute(),
        GetDocumentsRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,

          appBar:
              isWide
                  ? DesktopNavBar(
                    selectedTab: tabsRouter.activeIndex,
                    tabs: const [
                      'Home',
                      'Legal Chat',
                      'Letter Generator',
                      'Get Documents',
                    ],
                    onTabSelected: (index) => tabsRouter.setActiveIndex(index),
                  )
                  : AppBar(
                    title: const Text('Justice Buddy'),
                    backgroundColor:
                        theme.brightness == Brightness.dark
                            ? theme.cardColor
                            : theme.colorScheme.primary,
                    foregroundColor:
                        theme.brightness == Brightness.dark
                            ? theme.appBarTheme.foregroundColor
                            : Colors.white,
                    elevation: 0,
                    centerTitle: false,
                    iconTheme: IconThemeData(
                      color:
                          theme.brightness == Brightness.dark
                              ? theme.appBarTheme.foregroundColor
                              : Colors.white,
                    ),
                  ),
          drawer: !isWide ? const SideBar() : null,
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
