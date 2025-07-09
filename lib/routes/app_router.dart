import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../ui/pages/ask_legal_page.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/legal_drafter_page.dart';
import '../ui/pages/landing_page.dart';
import '../ui/pages/get_documents_page.dart';
import '../ui/lawyer_directory/lawyers_page.dart';
import '../ui/lawyer_directory/lawyer_detail_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    // Main app with tabs
    AutoRoute(
      path: '/',
      page: LandingRoute.page,
      initial: true,
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home'),
        AutoRoute(page: AskLegalRoute.page, path: 'ask-legal'),
        AutoRoute(page: LegalDrafterRoute.page, path: 'legal-drafter'),
        AutoRoute(page: GetDocumentsRoute.page, path: 'get-documents'),
      ],
    ),
    // Lawyer pages - separate from tab structure
    AutoRoute(page: LawyersRoute.page, path: '/lawyers'),
    AutoRoute(page: LawyerDetailRoute.page, path: '/lawyers/:slug'),
  ];
}
