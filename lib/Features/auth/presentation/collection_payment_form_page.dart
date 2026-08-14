import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/collection_payment_form_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_payment_form_event.dart';
import 'package:project_2/Features/auth/bloc/collection_payment_form_state.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';

class CollectionPaymentFormPage extends StatelessWidget {
  const CollectionPaymentFormPage({
    required this.pharmacy,
    super.key,
  });

  final CollectionPharmacyModel pharmacy;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CollectionPaymentFormBloc>(
      create: (_) => sl<CollectionPaymentFormBloc>(
        param1: pharmacy,
      ),
      child: _CollectionPaymentFormView(
        pharmacy: pharmacy,
      ),
    );
  }
}

class _CollectionPaymentFormView extends StatefulWidget {
  const _CollectionPaymentFormView({
    required this.pharmacy,
  });

  final CollectionPharmacyModel pharmacy;

  @override
  State<_CollectionPaymentFormView> createState() =>
      _CollectionPaymentFormViewState();
}

class _CollectionPaymentFormViewState
    extends State<_CollectionPaymentFormView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CollectionPaymentFormBloc, CollectionPaymentFormState>(
      listener: _paymentListener,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'تسجيل دفعة',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 30),
                children: [
                  _PharmacyCard(pharmacy: widget.pharmacy),

                  const SizedBox(height: 15),

                  _BalanceSection(
                    officialBalance: state.officialBalance,
                    expectedBalance: state.expectedBalance,
                  ),

                  const SizedBox(height: 15),

                  _SectionCard(
                    title: 'بيانات الدفعة',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel(text: 'المبلغ', requiredField: true),

                        const SizedBox(height: 8),

                        TextFormField(
                          controller: _amountController,
                          enabled: !state.isSubmitting,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9٠-٩.,٫]'),
                            ),
                          ],
                          onChanged: (value) {
                            context.read<CollectionPaymentFormBloc>().add(
                              CollectionPaymentAmountChanged(value),
                            );
                          },
                          validator: (_) {
                            final double amount = context
                                .read<CollectionPaymentFormBloc>()
                                .state
                                .enteredAmount;

                            if (amount <= 0) {
                              return 'أدخل مبلغاً صحيحاً';
                            }

                            if (amount > widget.pharmacy.officialBalance) {
                              return 'المبلغ أكبر من الرصيد الرسمي';
                            }

                            return null;
                          },
                          decoration: _inputDecoration(
                            hintText: '0',
                            suffixText: 'ر.س',
                            prefixIcon: Icons.payments_outlined,
                          ),
                        ),

                        const SizedBox(height: 17),

                        const _FieldLabel(
                          text: 'تاريخ الدفعة',
                          requiredField: true,
                        ),

                        const SizedBox(height: 8),

                        _DateField(
                          date: state.paymentDate,
                          enabled: !state.isSubmitting,
                          onTap: () {
                            _selectDate(context, state.paymentDate);
                          },
                        ),

                        const SizedBox(height: 17),

                        const _FieldLabel(
                          text: 'طريقة الدفع',
                          requiredField: true,
                        ),

                        const SizedBox(height: 8),

                        _PaymentMethodField(
                          value: state.paymentMethod,
                          enabled: !state.isSubmitting,
                          onChanged: (method) {
                            context.read<CollectionPaymentFormBloc>().add(
                              CollectionPaymentMethodChanged(method),
                            );
                          },
                        ),

                        const SizedBox(height: 17),

                        const _FieldLabel(
                          text: 'ملاحظات',
                          requiredField: false,
                        ),

                        const SizedBox(height: 8),

                        TextFormField(
                          enabled: !state.isSubmitting,
                          minLines: 3,
                          maxLines: 5,
                          maxLength: 300,
                          onChanged: (value) {
                            context.read<CollectionPaymentFormBloc>().add(
                              CollectionPaymentNotesChanged(value),
                            );
                          },
                          decoration: _inputDecoration(
                            hintText: 'أضف ملاحظات حول الدفعة',
                            prefixIcon: Icons.notes_outlined,
                            alignIconTop: true,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  _SectionCard(
                    title: 'صورة الوصل',
                    subtitle: 'اختياري',
                    child: _ReceiptSection(
                      imagePath: state.receiptImagePath,
                      enabled: !state.isSubmitting,
                      onCameraPressed: () {
                        _pickReceipt(context, ImageSource.camera);
                      },
                      onGalleryPressed: () {
                        _pickReceipt(context, ImageSource.gallery);
                      },
                      onRemovePressed: () {
                        context.read<CollectionPaymentFormBloc>().add(
                          const CollectionPaymentReceiptRemoved(),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  const _AccountingNotice(),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 53,
                    child: FilledButton.icon(
                      onPressed: state.isSubmitting
                          ? null
                          : () {
                              _submit(context);
                            },
                      icon: state.isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        state.isSubmitting
                            ? 'جارٍ حفظ الدفعة...'
                            : 'حفظ الدفعة',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.primary,
                        disabledForegroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _paymentListener(
    BuildContext context,
    CollectionPaymentFormState state,
  ) async {
    if (state.submitStatus == CollectionPaymentSubmitStatus.failure) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(state.errorMessage ?? 'تعذر حفظ الدفعة'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.danger,
          ),
        );

      return;
    }

    if (state.submitStatus == CollectionPaymentSubmitStatus.success &&
        state.savedPayment != null) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            icon: const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 55,
            ),
            title: const Text('تم تسجيل الدفعة', textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_formatAmount(state.savedPayment!.amount)} ر.س',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warningSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    state.savedPayment!.status.label,
                    style: const TextStyle(
                      color: AppColors.warning,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                const Text(
                  'لم يتم تعديل الرصيد الرسمي، وسيتم تعديله بعد اعتماد المفوتر.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('تم'),
              ),
            ],
          );
        },
      );

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop(
        state.savedPayment,
      );
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate) async {
    final DateTime now = DateTime.now();

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? now : initialDate,
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: 'اختيار تاريخ الدفعة',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
    );

    if (!context.mounted || selectedDate == null) {
      return;
    }

    context.read<CollectionPaymentFormBloc>().add(
      CollectionPaymentDateChanged(selectedDate),
    );
  }

  Future<void> _pickReceipt(BuildContext context, ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1600,
      );

      if (!context.mounted || image == null) {
        return;
      }

      context.read<CollectionPaymentFormBloc>().add(
        CollectionPaymentReceiptChanged(image.path),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('تعذر اختيار صورة الوصل'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    context.read<CollectionPaymentFormBloc>().add(
      const CollectionPaymentSubmitted(),
    );
  }
}

class _PharmacyCard extends StatelessWidget {
  const _PharmacyCard({required this.pharmacy});

  final CollectionPharmacyModel pharmacy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 47,
            height: 47,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_pharmacy_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pharmacy.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  pharmacy.area,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceSection extends StatelessWidget {
  const _BalanceSection({
    required this.officialBalance,
    required this.expectedBalance,
  });

  final double officialBalance;
  final double expectedBalance;

  @override
  Widget build(BuildContext context) {
    final bool invalidExpectedBalance = expectedBalance < 0;

    return Row(
      children: [
        Expanded(
          child: _BalanceCard(
            title: 'الرصيد الرسمي',
            amount: officialBalance,
            icon: Icons.account_balance_wallet_outlined,
            color: AppColors.primary,
            background: AppColors.primarySoft,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _BalanceCard(
            title: 'الرصيد المتوقع',
            amount: expectedBalance,
            icon: Icons.calculate_outlined,
            color: invalidExpectedBalance
                ? AppColors.danger
                : AppColors.success,
            background: invalidExpectedBalance
                ? AppColors.dangerSoft
                : AppColors.successSoft,
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 115),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 11),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${_formatAmount(amount)} ر.س',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child, this.subtitle});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 17),
          child,
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text, required this.requiredField});

  final String text;
  final bool requiredField;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text),
          if (requiredField)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.danger),
            ),
        ],
      ),
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.date,
    required this.enabled,
    required this.onTap,
  });

  final DateTime date;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(13),
      child: InputDecorator(
        decoration: _inputDecoration(prefixIcon: Icons.calendar_month_outlined),
        child: Text(
          _formatDate(date),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodField extends StatelessWidget {
  const _PaymentMethodField({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final CollectionPaymentMethod value;
  final bool enabled;
  final ValueChanged<CollectionPaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: _inputDecoration(prefixIcon: Icons.credit_card_outlined),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CollectionPaymentMethod>(
          value: value,
          isExpanded: true,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: CollectionPaymentMethod.values
              .map(
                (method) => DropdownMenuItem<CollectionPaymentMethod>(
                  value: method,
                  child: Text(method.label),
                ),
              )
              .toList(growable: false),
          onChanged: !enabled
              ? null
              : (method) {
                  if (method != null) {
                    onChanged(method);
                  }
                },
        ),
      ),
    );
  }
}

class _ReceiptSection extends StatelessWidget {
  const _ReceiptSection({
    required this.imagePath,
    required this.enabled,
    required this.onCameraPressed,
    required this.onGalleryPressed,
    required this.onRemovePressed,
  });

  final String? imagePath;
  final bool enabled;

  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;
  final VoidCallback onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imagePath != null) ...[
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(imagePath!),
                  width: double.infinity,
                  height: 185,
                  fit: BoxFit.cover,
                ),
              ),
              PositionedDirectional(
                top: 8,
                end: 8,
                child: Material(
                  color: AppColors.danger,
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: enabled ? onRemovePressed : null,
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ] else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.textSecondary,
                  size: 42,
                ),
                SizedBox(height: 9),
                Text(
                  'لم تتم إضافة صورة وصل',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: enabled ? onCameraPressed : null,
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('الكاميرا'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: enabled ? onGalleryPressed : null,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('المعرض'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AccountingNotice extends StatelessWidget {
  const _AccountingNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warningSoft,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.warning),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.warning),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'الرصيد المتوقع مؤقت وغير محاسبي. لن يتغير الرصيد الرسمي إلا بعد اعتماد الدفعة من المفوتر.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration({
  String? hintText,
  String? suffixText,
  IconData? prefixIcon,
  bool alignIconTop = false,
}) {
  return InputDecoration(
    hintText: hintText,
    suffixText: suffixText,
    prefixIcon: prefixIcon == null
        ? null
        : Padding(
            padding: EdgeInsets.only(bottom: alignIconTop ? 65 : 0),
            child: Icon(prefixIcon, color: AppColors.textSecondary),
          ),
    filled: true,
    fillColor: AppColors.background,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.3),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: AppColors.danger),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: AppColors.danger, width: 1.3),
    ),
  );
}

String _formatDate(DateTime date) {
  final DateTime localDate = date.toLocal();

  final String day = localDate.day.toString().padLeft(2, '0');

  final String month = localDate.month.toString().padLeft(2, '0');

  return '$day/$month/${localDate.year}';
}

String _formatAmount(double amount) {
  final bool isNegative = amount < 0;
  final double absoluteAmount = amount.abs();

  final bool hasDecimals = absoluteAmount != absoluteAmount.roundToDouble();

  final String value = absoluteAmount.toStringAsFixed(hasDecimals ? 2 : 0);

  final List<String> parts = value.split('.');
  final String integerPart = parts.first;

  final StringBuffer result = StringBuffer();

  for (int index = 0; index < integerPart.length; index++) {
    if (index > 0 && (integerPart.length - index) % 3 == 0) {
      result.write(',');
    }

    result.write(integerPart[index]);
  }

  if (parts.length > 1) {
    result
      ..write('.')
      ..write(parts[1]);
  }

  return isNegative ? '-${result.toString()}' : result.toString();
}
