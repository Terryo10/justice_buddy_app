import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/theme_bloc/theme_bloc.dart';
import 'blocs/category_bloc/category_bloc.dart';
import 'blocs/law_info_item_bloc/law_info_item_bloc.dart';
import 'blocs/lawyer_bloc/lawyer_bloc.dart';
import 'blocs/letter_bloc/letter_bloc.dart';
import 'repositories/categories_repository/category_repository.dart';
import 'repositories/law_info_repository/law_info_repository.dart';
import 'repositories/lawyer_repository/lawyer_repository.dart';
import 'repositories/letter_repository/letter_repository.dart';
import 'repositories/theme_repository/theme_repository.dart';

class AppBlocs extends StatelessWidget {
  final Widget app;
  const AppBlocs({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create:
              (context) =>
                  ThemeBloc(themeRepository: context.read<ThemeRepository>()),
        ),
        BlocProvider<CategoryBloc>(
          create:
              (context) => CategoryBloc(
                categoryRepository: context.read<CategoryRepository>(),
              ),
        ),
        BlocProvider<LawInfoItemBloc>(
          create:
              (context) => LawInfoItemBloc(
                lawInfoItemRepository: context.read<LawInfoItemRepository>(),
              ),
        ),
        BlocProvider<LawyerBloc>(
          create:
              (context) => LawyerBloc(
                lawyerRepository: context.read<LawyerRepository>(),
              ),
        ),
        BlocProvider<LetterBloc>(
          create:
              (context) => LetterBloc(
                letterRepository: context.read<LetterRepository>(),
              ),
        ),
      ],
      child: app,
    );
  }
}
