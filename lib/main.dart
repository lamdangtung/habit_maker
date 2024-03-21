import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:habitmaker/blocs/new_habit_cubit.dart';
import 'package:habitmaker/blocs/selected_day_cubit.dart';
import 'package:habitmaker/config/theme_data.dart';
import 'package:habitmaker/models/habit_hive_model.dart';
import 'package:habitmaker/screens/habit_screen.dart';
import 'package:habitmaker/screens/home_screen.dart';
import 'package:habitmaker/screens/login_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HabitHiveAdapter());
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  final _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/habits/new',
        builder: (context, state) => BlocProvider(
            create: (context) => NewHabitCubit(),
            child: const HabitScreen(id: null)),
      ),
      GoRoute(
        path: '/habits/:id',
        builder: (context, state) => BlocProvider(
          create: (context) => NewHabitCubit(),
          child: HabitScreen(
            id: state.pathParameters['id'],
          ),
        ),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectedDayCubit(),
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        darkTheme: darkModeTheme,
        theme: lightModeTheme,
        themeMode: ThemeMode.system,
        supportedLocales: const [
          Locale('en', ''),
          Locale('pl', ''),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Triply',
        builder: (context, child) {
          Locale locale = Localizations.localeOf(context);
          AppLocalizations tr = AppLocalizations.of(context)!;
          final GetIt getIt = GetIt.I;
          if (!getIt.isRegistered<AppLocalizations>()) {
            getIt.registerSingleton<AppLocalizations>(tr);
          }
          if (!getIt.isRegistered<Locale>()) {
            getIt.registerSingleton<Locale>(locale);
          }
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
      ),
    );
  }
}
