
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/login_bloc.dart';
import 'package:project_2/Features/auth/bloc/login_event.dart';
import 'package:project_2/Features/auth/bloc/login_state.dart';
import 'package:project_2/Home_screen.dart';

class RepresentativeLoginScreen extends StatefulWidget {
  const RepresentativeLoginScreen({super.key});

  @override
  State<RepresentativeLoginScreen> createState() =>
      _RepresentativeLoginScreenState();
}

class _RepresentativeLoginScreenState extends State<RepresentativeLoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  static const navy = Color(0xff062B56);
  static const grayText = Color(0xff7A8494);
  static const orange = Color(0xffF5A623);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight:
                              MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.vertical,
                        ),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 105,
                                  decoration: const BoxDecoration(
                                    color: navy,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(90),
                                      bottomRight: Radius.circular(90),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -42,
                                  child: Container(
                                    height: 86,
                                    width: 86,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.12),
                                          blurRadius: 18,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const Icon(
                                          Icons.delivery_dining,
                                          color: navy,
                                          size: 42,
                                        ),
                                        Positioned(
                                          right: 16,
                                          bottom: 18,
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: const BoxDecoration(
                                              color: orange,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.verified_user,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 62),

                            const Text(
                              "مرحباً بك",
                              style: TextStyle(
                                color: navy,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              "تسجيل دخول المندوب",
                              style: TextStyle(
                                color: grayText,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 38),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "اسم المستخدم أو رقم الهاتف",
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  _LoginField(
                                    controller: usernameController,
                                    hint: "أدخل اسم المستخدم أو رقم الهاتف",
                                    icon: Icons.person_outline,
                                  ),

                                  const SizedBox(height: 22),

                                  const Text(
                                    "كلمة المرور",
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  _LoginField(
                                    controller: passwordController,
                                    hint: "أدخل كلمة المرور",
                                    icon: Icons.lock_outline,
                                    obscureText: obscurePassword,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                        });
                                      },
                                      icon: Icon(
                                        obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: navy,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: AlertDialog(
                                                title: const Row(
                                                  children: [
                                                    Icon(Icons.info_outline),
                                                    SizedBox(width: 8),
                                                    Text("نسيت كلمة المرور"),
                                                  ],
                                                ),
                                                content: const Text(
                                                  "للاستعلام عن كلمة المرور أو إعادة تعيينها، "
                                                  "يرجى التواصل مع المشرف مباشرةً.",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    height: 1.6,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        dialogContext,
                                                      ).pop();
                                                    },
                                                    child: const Text("حسناً"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                        "نسيت كلمة المرور؟",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 18),

                                  BlocConsumer<LoginBloc, LoginState>(
                                   listener: (context, state) {
  if (state is LoginSuccess) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const HomeScreen2(),
      ),
      (route) => false,
    );
  }

  if (state is LoginFailure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.message),
      ),
    );
  }
},
                                    builder: (context, state) {
                                      return SizedBox(
                                        width: double.infinity,
                                        height: 58,
                                        child: ElevatedButton.icon(
                                          onPressed: state is LoginLoading
                                              ? null
                                              : () {
                                                  context.read<LoginBloc>().add(
                                                    LoginSubmitted(
                                                      usernameOrPhone:
                                                          usernameController
                                                              .text
                                                              .trim(),
                                                      password:
                                                          passwordController
                                                              .text
                                                              .trim(),
                                                    ),
                                                  );
                                                },
                                          icon: state is LoginLoading
                                              ? const SizedBox(
                                                  width: 22,
                                                  height: 22,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : const Icon(
                                                  Icons.login,
                                                  size: 26,
                                                ),
                                          label: Text(
                                            state is LoginLoading
                                                ? "جاري تسجيل الدخول..."
                                                : "تسجيل الدخول",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: navy,
                                            foregroundColor: Colors.white,
                                            elevation: 8,
                                            shadowColor: navy.withOpacity(0.35),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: CustomPaint(
                                      painter: CityDeliveryPainter(),
                                    ),
                                  ),

                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            const Text(
                              "الإصدار 1.0.0",
                              style: TextStyle(color: grayText, fontSize: 15),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "جميع الحقوق محفوظة",
                              style: TextStyle(color: grayText, fontSize: 14),
                            ),

                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;

  const _LoginField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xff062B56);

    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: navy, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        prefixIcon: Icon(icon, color: navy),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffD8E0EA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: navy, width: 1.5),
        ),
      ),
    );
  }
}

class CityDeliveryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const navy = Color(0xff062B56);
    const orange = Color(0xffF5A623);

    final cityPaint = Paint()
      ..color = const Color(0xffDCE6F2).withOpacity(0.75);

    final roadPaint = Paint()
      ..color = const Color(0xffE9EFF6)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;

    final dashedPaint = Paint()
      ..color = navy.withOpacity(0.8)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final pinPaint = Paint()..color = navy.withOpacity(0.85);
    final orangePaint = Paint()..color = orange;

    final baseY = size.height * 0.72;

    for (int i = 0; i < 10; i++) {
      final x = i * size.width / 9;
      final h = 25.0 + (i % 3) * 16;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, baseY - h, 18, h),
          const Radius.circular(2),
        ),
        cityPaint,
      );
    }

    final road = Path()
      ..moveTo(0, size.height * 0.92)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.62,
        size.width,
        size.height * 0.88,
      );
    canvas.drawPath(road, roadPaint);

    final dashed = Path()
      ..moveTo(size.width * 0.23, size.height * 0.70)
      ..quadraticBezierTo(
        size.width * 0.58,
        size.height * 0.45,
        size.width * 0.87,
        size.height * 0.55,
      );

    _drawDashedPath(canvas, dashed, dashedPaint);

    _drawPin(
      canvas,
      Offset(size.width * 0.52, size.height * 0.42),
      34,
      pinPaint,
      Colors.white,
    );

    _drawPin(
      canvas,
      Offset(size.width * 0.88, size.height * 0.50),
      16,
      orangePaint,
      Colors.white,
    );

    final scooterX = size.width * 0.18;
    final scooterY = size.height * 0.72;

    final bikePaint = Paint()
      ..color = navy.withOpacity(0.9)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(scooterX, scooterY), 8, bikePaint);
    canvas.drawCircle(Offset(scooterX + 32, scooterY), 8, bikePaint);
    canvas.drawLine(
      Offset(scooterX + 8, scooterY),
      Offset(scooterX + 22, scooterY - 15),
      bikePaint,
    );
    canvas.drawLine(
      Offset(scooterX + 22, scooterY - 15),
      Offset(scooterX + 32, scooterY),
      bikePaint,
    );
    canvas.drawLine(
      Offset(scooterX + 22, scooterY - 15),
      Offset(scooterX + 42, scooterY - 15),
      bikePaint,
    );

    final bodyPaint = Paint()..color = navy.withOpacity(0.9);
    canvas.drawCircle(Offset(scooterX + 28, scooterY - 33), 6, bodyPaint);
    canvas.drawLine(
      Offset(scooterX + 27, scooterY - 27),
      Offset(scooterX + 21, scooterY - 14),
      bikePaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(scooterX - 12, scooterY - 35, 14, 18),
        const Radius.circular(2),
      ),
      Paint()..color = navy.withOpacity(0.8),
    );
  }

  void _drawPin(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
    Color innerColor,
  ) {
    final path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..moveTo(center.dx - radius * 0.55, center.dy + radius * 0.35)
      ..quadraticBezierTo(
        center.dx,
        center.dy + radius * 1.65,
        center.dx + radius * 0.55,
        center.dy + radius * 0.35,
      )
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawCircle(center, radius * 0.38, Paint()..color = innerColor);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 6.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
