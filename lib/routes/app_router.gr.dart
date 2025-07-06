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
    LaborRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LaborPage(),
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
        child: const TrafficPage(),
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
/// [LaborPage]
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
/// [TrafficPage]
class TrafficRoute extends PageRouteInfo<void> {
  const TrafficRoute({List<PageRouteInfo>? children})
    : super(TrafficRoute.name, initialChildren: children);

  static const String name = 'TrafficRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
