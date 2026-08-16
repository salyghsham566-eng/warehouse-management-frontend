import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/profile_bloc.dart';
import 'package:project_2/Features/auth/bloc/profile_event.dart';
import 'package:project_2/Features/auth/bloc/profile_state.dart';

import 'package:project_2/Features/auth/data/models/profile_model.dart';
import 'package:project_2/Features/auth/presentation/change_password_screen.dart';

class ProfilePage
    extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {
  final _formKey =
      GlobalKey<FormState>();

  final _imagePicker =
      ImagePicker();

  late final TextEditingController
      _phoneController;

  late final TextEditingController
      _emailController;

  Uint8List? _selectedImageBytes;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    _phoneController =
        TextEditingController();

    _emailController =
        TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  void _sync(
    ProfileModel profile, {
    bool force = false,
  }) {
    if (_initialized &&
        !force) {
      return;
    }

    _phoneController.text =
        profile.phone;

    _emailController.text =
        profile.email;

    _selectedImageBytes =
        profile.imageBytes;

    _initialized = true;
  }

  Future<void> _pickImage() async {
    try {
      final image =
          await _imagePicker.pickImage(
        source:
            ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (image == null) {
        return;
      }

      final bytes =
          await image.readAsBytes();

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedImageBytes =
            bytes;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر اختيار صورة الحساب',
          ),
        ),
      );
    }
  }

  void _save() {
    if (!(
      _formKey.currentState
              ?.validate() ??
          false
    )) {
      return;
    }

    context
        .read<ProfileBloc>()
        .add(
          ProfileUpdateRequested(
            phone:
                _phoneController
                    .text
                    .trim(),

            email:
                _emailController
                    .text
                    .trim(),

            imageBytes:
                _selectedImageBytes,
          ),
        );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Directionality(
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

          centerTitle: true,

          title: const Text(
            'إدارة الحساب',

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
            ProfileBloc,
            ProfileState>(
          listener:
              (context, state) {
            if (state
                is ProfileSaveSuccess) {
              _sync(
                state.profile,
                force: true,
              );

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                  ),
                ),
              );
            }

            if (state
                is ProfileError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                  ),
                ),
              );
            }
          },

          builder:
              (context, state) {
            if (state
                    is ProfileInitial ||
                state
                    is ProfileLoading) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            ProfileModel? profile;

            bool saving = false;

            if (state
                is ProfileLoaded) {
              profile =
                  state.profile;
            }

            if (state
                is ProfileSaving) {
              profile =
                  state.profile;

              saving = true;
            }

            if (state
                is ProfileSaveSuccess) {
              profile =
                  state.profile;
            }

            if (state
                is ProfileError) {
              profile =
                  state.profile;
            }

            if (profile == null) {
              return Center(
                child:
                    ElevatedButton.icon(
                  onPressed: () {
                    context
                        .read<
                            ProfileBloc>()
                        .add(
                          ProfileRequested(),
                        );
                  },

                  icon:
                      const Icon(
                    Icons.refresh,
                  ),

                  label:
                      const Text(
                    'إعادة المحاولة',
                  ),
                ),
              );
            }

            _sync(profile);

            return Form(
              key: _formKey,

              child: ListView(
                padding:
                    const EdgeInsets
                        .fromLTRB(
                  16,
                  16,
                  16,
                  30,
                ),

                children: [
                  _buildHeader(
                    profile,
                    saving,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  _buildNotice(),

                  const SizedBox(
                    height: 20,
                  ),

                  _buildTitle(
                    'الملف الشخصي',
                    Icons
                        .badge_outlined,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  _buildCard(
                    [
                      _buildInfoRow(
                        'الاسم',
                        profile.fullName,
                        Icons
                            .person_outline,
                      ),

                      _divider(),

                      _buildInfoRow(
                        'كود المندوب',
                        profile
                            .representativeCode,
                        Icons
                            .qr_code_2,
                      ),

                      _divider(),

                      _buildInfoRow(
                        'الدور',
                        profile.role,
                        Icons
                            .manage_accounts_outlined,
                      ),

                      _divider(),

                      _buildStatusRow(
                        profile
                            .accountStatus,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  _buildTitle(
                    'بيانات التواصل',
                    Icons
                        .contact_phone_outlined,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  _buildContactCard(
                    profile,
                    saving,
                  ),
const SizedBox(
  height: 20,
),

_buildTitle(
  'إعدادات الحساب',
  Icons.settings_outlined,
),

const SizedBox(
  height: 10,
),

Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius:
        BorderRadius.circular(18),
    border: Border.all(
      color: AppColors.border,
    ),
  ),
  child: ListTile(
    leading: Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color:
            AppColors.primarySoft,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.lock_reset_rounded,
        color: AppColors.primary,
      ),
    ),
    title: const Text(
      'تغيير كلمة المرور',
      style: TextStyle(
        color:
            AppColors.textPrimary,
        fontWeight:
            FontWeight.w700,
      ),
    ),
    subtitle: const Text(
      'تحديث كلمة مرور الحساب',
    ),
    trailing: const Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16,
      color:
          AppColors.textSecondary,
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const ChangePasswordScreen(),
        ),
      );
    },
  ),
),
                  const SizedBox(
                    height: 20,
                  ),

                  _buildTitle(
                    'المناطق المرتبطة',
                    Icons
                        .map_outlined,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  _buildRegionsCard(
                    profile
                        .linkedRegions,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  _buildTitle(
                    'الصلاحيات المختصرة',
                    Icons
                        .verified_user_outlined,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  _buildPermissionsCard(
                    profile.permissions,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  SizedBox(
                    height: 52,

                    child:
                        ElevatedButton.icon(
                      onPressed:
                          saving
                              ? null
                              : _save,

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

                      icon: saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
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
                                  .save_outlined,
                            ),

                      label: Text(
                        saving
                            ? 'جاري الحفظ...'
                            : 'حفظ بيانات التواصل',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    ProfileModel profile,
    bool saving,
  ) {
    final bytes =
        _selectedImageBytes ??
        profile.imageBytes;

    ImageProvider? image;

    if (bytes != null &&
        bytes.isNotEmpty) {
      image =
          MemoryImage(bytes);
    } else if (
        profile.imageUrl
                ?.trim()
                .isNotEmpty ==
            true) {
      image =
          NetworkImage(
        profile.imageUrl!,
      );
    }

    return Container(
      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          begin:
              Alignment.topRight,

          end:
              Alignment.bottomLeft,

          colors: [
            Color(
              0xFF12355B,
            ),
            Color(
              0xFF1F5C8F,
            ),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Row(
        children: [
          Stack(
            clipBehavior:
                Clip.none,

            children: [
              CircleAvatar(
                radius: 39,

                backgroundColor:
                    Colors.white,

                backgroundImage:
                    image,

                child: image == null
                    ? const Icon(
                        Icons.person,
                        size: 44,
                        color:
                            AppColors
                                .primary,
                      )
                    : null,
              ),

              Positioned(
                left: -5,
                bottom: -5,

                child: Material(
                  color:
                      Colors.white,

                  shape:
                      const CircleBorder(),

                  child:
                      IconButton(
                    onPressed:
                        saving
                            ? null
                            : _pickImage,

                    icon:
                        const Icon(
                      Icons
                          .camera_alt_outlined,

                      color:
                          AppColors
                              .primary,

                      size: 19,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            width: 16,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  profile.fullName,

                  style:
                      const TextStyle(
                    color:
                        Colors.white,

                    fontSize: 19,

                    fontWeight:
                        FontWeight
                            .w800,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  '${profile.role} • '
                  '${profile.representativeCode}',

                  style:
                      const TextStyle(
                    color:
                        Color(
                      0xFFD8E5F2,
                    ),

                    fontSize:
                        12.5,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  profile
                      .accountStatus,

                  style:
                      const TextStyle(
                    color:
                        Colors.white,

                    fontSize:
                        11.5,

                    fontWeight:
                        FontWeight
                            .w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotice() {
    return Container(
      padding:
          const EdgeInsets.all(
        13,
      ),

      decoration:
          BoxDecoration(
        color:
            AppColors.primarySoft,

        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),

      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [
          Icon(
            Icons
                .info_outline,

            color:
                AppColors.primary,

            size: 20,
          ),

          SizedBox(
            width: 9,
          ),

          Expanded(
            child: Text(
              'يمكن تعديل رقم الهاتف والبريد الإلكتروني '
              'وصورة الحساب فقط. الاسم والكود والدور '
              'والمناطق والصلاحيات للقراءة فقط.',

              style: TextStyle(
                color:
                    AppColors
                        .textPrimary,

                fontSize:
                    12.5,

                height: 1.5,

                fontWeight:
                    FontWeight
                        .w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(
    String text,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color:
              AppColors.primary,
          size: 21,
        ),

        const SizedBox(
          width: 7,
        ),

        Text(
          text,

          style:
              const TextStyle(
            color:
                AppColors
                    .textPrimary,

            fontSize: 17,

            fontWeight:
                FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(
    List<Widget> children,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 3,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border: Border.all(
          color:
              AppColors.border,
        ),
      ),

      child:
          Column(
        children:
            children,
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 13,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [
          Icon(
            icon,
            color:
                AppColors.primary,
            size: 21,
          ),

          const SizedBox(
            width: 10,
          ),

          SizedBox(
            width: 105,

            child: Text(
              label,

              style:
                  const TextStyle(
                color:
                    AppColors
                        .textSecondary,

                fontSize:
                    12.5,

                fontWeight:
                    FontWeight
                        .w600,
              ),
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          Expanded(
            child: Text(
              value
                      .trim()
                      .isEmpty
                  ? 'غير محدد'
                  : value,

              textAlign:
                  TextAlign.left,

              style:
                  const TextStyle(
                color:
                    AppColors
                        .textPrimary,

                fontSize:
                    13.5,

                fontWeight:
                    FontWeight
                        .w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(
    String status,
  ) {
    final bool active =
        status.contains(
      'فعال',
    );

    final Color color =
        active
            ? AppColors
                .success
            : AppColors
                .warning;

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 13,
      ),

      child: Row(
        children: [
          const Icon(
            Icons
                .verified_user_outlined,

            color:
                AppColors.primary,

            size: 21,
          ),

          const SizedBox(
            width: 10,
          ),

          const SizedBox(
            width: 105,

            child: Text(
              'حالة الحساب',

              style:
                  TextStyle(
                color:
                    AppColors
                        .textSecondary,

                fontSize:
                    12.5,

                fontWeight:
                    FontWeight
                        .w600,
              ),
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          Container(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            decoration:
                BoxDecoration(
              color:
                  color.withOpacity(
                0.10,
              ),

              borderRadius:
                  BorderRadius
                      .circular(
                10,
              ),
            ),

            child: Text(
              status,

              style: TextStyle(
                color: color,

                fontSize: 12,

                fontWeight:
                    FontWeight
                        .w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    ProfileModel profile,
    bool saving,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        15,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border: Border.all(
          color:
              AppColors.border,
        ),
      ),

      child: Column(
        children: [
          TextFormField(
            controller:
                _phoneController,

            enabled:
                !saving,

            keyboardType:
                TextInputType
                    .phone,

            decoration:
                _inputDecoration(
              'رقم الهاتف',
              Icons
                  .phone_outlined,
            ),

            validator:
                (value) {
              final text =
                  value?.trim() ??
                  '';

              if (text.isEmpty) {
                return 'يرجى إدخال رقم الهاتف';
              }

              if (text.length <
                  8) {
                return 'رقم الهاتف غير صحيح';
              }

              return null;
            },
          ),

          const SizedBox(
            height: 12,
          ),

          TextFormField(
            controller:
                _emailController,

            enabled:
                !saving,

            keyboardType:
                TextInputType
                    .emailAddress,

            decoration:
                _inputDecoration(
              'البريد الإلكتروني',
              Icons
                  .email_outlined,
            ),

            validator:
                (value) {
              final text =
                  value?.trim() ??
                  '';

              if (text.isEmpty) {
                return 'يرجى إدخال البريد الإلكتروني';
              }

              if (!RegExp(
                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
              ).hasMatch(text)) {
                return 'البريد الإلكتروني غير صحيح';
              }

              return null;
            },
          ),

          const SizedBox(
            height: 12,
          ),

          _buildReadOnlyBox(
            'العنوان',
            profile.address,
            Icons
                .home_outlined,
          ),
        ],
      ),
    );
  }

  InputDecoration
      _inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,

      prefixIcon:
          Icon(icon),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),
    );
  }

  Widget _buildReadOnlyBox(
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        13,
      ),

      decoration:
          BoxDecoration(
        color:
            AppColors.background,

        borderRadius:
            BorderRadius.circular(
          14,
        ),

        border: Border.all(
          color:
              AppColors.border,
        ),
      ),

      child: Row(
        children: [
          Icon(
            icon,
            color:
                AppColors
                    .textSecondary,
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  label,

                  style:
                      const TextStyle(
                    color:
                        AppColors
                            .textSecondary,

                    fontSize:
                        11.5,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  value
                          .trim()
                          .isEmpty
                      ? 'غير متوفر'
                      : value,

                  style:
                      const TextStyle(
                    color:
                        AppColors
                            .textPrimary,

                    fontSize:
                        13,

                    fontWeight:
                        FontWeight
                            .w700,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons
                .lock_outline,

            color:
                AppColors
                    .textSecondary,

            size: 17,
          ),
        ],
      ),
    );
  }

  Widget _buildRegionsCard(
    List<ProfileRegionModel>
        regions,
  ) {
    if (regions.isEmpty) {
      return _buildEmptyCard(
        'لا توجد مناطق مرتبطة بالحساب',
      );
    }

    return Container(
      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border: Border.all(
          color:
              AppColors.border,
        ),
      ),

      child: Column(
        children:
            List.generate(
          regions.length,
          (index) {
            final region =
                regions[index];

            return Column(
              children: [
                ListTile(
                  leading:
                      const Icon(
                    Icons
                        .location_on_outlined,

                    color:
                        AppColors
                            .primary,
                  ),

                  title: Text(
                    region.name,
                  ),

                  subtitle:
                      Text(
                    region.pharmaciesCount ==
                            null
                        ? 'عدد الصيدليات غير متوفر'
                        : '${region.pharmaciesCount} صيدلية',
                  ),

                  trailing:
                      const Icon(
                    Icons
                        .lock_outline,

                    size: 18,
                  ),
                ),

                if (index !=
                    regions.length -
                        1)
                  _divider(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPermissionsCard(
    List<String> permissions,
  ) {
    if (permissions.isEmpty) {
      return _buildEmptyCard(
        'لا توجد صلاحيات متاحة للعرض',
      );
    }

    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        15,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border: Border.all(
          color:
              AppColors.border,
        ),
      ),

      child: Wrap(
        spacing: 8,
        runSpacing: 8,

        children:
            permissions
                .map(
                  (
                    permission,
                  ) =>
                      Chip(
                    avatar:
                        const Icon(
                      Icons
                          .check_circle_outline,

                      size: 17,

                      color:
                          AppColors
                              .success,
                    ),

                    label:
                        Text(
                      permission,
                    ),

                    backgroundColor:
                        AppColors
                            .successSoft,

                    side:
                        BorderSide
                            .none,
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildEmptyCard(
    String text,
  ) {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        20,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border: Border.all(
          color:
              AppColors.border,
        ),
      ),

      child: Text(
        text,
        textAlign:
            TextAlign.center,
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      color:
          AppColors.border,
    );
  }
}