import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/profile_bloc.dart';
import 'package:project_2/Features/auth/bloc/profile_event.dart';
import 'package:project_2/Features/auth/bloc/profile_state.dart';
import 'package:project_2/Features/auth/data/models/profile_model.dart';

class ProfilePage extends StatefulWidget {
  

  const ProfilePage({
    super.key,
  
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _birthDateController;

  final TextEditingController _passwordController =
      TextEditingController();

  late String _selectedGovernorate;

bool _obscurePassword = true;
bool _controllersInitialized = false;

  final List<String> _governorates = [
    "دمشق",
    "ريف دمشق",
    "حلب",
    "حمص",
    "حماة",
    "اللاذقية",
    "طرطوس",
    "درعا",
    "السويداء",
    "القنيطرة",
    "إدلب",
    "دير الزور",
    "الرقة",
    "الحسكة",
  ];

  @override
  void initState() {
    super.initState();

   
  _usernameController = TextEditingController();
  _phoneController = TextEditingController();
  _addressController = TextEditingController();
  _birthDateController = TextEditingController();

  _selectedGovernorate = _governorates.first;
  }
void _fillControllers(ProfileModel profile) {
  if (_controllersInitialized) return;

  _usernameController.text = profile.username;
  _phoneController.text = profile.phone;
  _addressController.text = profile.address;
  _birthDateController.text = profile.birthDate;

  if (_governorates.contains(profile.governorate)) {
    _selectedGovernorate = profile.governorate;
  } else {
    _selectedGovernorate = _governorates.first;
  }

  _controllersInitialized = true;
}
  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

 Future<void> _selectBirthDate() async {
  final DateTime initialDate =
      DateTime.tryParse(_birthDateController.text) ??
      DateTime(2000);

  const appBlue = Color(0xFF12355B);

  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(1940),
    lastDate: DateTime.now(),
    helpText: "اختر تاريخ الميلاد",
    cancelText: "إلغاء",
    confirmText: "اختيار",

    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: appBlue,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: appBlue,
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (selectedDate == null) return;

  setState(() {
    _birthDateController.text =
        "${selectedDate.year}-"
        "${selectedDate.month.toString().padLeft(2, '0')}-"
        "${selectedDate.day.toString().padLeft(2, '0')}";
  });
}
 void _saveProfile() {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  context.read<ProfileBloc>().add(
        ProfileUpdateRequested(
          username: _usernameController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          governorate: _selectedGovernorate,
          birthDate: _birthDateController.text.trim(),
          password: _passwordController.text.trim().isEmpty
              ? null
              : _passwordController.text.trim(),
        ),
      );
}

  void _changeProfileImage() {
    // لاحقاً نضع image_picker هنا.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("سيتم فتح اختيار الصورة هنا"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("الملف الشخصي"),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
  listener: (context, state) {
    if (state is ProfileSaveSuccess) {
      _passwordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
        ),
      );
    }

    if (state is ProfileError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
        ),
      );
    }
  },
  builder: (context, state) {
    if (state is ProfileInitial || state is ProfileLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF12355B),
        ),
      );
    }

    ProfileModel? profile;
    bool isSaving = false;

    if (state is ProfileLoaded) {
      profile = state.profile;
    } else if (state is ProfileSaving) {
      profile = state.profile;
      isSaving = true;
    } else if (state is ProfileSaveSuccess) {
      profile = state.profile;
    } else if (state is ProfileError) {
      profile = state.profile;
    }

    if (profile == null) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<ProfileBloc>().add(
                  ProfileRequested(),
                );
          },
          child: const Text("إعادة المحاولة"),
        ),
      );
    }

    _fillControllers(profile);

    return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildProfileImage(),

                  const SizedBox(height: 25),

                  _buildSectionTitle("البيانات الشخصية"),

                  const SizedBox(height: 15),

                  _buildTextField(
                    controller: _usernameController,
                    label: "اسم المستخدم",
                    icon: Icons.person_outline,
                    enabled:  profile.canEditUsername,
                  ),

                  if (! profile.canEditUsername)
                    const Padding(
                      padding: EdgeInsets.only(
                        right: 8,
                        bottom: 12,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "لا تملك صلاحية تعديل اسم المستخدم.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),

                  _buildTextField(
                    controller: _phoneController,
                    label: "رقم الهاتف",
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "يرجى إدخال رقم الهاتف";
                      }

                      if (value.trim().length < 8) {
                        return "رقم الهاتف غير صحيح";
                      }

                      return null;
                    },
                  ),

                  _buildTextField(
                    controller: _passwordController,
                    label: "كلمة مرور جديدة",
                    icon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length < 6) {
                        return "يجب أن تتكون كلمة المرور من 6 محارف على الأقل";
                      }

                      return null;
                    },
                  ),

                  const Padding(
                    padding: EdgeInsets.only(
                      right: 8,
                      bottom: 12,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "اترك الحقل فارغاً إن لم ترغب بتغيير كلمة المرور.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  _buildTextField(
                    controller: _addressController,
                    label: "مكان السكن",
                    icon: Icons.home_outlined,
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "يرجى إدخال مكان السكن";
                      }

                      return null;
                    },
                  ),

                  _buildGovernorateDropdown(),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _birthDateController,
                    readOnly: true,
                    onTap: _selectBirthDate,
                    decoration: InputDecoration(
                      labelText: "تاريخ الميلاد",
                      prefixIcon:
                          const Icon(Icons.calendar_month_outlined),
                      suffixIcon:
                          const Icon(Icons.arrow_drop_down),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "يرجى اختيار تاريخ الميلاد";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  _buildSectionTitle(
                    "البيانات الإدارية",
                  ),

                  const SizedBox(height: 15),

                  _buildReadOnlyField(
                    label: "الاسم الكامل",
                    value: profile.fullName,
                    icon: Icons.badge_outlined,
                  ),

                  _buildReadOnlyField(
                    label: "الدور",
                    value: profile.role,
                    icon: Icons.manage_accounts_outlined,
                  ),

                  _buildReadOnlyField(
                    label: "حالة الحساب",
                    value: profile.accountStatus,
                    icon: Icons.verified_user_outlined,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor:  Color(0xFF12355B),
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Color(0xFF12355B),
                      ),
                      onPressed:
                          isSaving ? null : _saveProfile,
                      icon: isSaving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color:Color(0xFF12355B)
                              ),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        isSaving
                            ? "جارٍ الحفظ..."
                            : "حفظ التعديلات",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }),)
    );
  }



  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        const CircleAvatar(
          radius: 60,
          child: Icon(
            Icons.person,
            size: 70,
          ),
        ),
        Material(
          color: Theme.of(context).colorScheme.primary,
          shape: const CircleBorder(),
          child: IconButton(
            onPressed: _changeProfileImage,
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    bool obscureText = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,

  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
    
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
            focusColor: const Color(0xFF12355B),
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: suffixIcon,
          filled: !enabled,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            
          ),
        ),
      ),
    );
  }

  Widget _buildGovernorateDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGovernorate,
      decoration: InputDecoration(
        labelText: "المحافظة",
        prefixIcon:
            const Icon(Icons.location_city_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      items: _governorates.map((governorate) {
        return DropdownMenuItem<String>(
          value: governorate,
          child: Text(governorate),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _selectedGovernorate = value;
        });
      },
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        initialValue: value,
        enabled: false,
        decoration: InputDecoration(
        
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}