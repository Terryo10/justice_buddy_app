import 'package:auto_route/auto_route.dart';
import '../ui/pages/ask_legal_page.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/labor_page.dart';
import '../ui/pages/landing_page.dart';
import '../ui/pages/traffic_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: LandingRoute.page,
      initial: true,
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home'),
        AutoRoute(page: LaborRoute.page, path: 'labor'),
        AutoRoute(page: TrafficRoute.page, path: 'traffic'),
        AutoRoute(page: AskLegalRoute.page, path: 'ask-legal'),
      ],
    ),
  ];
}
