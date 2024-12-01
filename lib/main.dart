import 'dart:convert';

import 'package:croppy/croppy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/injection.dart' as di;
import '/l10n/l10n.dart';
import '2_application/auth/auth_bloc.dart';
import 'constants.dart';
import 'injection.dart';
import 'routes/router.dart';
import 'themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeSupabase();

  await di.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => sl<AuthBloc>()..add(AuthCheckRequestedEvent()),
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
        debugShowCheckedModeBanner: false,
        title: '4Detailer',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          extensions: [lightCustomColors, woltThemeData],
          navigationBarTheme: lightNavigationBarTheme,
          appBarTheme: lightAppBarTheme,
          textTheme: textTheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          extensions: [darkCustomColors, woltThemeData],
          navigationBarTheme: darkNavigationBarTheme,
          appBarTheme: darkAppBarTheme,
          textTheme: textTheme,
        ),
        supportedLocales: L10n.all,
        // locale: const Locale('de', 'DE'),
        localizationsDelegates: const [
          CroppyLocalizations.delegate,
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          return ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 699, name: MOBILE),
              const Breakpoint(start: 700, end: 1399, name: TABLET),
              const Breakpoint(start: 1400, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          );
        },
      ),
    );
  }
}

Future<void> initializeSupabase() async {
  final configUrl = Uri.parse('https://ldubotykemwtmhfbmupr.supabase.co/functions/v1/getSupabaseConfig');

  try {
    final response = await http.get(configUrl);
    if (response.statusCode == 200) {
      final config = jsonDecode(response.body);

      await Supabase.initialize(
        url: config['SUPABASE_URL'],
        anonKey: config['SUPABASE_ANON_KEY'],
      );
    } else {
      throw Exception('Fehler beim Laden der Supabase-Konfiguration: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    logger.e("Fehler beim Aufruf der Edge Function: $e");
    throw Exception('Fehler beim Laden der Supabase-Konfiguration');
  }
}
