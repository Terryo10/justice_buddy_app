import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/theme_bloc/theme_bloc.dart';
import 'blocs/category_bloc/category_bloc.dart';
import 'blocs/law_info_item_bloc/law_info_item_bloc.dart';
import 'repositories/categories_repository/category_repository.dart';
import 'repositories/law_info_repository/law_info_repository.dart';

class AppBlocs extends StatelessWidget {
  final Widget app;
  const AppBlocs({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(
            categoryRepository: context.read<CategoryRepository>(),
          ),
        ),
        BlocProvider<LawInfoItemBloc>(
          create: (context) => LawInfoItemBloc(
            lawInfoItemRepository: context.read<LawInfoItemRepository>(),
          ),
        ),
      ],
      child: app,
    );
  }
}