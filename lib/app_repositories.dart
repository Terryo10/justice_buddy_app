import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:justice_buddy/repositories/categories_repository/category_provider.dart';

import 'repositories/categories_repository/category_repository.dart';
import 'repositories/law_info_repository/law_info_provider.dart'
    show LawInfoItemProvider;
import 'repositories/law_info_repository/law_info_repository.dart';
import 'repositories/lawyer_repository/lawyer_provider.dart';
import 'repositories/lawyer_repository/lawyer_repository.dart';
import 'repositories/letter_repository/letter_provider.dart';
import 'repositories/letter_repository/letter_repository.dart';
import 'repositories/chat_repository/chat_provider.dart';
import 'repositories/chat_repository/chat_repository.dart';
import 'repositories/theme_repository/theme_repository.dart';
import 'repositories/document_repository/document_provider.dart';
import 'repositories/document_repository/document_repository.dart';
import 'services/device_id_service.dart';

class AppRepositories extends StatelessWidget {
  final Widget appBlocs;
  final FlutterSecureStorage storage;

  const AppRepositories({
    super.key,
    required this.appBlocs,
    required this.storage,
  });

  @override
  Widget build(BuildContext context) {
    // Create the DeviceIdService instance once
    final deviceIdService = DeviceIdService(storage: storage);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => CategoryRepository(provider: CategoryProvider()),
        ),
        RepositoryProvider(
          create:
              (context) =>
                  LawInfoItemRepository(provider: LawInfoItemProvider()),
        ),
        RepositoryProvider(
          create: (context) => LawyerRepository(provider: LawyerProvider()),
        ),
        RepositoryProvider.value(value: deviceIdService),
        RepositoryProvider(
          create:
              (context) => LetterRepository(
                provider: LetterProvider(),
                deviceIdService: deviceIdService,
              ),
        ),
        RepositoryProvider(
          create:
              (context) => ChatRepository(
                provider: ChatProvider(),
                secureStorage: storage,
              ),
        ),
        RepositoryProvider(
          create: (context) => ThemeRepository(storage: storage),
        ),
        RepositoryProvider(
          create:
              (context) =>
                  DocumentRepository(documentProvider: DocumentProvider()),
        ),
      ],
      child: appBlocs,
    );
  }
}
