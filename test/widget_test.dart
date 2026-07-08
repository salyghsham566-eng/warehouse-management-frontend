// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:project_2/Core/api_client.dart';
import 'package:project_2/Features/auth/data/auth_repository.dart';
import 'package:project_2/Features/auth/presentation/LogIn.dart';
import 'package:project_2/main.dart';

void main() {
  testWidgets('App shows login screen', (WidgetTester tester) async {
    final apiClient = ApiClient();
    final authRepository = AuthRepository(apiClient);

    await tester.pumpWidget(MyApp(authRepository: authRepository));

    expect(find.byType(RepresentativeLoginScreen), findsOneWidget);
  });
}
