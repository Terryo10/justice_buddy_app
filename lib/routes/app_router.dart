import 'package:auto_route/auto_route.dart';
import '../ui/pages/landing_page.dart';
import '../ui/pages/labor_page.dart';
import '../ui/pages/traffic_page.dart';
import '../ui/pages/ask_legal_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/', page: LandingRoute.page, initial: true),
    AutoRoute(path: '/labor', page: LaborRoute.page),
    AutoRoute(path: '/traffic', page: TrafficRoute.page),
    AutoRoute(path: '/ask-legal', page: AskLegalRoute.page),
  ];
}
