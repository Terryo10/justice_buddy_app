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
    GetDocumentsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GetDocumentsPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    LandingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LandingPage(),
      );
    },
    LawyerDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LawyerDetailRouteArgs>(
          orElse: () =>
              LawyerDetailRouteArgs(slug: pathParams.getString('slug')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LawyerDetailPage(
          key: args.key,
          slug: args.slug,
        ),
      );
    },
    LawyersRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LawyersPage(),
      );
    },
    LegalDrafterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LegalDrafterPage(),
      );
    },
  };
}

/// generated route for
/// [AskLegalPage]
class AskLegalRoute extends PageRouteInfo<void> {
  const AskLegalRoute({List<PageRouteInfo>? children})
      : super(
          AskLegalRoute.name,
          initialChildren: children,
        );

  static const String name = 'AskLegalRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GetDocumentsPage]
class GetDocumentsRoute extends PageRouteInfo<void> {
  const GetDocumentsRoute({List<PageRouteInfo>? children})
      : super(
          GetDocumentsRoute.name,
          initialChildren: children,
        );

  static const String name = 'GetDocumentsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LandingPage]
class LandingRoute extends PageRouteInfo<void> {
  const LandingRoute({List<PageRouteInfo>? children})
      : super(
          LandingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LandingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LawyerDetailPage]
class LawyerDetailRoute extends PageRouteInfo<LawyerDetailRouteArgs> {
  LawyerDetailRoute({
    Key? key,
    required String slug,
    List<PageRouteInfo>? children,
  }) : super(
          LawyerDetailRoute.name,
          args: LawyerDetailRouteArgs(
            key: key,
            slug: slug,
          ),
          rawPathParams: {'slug': slug},
          initialChildren: children,
        );

  static const String name = 'LawyerDetailRoute';

  static const PageInfo<LawyerDetailRouteArgs> page =
      PageInfo<LawyerDetailRouteArgs>(name);
}

class LawyerDetailRouteArgs {
  const LawyerDetailRouteArgs({
    this.key,
    required this.slug,
  });

  final Key? key;

  final String slug;

  @override
  String toString() {
    return 'LawyerDetailRouteArgs{key: $key, slug: $slug}';
  }
}

/// generated route for
/// [LawyersPage]
class LawyersRoute extends PageRouteInfo<void> {
  const LawyersRoute({List<PageRouteInfo>? children})
      : super(
          LawyersRoute.name,
          initialChildren: children,
        );

  static const String name = 'LawyersRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LegalDrafterPage]
class LegalDrafterRoute extends PageRouteInfo<void> {
  const LegalDrafterRoute({List<PageRouteInfo>? children})
      : super(
          LegalDrafterRoute.name,
          initialChildren: children,
        );

  static const String name = 'LegalDrafterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
