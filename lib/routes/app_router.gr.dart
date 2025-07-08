// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AskLegalRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AskLegalPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    LaborRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LegalDrafter(),
      );
    },
    LandingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LandingPage(),
      );
    },
    TrafficRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GetDocuments(),
      );
    },
  };
}

/// generated route for
/// [AskLegalPage]
class AskLegalRoute extends PageRouteInfo<void> {
  const AskLegalRoute({List<PageRouteInfo>? children})
    : super(AskLegalRoute.name, initialChildren: children);

  static const String name = 'AskLegalRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LegalDrafter]
class LaborRoute extends PageRouteInfo<void> {
  const LaborRoute({List<PageRouteInfo>? children})
    : super(LaborRoute.name, initialChildren: children);

  static const String name = 'LaborRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LandingPage]
class LandingRoute extends PageRouteInfo<void> {
  const LandingRoute({List<PageRouteInfo>? children})
    : super(LandingRoute.name, initialChildren: children);

  static const String name = 'LandingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GetDocuments]
class TrafficRoute extends PageRouteInfo<void> {
  const TrafficRoute({List<PageRouteInfo>? children})
    : super(TrafficRoute.name, initialChildren: children);

  static const String name = 'TrafficRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
