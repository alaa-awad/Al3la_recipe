import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/app_theme.dart';
import 'core/bloc_observer.dart';
import 'core/dio/cache_helper.dart';
import 'core/injection_container.dart' as di;
import 'core/localization/app_local.dart';
import 'core/var.dart';
import 'core/widget/decision_home_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/category/presentation/cubit/category_cubit.dart';
import 'features/category/presentation/pages/category_page.dart';
import 'features/meal/presentation/cubit/meal_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await CacheHelper.init();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  decisionHomeScreen();
  print("Locale(_languageCode) ${Platform.localeName.characters}");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) =>
                di.sl<CategoryCubit>()..getCategoryCubit()),
        BlocProvider(create: (BuildContext context) => di.sl<MealCubit>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        supportedLocales: const [
          Locale('en', ''),
          Locale('ar', ''),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocale.delegate,
        ],
        localeResolutionCallback: (currentLocale, supportedLocale) {
          if (currentLocale != null) {
            for (Locale locale in supportedLocale) {
              if (currentLocale.languageCode == locale.languageCode) {
                return currentLocale;
              }
            }
          }
          return supportedLocale.first;
          //
        },
        locale: const Locale("ar", ''),
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: home,
      ),
    );
  }
}
