import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/warehouse_inventory_file_bloc.dart';
import 'package:project_2/Features/auth/bloc/warehouse_inventory_file_event.dart';
import 'package:project_2/Features/auth/bloc/warehouse_inventory_file_state.dart';
import 'package:project_2/Features/auth/data/models/warehouse_inventory_file_model.dart';
import 'package:project_2/Features/auth/presentation/warehouse_inventory_pdf_preview_screen.dart';
import 'package:project_2/Features/auth/services/warehouse_inventory_pdf_exporter.dart';

class WarehouseInventoryFileScreen
    extends StatelessWidget {
  const WarehouseInventoryFileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<
        WarehouseInventoryFileBloc>(
      create: (_) =>
          sl<WarehouseInventoryFileBloc>()
            ..add(
              LoadWarehouseInventoryFileEvent(),
            ),
      child:
          const _WarehouseInventoryFileView(),
    );
  }
}

class _WarehouseInventoryFileView
    extends StatelessWidget {
  const _WarehouseInventoryFileView();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'ملف الجرد',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: BlocConsumer<
            WarehouseInventoryFileBloc,
            WarehouseInventoryFileState>(
          listener: (context, state) async {
            if (state
                is WarehouseInventoryPdfReady) {
              if (state.action ==
                  WarehouseInventoryPdfAction
                      .preview) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        WarehouseInventoryPdfPreviewScreen(
                      bytes: state.bytes,
                      fileName:
                          state.file.fileName,
                    ),
                  ),
                );
              } else {
                await exportWarehouseInventoryPdf(
                  bytes: state.bytes,
                  filename:
                      state.file.fileName,
                );

                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'تم تجهيز نسخة PDF للحفظ',
                    ),
                  ),
                );
              }
            }

            if (state
                is WarehouseInventoryPdfFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
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
          builder: (context, state) {
            if (state
                    is WarehouseInventoryFileInitial ||
                state
                    is WarehouseInventoryFileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state
                is WarehouseInventoryFileFailure) {
              return _ErrorView(
                message: state.message,
                onRetry: () {
                  context
                      .read<
                          WarehouseInventoryFileBloc>()
                      .add(
                        LoadWarehouseInventoryFileEvent(),
                      );
                },
              );
            }

            if (state
                is WarehouseInventoryFileLoaded) {
              final file = state.file;

              if (file == null) {
                return const _EmptyView();
              }

              return _InventoryFileContent(
                file: file,
              );
            }

            if (state
                is WarehouseInventoryPdfLoading) {
              return _InventoryFileContent(
                file: state.file,
                loadingAction: state.action,
              );
            }

            if (state
                is WarehouseInventoryPdfFailure) {
              return _InventoryFileContent(
                file: state.file,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _InventoryFileContent
    extends StatelessWidget {
  final WarehouseInventoryFileModel file;
  final WarehouseInventoryPdfAction?
      loadingAction;

  const _InventoryFileContent({
    required this.file,
    this.loadingAction,
  });

  @override
  Widget build(BuildContext context) {
    final isPreviewLoading =
        loadingAction ==
            WarehouseInventoryPdfAction.preview;

    final isDownloadLoading =
        loadingAction ==
            WarehouseInventoryPdfAction.download;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
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
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color:
                      AppColors.dangerSoft,
                  borderRadius:
                      BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColors.danger,
                  size: 31,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.fileName,
                      style: const TextStyle(
                        color:
                            AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'آخر ملف جرد مرفوع من المفوتر',
                      style: TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 12.5,
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
                Icons.lock_outline_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'الملف للقراءة فقط. المندوب يستطيع المعاينة واستخراج نسخة PDF فقط، دون رفع أو تعديل الملف الأصلي.',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12.5,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'معلومات الملف',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 10),

        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Column(
            children: [
              _InfoRow(
                icon:
                    Icons.insert_drive_file_outlined,
                label: 'اسم الملف',
                value: file.fileName,
              ),
              const Divider(
                height: 1,
                color: AppColors.border,
              ),
              _InfoRow(
                icon:
                    Icons.calendar_today_outlined,
                label: 'تاريخ الرفع',
                value: file.uploadedAt,
              ),
              const Divider(
                height: 1,
                color: AppColors.border,
              ),
              _InfoRow(
                icon:
                    Icons.person_outline_rounded,
                label: 'المفوتر',
                value: file.uploadedBy,
              ),
              const Divider(
                height: 1,
                color: AppColors.border,
              ),
              _InfoRow(
                icon:
                    Icons.notes_rounded,
                label: 'الملاحظات',
                value: file.notes
                            ?.trim()
                            .isNotEmpty ==
                        true
                    ? file.notes!
                    : 'لا توجد ملاحظات',
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed:
                loadingAction == null
                    ? () {
                        context
                            .read<
                                WarehouseInventoryFileBloc>()
                            .add(
                              LoadWarehouseInventoryPdfEvent(
                                fileId:
                                    file.id,
                                action:
                                    WarehouseInventoryPdfAction
                                        .preview,
                              ),
                            );
                      }
                    : null,
            icon: isPreviewLoading
                ? const SizedBox(
                    width: 19,
                    height: 19,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2.2,
                    ),
                  )
                : const Icon(
                    Icons.visibility_outlined,
                  ),
            label: Text(
              isPreviewLoading
                  ? 'جاري فتح المعاينة...'
                  : 'معاينة الملف',
            ),
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 50,
          child: OutlinedButton.icon(
            onPressed:
                loadingAction == null
                    ? () {
                        context
                            .read<
                                WarehouseInventoryFileBloc>()
                            .add(
                              LoadWarehouseInventoryPdfEvent(
                                fileId:
                                    file.id,
                                action:
                                    WarehouseInventoryPdfAction
                                        .download,
                              ),
                            );
                      }
                    : null,
            icon: isDownloadLoading
                ? const SizedBox(
                    width: 19,
                    height: 19,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2.2,
                    ),
                  )
                : const Icon(
                    Icons.download_rounded,
                  ),
            label: Text(
              isDownloadLoading
                  ? 'جاري تجهيز PDF...'
                  : 'استخراج PDF',
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 13,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 21,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 95,
            child: Text(
              label,
              style: const TextStyle(
                color:
                    AppColors.textSecondary,
                fontSize: 12.5,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color:
                    AppColors.textPrimary,
                fontSize: 13.5,
                fontWeight:
                    FontWeight.w700,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: const Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Icon(
                Icons
                    .insert_drive_file_outlined,
                color:
                    AppColors.textSecondary,
                size: 46,
              ),
              SizedBox(height: 12),
              Text(
                'لا يوجد ملف جرد مرفوع حالياً',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.danger,
              size: 46,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color:
                    AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'إعادة المحاولة',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
