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
import 'repositories/theme_repository/theme_repository.dart';

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
        RepositoryProvider(
          create: (context) => LetterRepository(provider: LetterProvider()),
        ),
        RepositoryProvider(
          create: (context) => ThemeRepository(storage: storage),
        ),
      ],
      child: appBlocs,
    );
  }
}
