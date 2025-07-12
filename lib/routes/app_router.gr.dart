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
    ChatRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChatPage(),
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
    LawInfoItemDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LawInfoItemDetailRouteArgs>(
          orElse: () =>
              LawInfoItemDetailRouteArgs(slug: pathParams.getString('slug')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LawInfoItemDetailPage(
          key: args.key,
          slug: args.slug,
        ),
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
    LetterEnhancementRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LetterEnhancementRouteArgs>(
          orElse: () => LetterEnhancementRouteArgs(
              requestId: pathParams.getString('requestId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LetterEnhancementPage(
          key: args.key,
          requestId: args.requestId,
        ),
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
    LetterHistoryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LetterHistoryPage(),
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
/// [ChatPage]
class ChatRoute extends PageRouteInfo<void> {
  const ChatRoute({List<PageRouteInfo>? children})
      : super(
          ChatRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

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
/// [LawInfoItemDetailPage]
class LawInfoItemDetailRoute extends PageRouteInfo<LawInfoItemDetailRouteArgs> {
  LawInfoItemDetailRoute({
    Key? key,
    required String slug,
    List<PageRouteInfo>? children,
  }) : super(
          LawInfoItemDetailRoute.name,
          args: LawInfoItemDetailRouteArgs(
            key: key,
            slug: slug,
          ),
          rawPathParams: {'slug': slug},
          initialChildren: children,
        );

  static const String name = 'LawInfoItemDetailRoute';

  static const PageInfo<LawInfoItemDetailRouteArgs> page =
      PageInfo<LawInfoItemDetailRouteArgs>(name);
}

class LawInfoItemDetailRouteArgs {
  const LawInfoItemDetailRouteArgs({
    this.key,
    required this.slug,
  });

  final Key? key;

  final String slug;

  @override
  String toString() {
    return 'LawInfoItemDetailRouteArgs{key: $key, slug: $slug}';
  }
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
/// [LetterEnhancementPage]
class LetterEnhancementRoute extends PageRouteInfo<LetterEnhancementRouteArgs> {
  LetterEnhancementRoute({
    Key? key,
    required String requestId,
    List<PageRouteInfo>? children,
  }) : super(
          LetterEnhancementRoute.name,
          args: LetterEnhancementRouteArgs(
            key: key,
            requestId: requestId,
          ),
          rawPathParams: {'requestId': requestId},
          initialChildren: children,
        );

  static const String name = 'LetterEnhancementRoute';

  static const PageInfo<LetterEnhancementRouteArgs> page =
      PageInfo<LetterEnhancementRouteArgs>(name);
}

class LetterEnhancementRouteArgs {
  const LetterEnhancementRouteArgs({
    this.key,
    required this.requestId,
  });

  final Key? key;

  final String requestId;

  @override
  String toString() {
    return 'LetterEnhancementRouteArgs{key: $key, requestId: $requestId}';
  }
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
/// [LetterHistoryPage]
class LetterHistoryRoute extends PageRouteInfo<void> {
  const LetterHistoryRoute({List<PageRouteInfo>? children})
      : super(
          LetterHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'LetterHistoryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
