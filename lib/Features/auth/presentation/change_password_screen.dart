import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/change_password_bloc.dart';
import 'package:project_2/Features/auth/bloc/change_password_event.dart';
import 'package:project_2/Features/auth/bloc/change_password_state.dart';

class ChangePasswordScreen
    extends StatefulWidget {
  const ChangePasswordScreen({
    super.key,
  });

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {
  final _formKey =
      GlobalKey<FormState>();

  final _currentController =
      TextEditingController();

  final _newController =
      TextEditingController();

  final _confirmController =
      TextEditingController();

  bool _hideCurrent = true;
  bool _hideNew = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();

    super.dispose();
  }

  bool _isStrongPassword(
    String value,
  ) {
    return value.length >= 8 &&
        RegExp(r'[A-Z]')
            .hasMatch(value) &&
        RegExp(r'[a-z]')
            .hasMatch(value) &&
        RegExp(r'[0-9]')
            .hasMatch(value) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=]')
            .hasMatch(value);
  }

  void _submit(
    BuildContext context,
  ) {
    FocusScope.of(context)
        .unfocus();

    if (!(
      _formKey.currentState
              ?.validate() ??
          false
    )) {
      return;
    }

    context
        .read<ChangePasswordBloc>()
        .add(
          ChangePasswordSubmitted(
            currentPassword:
                _currentController
                    .text,
            newPassword:
                _newController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<
        ChangePasswordBloc>(
      create: (_) =>
          sl<ChangePasswordBloc>(),
      child: Directionality(
        textDirection:
            TextDirection.rtl,
        child: Scaffold(
          backgroundColor:
              AppColors.background,
          appBar: AppBar(
            backgroundColor:
                Colors.white,
            surfaceTintColor:
                Colors.white,
            foregroundColor:
                AppColors.primary,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'تغيير كلمة المرور',
              style: TextStyle(
                color:
                    AppColors.textPrimary,
                fontSize: 20,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
          body: BlocConsumer<
              ChangePasswordBloc,
              ChangePasswordState>(
            listener:
                (context, state) {
              if (state
                  is ChangePasswordSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                    ),
                  ),
                );

                Navigator.pop(context);
              }

              if (state
                  is ChangePasswordFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                    ),
                    backgroundColor:
                        AppColors.danger,
                  ),
                );
              }
            },
            builder:
                (context, state) {
              final isLoading =
                  state
                      is ChangePasswordLoading;

              return Form(
                key: _formKey,
                child: ListView(
                  padding:
                      const EdgeInsets
                          .fromLTRB(
                    16,
                    18,
                    16,
                    28,
                  ),
                  children: [
                    Container(
                      padding:
                          const EdgeInsets
                              .all(18),
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,
                        borderRadius:
                            BorderRadius
                                .circular(20),
                        border:
                            Border.all(
                          color:
                              AppColors
                                  .border,
                        ),
                      ),
                      child: const Row(
                        children: [
                          _SecurityIcon(),
                          SizedBox(
                            width: 14,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  'حماية الحساب',
                                  style:
                                      TextStyle(
                                    color:
                                        AppColors
                                            .textPrimary,
                                    fontSize:
                                        17,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'أدخل كلمة المرور الحالية ثم اختر كلمة مرور جديدة قوية.',
                                  style:
                                      TextStyle(
                                    color:
                                        AppColors
                                            .textSecondary,
                                    fontSize:
                                        12.5,
                                    height:
                                        1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    Container(
                      padding:
                          const EdgeInsets
                              .all(15),
                      decoration:
                          BoxDecoration(
                        color:
                            AppColors
                                .primarySoft,
                        borderRadius:
                            BorderRadius
                                .circular(14),
                      ),
                      child:
                          const Text(
                        'كلمة المرور الجديدة يجب أن تكون 8 محارف على الأقل، وتحتوي على حرف كبير وحرف صغير ورقم ورمز خاص.',
                        style:
                            TextStyle(
                          color:
                              AppColors
                                  .textPrimary,
                          fontSize:
                              12.5,
                          height:
                              1.55,
                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    TextFormField(
                      controller:
                          _currentController,
                      obscureText:
                          _hideCurrent,
                      enabled:
                          !isLoading,
                      decoration:
                          _passwordDecoration(
                        label:
                            'كلمة المرور الحالية',
                        hidden:
                            _hideCurrent,
                        onToggle: () {
                          setState(() {
                            _hideCurrent =
                                !_hideCurrent;
                          });
                        },
                      ),
                      validator:
                          (value) {
                        if (value ==
                                null ||
                            value
                                .isEmpty) {
                          return 'يرجى إدخال كلمة المرور الحالية';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    TextFormField(
                      controller:
                          _newController,
                      obscureText:
                          _hideNew,
                      enabled:
                          !isLoading,
                      decoration:
                          _passwordDecoration(
                        label:
                            'كلمة المرور الجديدة',
                        hidden:
                            _hideNew,
                        onToggle: () {
                          setState(() {
                            _hideNew =
                                !_hideNew;
                          });
                        },
                      ),
                      validator:
                          (value) {
                        final text =
                            value ??
                                '';

                        if (text
                            .isEmpty) {
                          return 'يرجى إدخال كلمة المرور الجديدة';
                        }

                        if (!_isStrongPassword(
                          text,
                        )) {
                          return 'كلمة المرور لا تحقق شروط القوة';
                        }

                        if (text ==
                            _currentController
                                .text) {
                          return 'كلمة المرور الجديدة يجب أن تختلف عن الحالية';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    TextFormField(
                      controller:
                          _confirmController,
                      obscureText:
                          _hideConfirm,
                      enabled:
                          !isLoading,
                      decoration:
                          _passwordDecoration(
                        label:
                            'تأكيد كلمة المرور الجديدة',
                        hidden:
                            _hideConfirm,
                        onToggle: () {
                          setState(() {
                            _hideConfirm =
                                !_hideConfirm;
                          });
                        },
                      ),
                      validator:
                          (value) {
                        if (value !=
                            _newController
                                .text) {
                          return 'تأكيد كلمة المرور غير مطابق';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    SizedBox(
                      height: 52,
                      child:
                          ElevatedButton.icon(
                        onPressed:
                            isLoading
                                ? null
                                : () =>
                                    _submit(
                                      context,
                                    ),
                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              AppColors
                                  .primary,
                          foregroundColor:
                              Colors.white,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              15,
                            ),
                          ),
                        ),
                        icon: isLoading
                            ? const SizedBox(
                                width:
                                    20,
                                height:
                                    20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      2,
                                  color:
                                      Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons
                                    .lock_reset_rounded,
                              ),
                        label: Text(
                          isLoading
                              ? 'جاري التغيير...'
                              : 'تغيير كلمة المرور',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  InputDecoration _passwordDecoration({
    required String label,
    required bool hidden,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon:
          const Icon(
        Icons.lock_outline_rounded,
      ),
      suffixIcon:
          IconButton(
        onPressed: onToggle,
        icon: Icon(
          hidden
              ? Icons
                  .visibility_outlined
              : Icons
                  .visibility_off_outlined,
        ),
      ),
      filled: true,
      fillColor: Colors.white,
      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          14,
        ),
        borderSide:
            const BorderSide(
          color:
              AppColors.border,
        ),
      ),
    );
  }
}

class _SecurityIcon
    extends StatelessWidget {
  const _SecurityIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration:
          BoxDecoration(
        color:
            AppColors.primarySoft,
        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),
      child: const Icon(
        Icons.security_rounded,
        color:
            AppColors.primary,
        size: 29,
      ),
    );
  }
}
