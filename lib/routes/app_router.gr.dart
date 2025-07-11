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
    LetterFormRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LetterFormRouteArgs>(
          orElse: () =>
              LetterFormRouteArgs(templateId: pathParams.getInt('templateId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LetterFormPage(
          key: args.key,
          templateId: args.templateId,
        ),
      );
    },
    LetterResultRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LetterResultRouteArgs>(
          orElse: () => LetterResultRouteArgs(
              requestId: pathParams.getString('requestId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LetterResultPage(
          key: args.key,
          requestId: args.requestId,
        ),
      );
    },
    LetterTemplatesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LetterTemplatesPage(),
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
/// [LetterFormPage]
class LetterFormRoute extends PageRouteInfo<LetterFormRouteArgs> {
  LetterFormRoute({
    Key? key,
    required int templateId,
    List<PageRouteInfo>? children,
  }) : super(
          LetterFormRoute.name,
          args: LetterFormRouteArgs(
            key: key,
            templateId: templateId,
          ),
          rawPathParams: {'templateId': templateId},
          initialChildren: children,
        );

  static const String name = 'LetterFormRoute';

  static const PageInfo<LetterFormRouteArgs> page =
      PageInfo<LetterFormRouteArgs>(name);
}

class LetterFormRouteArgs {
  const LetterFormRouteArgs({
    this.key,
    required this.templateId,
  });

  final Key? key;

  final int templateId;

  @override
  String toString() {
    return 'LetterFormRouteArgs{key: $key, templateId: $templateId}';
  }
}

/// generated route for
/// [LetterResultPage]
class LetterResultRoute extends PageRouteInfo<LetterResultRouteArgs> {
  LetterResultRoute({
    Key? key,
    required String requestId,
    List<PageRouteInfo>? children,
  }) : super(
          LetterResultRoute.name,
          args: LetterResultRouteArgs(
            key: key,
            requestId: requestId,
          ),
          rawPathParams: {'requestId': requestId},
          initialChildren: children,
        );

  static const String name = 'LetterResultRoute';

  static const PageInfo<LetterResultRouteArgs> page =
      PageInfo<LetterResultRouteArgs>(name);
}

class LetterResultRouteArgs {
  const LetterResultRouteArgs({
    this.key,
    required this.requestId,
  });

  final Key? key;

  final String requestId;

  @override
  String toString() {
    return 'LetterResultRouteArgs{key: $key, requestId: $requestId}';
  }
}

/// generated route for
/// [LetterTemplatesPage]
class LetterTemplatesRoute extends PageRouteInfo<void> {
  const LetterTemplatesRoute({List<PageRouteInfo>? children})
      : super(
          LetterTemplatesRoute.name,
          initialChildren: children,
        );

  static const String name = 'LetterTemplatesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
