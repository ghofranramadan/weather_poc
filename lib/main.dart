import 'package:flutter/material.dart';
import 'core/base/depindancy_injection.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/base/route_generator.dart';
import 'core/common/app_colors/app_colors.dart';
import 'core/util/localization/app_localizations.dart';
import 'core/util/localization/cubit/localization_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../scr/weather/presentation/screens/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LocalizationCubit>()..getSavedLanguage(),
      child: BlocBuilder<LocalizationCubit, LocalizationState>(
        builder: (context, state) {
          if (state is ChangeLanguageState) {
            return ScreenUtilInit(
              designSize: const Size(375, 812),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return MaterialApp(
                  title: "Flutter Weather POC",
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
                    appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
                  locale: state.locale,
                  supportedLocales: const [
                    Locale('en', 'US'),
                    Locale('ar', 'AE'),
                  ],
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    DefaultMaterialLocalizations.delegate,
                    DefaultWidgetsLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (locale, supportedLocales) {
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode ==
                          locale?.languageCode) {
                        return supportedLocale;
                      }
                    }
                    return supportedLocales.first;
                  },
                  onGenerateRoute: RouteGenerator.generatedRoute,
                  initialRoute: WeatherScreen.routeName,
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
