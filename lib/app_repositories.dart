import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justice_buddy/repositories/categories_repository/category_provider.dart';

import 'repositories/categories_repository/category_repository.dart';
import 'repositories/law_info_repository/law_info_provider.dart' show LawInfoItemProvider;
import 'repositories/law_info_repository/law_info_repository.dart';

class AppRepositories extends StatelessWidget {
  final Widget appBlocs;

  const AppRepositories({super.key, required this.appBlocs});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => CategoryRepository(provider: CategoryProvider()),
        ),
        RepositoryProvider(
          create: (context) => LawInfoItemRepository(provider: LawInfoItemProvider()),
        ),
      ],
      child: appBlocs,
    );
  }
}