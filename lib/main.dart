import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:justice_buddy/app_blocs.dart';
import 'package:justice_buddy/app_repositories.dart';
import 'package:justice_buddy/blocs/theme_bloc/theme_bloc.dart';
import 'package:justice_buddy/constants/app_theme.dart';
import 'package:justice_buddy/routes/app_router.dart';

void main() {
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  runApp(
    AppRepositories(
      storage: secureStorage,
      appBlocs: AppBlocs(app: JusticeBuddy()),
    ),
  );
}

class JusticeBuddy extends StatelessWidget {
  const JusticeBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Justice Buddy',
          routerConfig: AppRouter().config(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
