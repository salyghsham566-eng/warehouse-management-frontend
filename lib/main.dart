import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/api_client.dart';

import 'package:project_2/Features/auth/data/auth_repository.dart';
import 'package:project_2/Features/auth/bloc/login_bloc.dart';
import 'package:project_2/Home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient();
  final authRepository = AuthRepository(apiClient);

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>.value(
      value: authRepository,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sales Representative',
        theme: ThemeData(useMaterial3: true, fontFamily: 'Arial'),
        home: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(context.read<AuthRepository>()),
          child: const HomeScreen2(),
        ),
      ),
    );
  }
}
