import 'package:flutter/material.dart';

import 'package:project_2/Core/theme/app_colors.dart';

class PrivacyAndTermsScreen
    extends StatelessWidget {
  const PrivacyAndTermsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            foregroundColor: AppColors.primary,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'الخصوصية والشروط',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            bottom: const TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor:
                  AppColors.textSecondary,
              indicatorColor:
                  AppColors.primary,
              tabs: [
                Tab(
                  text: 'سياسة الخصوصية',
                ),
                Tab(
                  text: 'الشروط',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              _LegalContent(
                title: 'سياسة الخصوصية',
                icon:
                    Icons.privacy_tip_outlined,
                paragraphs: [
                  'يتم استخدام بيانات حساب المندوب فقط لتشغيل الوظائف المرتبطة بعمله داخل التطبيق وإظهار البيانات المسموح له بالوصول إليها.',
                  'قد تتضمن البيانات المستخدمة معلومات الحساب وبيانات التواصل والمناطق والصلاحيات والعمليات المرتبطة بعمل المندوب.',
                  'لا يستطيع المندوب تعديل البيانات الإدارية مثل الاسم أو الدور أو المناطق أو الصلاحيات من هذه الشاشة.',
                  'يجب التعامل مع بيانات العملاء والصيدليات والمعلومات المالية وفق صلاحيات الحساب وسياسات الجهة المالكة للتطبيق.',
                ],
              ),
              _LegalContent(
                title: 'الشروط والأحكام',
                icon:
                    Icons.description_outlined,
                paragraphs: [
                  'استخدام التطبيق مخصص للحسابات المصرح لها من الجهة المالكة للنظام.',
                  'يلتزم المستخدم باستخدام الحساب والبيانات والوظائف المتاحة له لأغراض العمل المصرح بها فقط.',
                  'لا يجوز مشاركة بيانات تسجيل الدخول أو محاولة الوصول إلى وظائف أو بيانات خارج صلاحيات الحساب.',
                  'قد يتم تحديث هذه الشروط أو سياسة الخصوصية عند تحديث النظام أو سياسات الجهة المالكة للتطبيق.',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegalContent extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> paragraphs;

  const _LegalContent({
    required this.title,
    required this.icon,
    required this.paragraphs,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        16,
        18,
        16,
        28,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color:
                      AppColors.primarySoft,
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color:
                            AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'محتوى للقراءة فقط',
                      style: TextStyle(
                        color:
                            AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              for (
                int index = 0;
                index < paragraphs.length;
                index++
              ) ...[
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(
                        top: 7,
                      ),
                      width: 7,
                      height: 7,
                      decoration:
                          const BoxDecoration(
                        color:
                            AppColors.primary,
                        shape:
                            BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        paragraphs[index],
                        style:
                            const TextStyle(
                          color: AppColors
                              .textPrimary,
                          fontSize: 13,
                          height: 1.8,
                        ),
                      ),
                    ),
                  ],
                ),
                if (index !=
                    paragraphs.length - 1)
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    child: Divider(
                      height: 1,
                      color:
                          AppColors.border,
                    ),
                  ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius:
                BorderRadius.circular(14),
          ),
          child: const Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 20,
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'يمكن لاحقاً استبدال هذا النص بالنص الرسمي المعتمد من الشركة أو جلبه من رابط معتمد دون تغيير تصميم الشاشة.',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12.5,
                    height: 1.5,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
