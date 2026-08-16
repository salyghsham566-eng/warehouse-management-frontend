import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/current_order_cart_bloc.dart';
import 'package:project_2/Features/auth/bloc/login_bloc.dart';

import 'package:project_2/Features/auth/presentation/LogIn.dart';

import 'package:project_2/Home_screen.dart';

import 'firebase_options.dart';


// ==========================================================
// Firebase Background Notifications
// ==========================================================

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint(
    'FCM Background message: ${message.messageId}',
  );

  debugPrint(
    'FCM Background title: ${message.notification?.title}',
  );

  debugPrint(
    'FCM Background body: ${message.notification?.body}',
  );

  debugPrint(
    'FCM Background data: ${message.data}',
  );
}


// ==========================================================
// Main
// ==========================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ========================================================
  // Firebase Initialization
  // ========================================================

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // استقبال الإشعارات عندما يكون التطبيق بالخلفية
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  final FirebaseMessaging messaging =
      FirebaseMessaging.instance;

  // ========================================================
  // Notification Permission
  // ========================================================

  final NotificationSettings settings =
      await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  debugPrint(
    'Notification permission: '
    '${settings.authorizationStatus}',
  );

  // ========================================================
  // FCM Token
  // ========================================================

  try {
    final String? fcmToken =
        await messaging.getToken();

    debugPrint(
      '================ FCM TOKEN ================',
    );

    debugPrint(
      fcmToken ?? 'FCM Token is null',
    );

    debugPrint(
      '===========================================',
    );
  } catch (e) {
    debugPrint(
      'Error getting FCM token: $e',
    );
  }

  // ========================================================
  // Foreground Notifications
  // التطبيق مفتوح
  // ========================================================

  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      debugPrint(
        '================ FCM FOREGROUND ================',
      );

      debugPrint(
        'Message ID: ${message.messageId}',
      );

      debugPrint(
        'Title: ${message.notification?.title}',
      );

      debugPrint(
        'Body: ${message.notification?.body}',
      );

      debugPrint(
        'Data: ${message.data}',
      );

      debugPrint(
        '================================================',
      );
    },
  );

  // ========================================================
  // عندما المستخدم يضغط على Notification
  // والتطبيق بالخلفية
  // ========================================================

  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) {
      debugPrint(
        'Notification opened from background',
      );

      debugPrint(
        'Title: ${message.notification?.title}',
      );

      debugPrint(
        'Body: ${message.notification?.body}',
      );

      debugPrint(
        'Data: ${message.data}',
      );
    },
  );

  // ========================================================
  // إذا كان التطبيق مغلق بالكامل
  // وتم فتحه من Notification
  // ========================================================

  final RemoteMessage? initialMessage =
      await messaging.getInitialMessage();

  if (initialMessage != null) {
    debugPrint(
      'App opened from terminated state by notification',
    );

    debugPrint(
      'Title: ${initialMessage.notification?.title}',
    );

    debugPrint(
      'Body: ${initialMessage.notification?.body}',
    );

    debugPrint(
      'Data: ${initialMessage.data}',
    );
  }

  // ========================================================
  // Dependency Injection
  // ========================================================

  await initializeDependencies();

  // ========================================================
  // Previous Login Session
  // ========================================================

  final SharedPreferences prefs =
      await SharedPreferences.getInstance();

  final String? authToken =
      prefs.getString('token');

  final String? role =
      prefs.getString('role');

  final bool isLoggedIn =
      authToken != null &&
      authToken.isNotEmpty &&
      role == 'representative';

  // إذا في جلسة قديمة
  // رجع التوكن لنفس Dio
  if (isLoggedIn) {
    sl<Dio>()
            .options
            .headers['Authorization'] =
        'Bearer $authToken';
  }

  // ========================================================
  // Run App
  // ========================================================

  runApp(
    MyApp(
      isLoggedIn: isLoggedIn,
    ),
  );
}


// ==========================================================
// MyApp
// ==========================================================

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<
        CurrentOrderCartBloc>(
      create: (_) =>
          CurrentOrderCartBloc(),

      child: MaterialApp(
        debugShowCheckedModeBanner:
            false,

        // ==================================================
        // Localization
        // ==================================================

        locale: const Locale('ar'),

        supportedLocales: const [
          Locale('ar'),
          Locale('en'),
        ],

        localizationsDelegates:
            GlobalMaterialLocalizations
                .delegates,

        title:
            'Sales Representative',

        // ==================================================
        // Theme
        // ==================================================

        theme: ThemeData(
          useMaterial3: true,

          fontFamily: 'Arial',

          colorScheme:
              const ColorScheme.light(
            primary:
                AppColors.primary,

            secondary:
                AppColors.primary,

            surface:
                Colors.white,

            error:
                AppColors.danger,
          ),

          scaffoldBackgroundColor:
              AppColors.background,

          // ================================================
          // الأزرار الأساسية
          // ================================================

          elevatedButtonTheme:
              ElevatedButtonThemeData(
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primary,

              foregroundColor:
                  Colors.white,
            ),
          ),

          // ================================================
          // الأزرار النصية
          // ================================================

          textButtonTheme:
              TextButtonThemeData(
            style:
                TextButton.styleFrom(
              foregroundColor:
                  AppColors.primary,
            ),
          ),

          // ================================================
          // Date Picker
          // ================================================

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

          // ================================================
          // Input Fields
          // ================================================

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

        // ==================================================
        // Initial Screen
        // ==================================================

        home: isLoggedIn
            ? const HomeScreen2()
            : BlocProvider<LoginBloc>(
                create: (_) =>
                    sl<LoginBloc>(),

                child:
                    const RepresentativeLoginScreen(),
              ),
      ),
    );
  }
}