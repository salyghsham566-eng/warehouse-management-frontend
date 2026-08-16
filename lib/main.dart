import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/current_order_cart_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/login_bloc.dart';
import 'package:project_2/Features/auth/presentation/LogIn.dart';
import 'package:project_2/Home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  final prefs =
      await SharedPreferences.getInstance();

  final token =
      prefs.getString('token');

  final role =
      prefs.getString('role');

  final bool isLoggedIn =
      token != null &&
      token.isNotEmpty &&
      role == 'representative';

  // إذا في جلسة قديمة، رجّع التوكن لنفس Dio
  if (isLoggedIn) {
    sl<Dio>().options.headers['Authorization'] =
        'Bearer $token';
  }

  runApp(
    MyApp(
      isLoggedIn: isLoggedIn,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrentOrderCartBloc>(
  create: (_) =>
      CurrentOrderCartBloc(),

  
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
      
        locale: const Locale('ar'),
      
        supportedLocales: const [
          Locale('ar'),
          Locale('en'),
        ],
      
        localizationsDelegates:
            GlobalMaterialLocalizations.delegates,
      
        title: 'Sales Representative',
      
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
      
        colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primary,
      surface: Colors.white,
      error: AppColors.danger,
        ),
      
        scaffoldBackgroundColor:
        AppColors.background,
      
        // الأزرار الأساسية
        elevatedButtonTheme:
        ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            AppColors.primary,
        foregroundColor:
            Colors.white,
      ),
        ),
      
        // الأزرار النصية مثل إلغاء
        textButtonTheme:
        TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor:
            AppColors.primary,
      ),
        ),
      
        // التقويم
        datePickerTheme:
        const DatePickerThemeData(
      backgroundColor:
          Colors.white,
      
      headerBackgroundColor:
          AppColors.primary,
      
      headerForegroundColor:
          Colors.white,
      
      todayForegroundColor:
          WidgetStatePropertyAll(
        AppColors.primary,
      ),
      
      todayBorder:
          BorderSide(
        color:
            AppColors.primary,
      ),
      
      dayForegroundColor:
          WidgetStatePropertyAll(
        AppColors.textPrimary,
      ),
        ),
      
        // حقول الإدخال وقت التركيز
        inputDecorationTheme:
        const InputDecorationTheme(
      focusedBorder:
          OutlineInputBorder(
        borderSide:
            BorderSide(
          color:
              AppColors.primary,
          width: 1.4,
        ),
      ),
        ),
      ),
      
        home: isLoggedIn
            ? const HomeScreen2()
            : BlocProvider<LoginBloc>(
                create: (_) => sl<LoginBloc>(),
                child:
                    const RepresentativeLoginScreen(),
              ),
      ),
    );
  }
}