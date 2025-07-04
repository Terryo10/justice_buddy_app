import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/theme/theme_bloc.dart';

class AppBlocs extends StatelessWidget {
  final Widget app;
  const AppBlocs({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<ThemeBloc>(create: (context) => ThemeBloc())],
      child: app,
    );
  }
}
