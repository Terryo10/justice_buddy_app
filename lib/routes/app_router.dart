import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/landing_page.dart';
import '../ui/pages/get_documents_page.dart';
import '../ui/pages/law_info_item_detail_page.dart';
import '../ui/lawyer_directory/lawyers_page.dart';
import '../ui/lawyer_directory/lawyer_detail_page.dart';
import '../ui/letter_generator/letter_templates_page.dart';
import '../ui/letter_generator/letter_form_page.dart';
import '../ui/letter_generator/letter_result_page.dart';
import '../ui/letter_generator/letter_history_page.dart';
import '../ui/letter_generator/letter_enhancement_page.dart';
import '../ui/chat/chat_page.dart';

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
        AutoRoute(page: ChatRoute.page, path: 'chat'),
        AutoRoute(page: LetterTemplatesRoute.page, path: 'letter-generator'),
        AutoRoute(page: GetDocumentsRoute.page, path: 'get-documents'),
      ],
    ),
    // Law info item detail page
    AutoRoute(page: LawInfoItemDetailRoute.page, path: '/law-info/:slug'),
    // Lawyer pages - separate from tab structure
    AutoRoute(page: LawyersRoute.page, path: '/lawyers'),
    AutoRoute(page: LawyerDetailRoute.page, path: '/lawyers/:slug'),

    // Letter generation pages
    AutoRoute(page: LetterTemplatesRoute.page, path: '/letter-templates'),
    AutoRoute(page: LetterFormRoute.page, path: '/letter-form/:templateId'),
    AutoRoute(page: LetterResultRoute.page, path: '/letter-result/:requestId'),
    AutoRoute(page: LetterHistoryRoute.page, path: '/letter-history'),
    AutoRoute(
      page: LetterEnhancementRoute.page,
      path: '/letter-enhance/:requestId',
    ),
  ];
}
