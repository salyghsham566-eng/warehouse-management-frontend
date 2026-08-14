import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/presentation/collection_payment_form_page.dart';
import 'package:project_2/Features/auth/presentation/collection_payments_history_page.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/2pharmacy_search_bloc.dart';
import 'package:project_2/Features/auth/bloc/2pharmacy_search_event.dart';
import 'package:project_2/Features/auth/bloc/2pharmacy_search_state.dart';
import 'package:project_2/Features/auth/bloc/collection_pharmacies_filter.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/presentation/collection_payment_details_page.dart' hide CollectionPaymentsHistoryPage;
import 'package:project_2/Features/auth/domain/repositories/collection_phermacy_repository.dart';
import 'package:project_2/Features/auth/presentation/collection_pharmacy_details_page.dart';

class CollectionPharmaciesFilterScreen
    extends StatelessWidget {
  const CollectionPharmaciesFilterScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<CollectionPharmaciesBloc>()
            ..add(
              const LoadCollectionPharmaciesEvent(),
            ),
      child:
          const CollectionPharmaciesFilterView(),
    );
  }
}

class CollectionPharmaciesFilterView
    extends StatefulWidget {
  const CollectionPharmaciesFilterView({
    super.key,
  });

  @override
  State<CollectionPharmaciesFilterView>
      createState() =>
          _CollectionPharmaciesFilterViewState();
}

class _CollectionPharmaciesFilterViewState
    extends State<CollectionPharmaciesFilterView> {
  final TextEditingController searchController =
      TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            const Color(0xffF5F7FC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'اختيار الصيدلية',
            style: TextStyle(
              color: Color(0xff0A2954),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_forward,
              color: Color(0xff0A2954),
            ),
          ),
        ),
        body: BlocBuilder<
            CollectionPharmaciesBloc,
            CollectionPharmaciesState>(
          builder: (context, state) {
            if (state
                    is CollectionPharmaciesInitial ||
                state
                    is CollectionPharmaciesLoading) {
              return _buildLoadingState();
            }

            if (state
                is CollectionPharmaciesFailure) {
              return _buildErrorState(
                context,
                state.message,
              );
            }

            if (state
                is CollectionPharmaciesLoaded) {
              return Column(
                children: [
                  _buildSearchAndFilter(
                    context,
                    state,
                  ),

                  _buildFilterChips(
                    context,
                    state,
                  ),

                  const SizedBox(height: 8),

                  Expanded(
                    child: RefreshIndicator(
                      color:
                          const Color(0xff0A2954),
                      onRefresh: () async {
                        final bloc = context.read<
                            CollectionPharmaciesBloc>();

                        final nextState =
                            bloc.stream.firstWhere(
                          (newState) =>
                              newState
                                  is CollectionPharmaciesLoaded ||
                              newState
                                  is CollectionPharmaciesFailure,
                        );

                        bloc.add(
                          const RefreshCollectionPharmaciesEvent(),
                        );

                        await nextState;
                      },
                      child: state
                              .visiblePharmacies
                              .isEmpty
                          ? _buildEmptyState()
                          : ListView.separated(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets
                                      .fromLTRB(
                                12,
                                4,
                                12,
                                20,
                              ),
                              itemCount: state
                                  .visiblePharmacies
                                  .length,
                              separatorBuilder:
                                  (_, __) =>
                                      const SizedBox(
                                height: 10,
                              ),
                              itemBuilder:
                                  (context, index) {
                                final pharmacy =
                                    state.visiblePharmacies[
                                        index];

                                return _buildPharmacyCard(
                                  context,
                                  pharmacy,
                                );
                              },
                            ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(
  BuildContext context,
  CollectionPharmaciesLoaded state,
) {
  return Padding(
    padding:
        const EdgeInsets.fromLTRB(12, 12, 12, 8),
    child: Row(
      children: [
        PopupMenuButton<
            CollectionPharmacyFilter>(
          initialValue: state.selectedFilter,
          onSelected: (filter) {
            context
                .read<CollectionPharmaciesBloc>()
                .add(
                  ChangeCollectionPharmacyFilterEvent(
                    filter: filter,
                  ),
                );
          },
          itemBuilder: (context) {
            return CollectionPharmacyFilter.values
                .map(
                  (filter) => PopupMenuItem<
                      CollectionPharmacyFilter>(
                    value: filter,
                    child: Row(
                      children: [
                        Icon(
                          state.selectedFilter == filter
                              ? Icons
                                  .radio_button_checked
                              : Icons
                                  .radio_button_unchecked,
                          size: 19,
                          color: const Color(
                            0xff0A2954,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Text(filter.label),
                      ],
                    ),
                  ),
                )
                .toList();
          },
          child: Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: const Color(0xffE8F0FC),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.tune,
              color: Color(0xff0A2954),
              size: 21,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: TextField(
            controller: searchController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            onChanged: (value) {
              context
                  .read<CollectionPharmaciesBloc>()
                  .add(
                    SearchCollectionPharmaciesEvent(
                      searchText: value,
                    ),
                  );

              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'ابحث عن صيدلية...',
              hintTextDirection:
                  TextDirection.rtl,
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xff7A869A),
                size: 21,
              ),
              suffixIcon:
                  searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();

                            context
                                .read<
                                    CollectionPharmaciesBloc>()
                                .add(
                                  const ClearCollectionPharmacySearchEvent(),
                                );

                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 19,
                          ),
                        )
                      : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(
                vertical: 11,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(11),
                borderSide: const BorderSide(
                  color: Color(0xffD9DFEA),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(11),
                borderSide: const BorderSide(
                  color: Color(0xff0A2954),
                  width: 1.3,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildFilterChips(
    BuildContext context,
    CollectionPharmaciesLoaded state,
  ) {

    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        children: CollectionPharmacyFilter.values
            .map(
              (filter) => _buildFilterChip(
                context: context,
                title: filter.label,
                filter: filter,
                selectedFilter:
                    state.selectedFilter,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String title,
    required CollectionPharmacyFilter filter,
    required CollectionPharmacyFilter
        selectedFilter,
  }) {
    final isSelected =
        selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        selected: isSelected,
        showCheckmark: false,
        onSelected: (_) {
          context
              .read<CollectionPharmaciesBloc>()
              .add(
                ChangeCollectionPharmacyFilterEvent(
                  filter: filter,
                ),
              );
        },
        label: Text(title),
        backgroundColor: Colors.white,
        selectedColor:
            const Color(0xff0A2954),
        side: BorderSide(
          color: isSelected
              ? const Color(0xff0A2954)
              : const Color(0xffD9E0EA),
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20),
        ),
        labelStyle: TextStyle(
          color: isSelected
              ? Colors.white
              : const Color(0xff53657E),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPharmacyCard(
    BuildContext context,
    CollectionPharmacyModel pharmacy,
  ) {
    final bool hasDebt = pharmacy.hasDebt;
    final bool isSettled = pharmacy.isSettled;

    final bool hasPendingCollection =
        pharmacy.isPendingCollection;

    final bool canCall =
        pharmacy.phoneNumber != null &&
        pharmacy.phoneNumber!.trim().isNotEmpty;

    return InkWell(
      onTap: () {
       _openPharmacyDetails(
      context,
      pharmacy,
    
        );
      },borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xffE3E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.035),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.local_pharmacy_outlined,
                  color: Color(0xff0A2954),
                  size: 23,
                ),
      
                const SizedBox(width: 8),
      
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        pharmacy.name,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          color:
                              Color(0xff1A2F4D),
                          fontSize: 14,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
      
                      const SizedBox(height: 4),
      
                      Row(
                        children: [
                          const Icon(
                            Icons
                                .location_on_outlined,
                            size: 14,
                            color:
                                Color(0xff7A869A),
                          ),
      
                          const SizedBox(width: 4),
      
                          Expanded(
                            child: Text(
                              pharmacy.address,
                              maxLines: 1,
                              overflow: TextOverflow
                                  .ellipsis,
                              style:
                                  const TextStyle(
                                color: Color(
                                  0xff7A869A,
                                ),
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
      
                      const SizedBox(height: 3),
      
                      Text(
                        pharmacy.area,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          color:
                              Color(0xff7A869A),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
      
                const SizedBox(width: 8),
      
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: isSettled
                        ? const Color(0xffEAF3F0)
                        : hasPendingCollection
                            ? const Color(
                                0xffFFF2E3,
                              )
                            : const Color(
                                0xffE5F4EF,
                              ),
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isSettled
                        ? Icons.check_circle_outline
                        : hasPendingCollection
                            ? Icons
                                .hourglass_empty_rounded
                            : Icons
                                .account_balance_wallet_outlined,
                    color: isSettled
                        ? const Color(0xff18A05E)
                        : hasPendingCollection
                            ? const Color(
                                0xffE78324,
                              )
                            : const Color(
                                0xff116B53,
                              ),
                    size: 23,
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 10),
      
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isSettled
                      ? const Color(0xffEAF8F1)
                      : hasPendingCollection
                          ? const Color(0xffFFF2E3)
                          : const Color(0xffFDECEC),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  pharmacy.accountStatus.label,
                  style: TextStyle(
                    color: isSettled
                        ? const Color(0xff169967)
                        : hasPendingCollection
                            ? const Color(
                                0xffE78324,
                              )
                            : const Color(
                                0xffD63B35,
                              ),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
      
            const SizedBox(height: 10),
      
            Row(
              children: [
                Expanded(
                  child: _buildAmountBox(
                    title:
                        'الرصيد الرسمي الحالي',
                    amount:
                        pharmacy.officialBalance,
                    amountColor:
                        pharmacy.officialBalance > 0
                            ? const Color(
                                0xffD63B35,
                              )
                            : const Color(
                                0xff18A05E,
                              ),
                  ),
                ),
      
                const SizedBox(width: 8),
      
                Expanded(
                  child: _buildAmountBox(
                    title: 'آخر دفعة',
                    amount:
                        pharmacy.lastPaymentAmount,
                    amountColor:
                        const Color(0xff169967),
                  ),
                ),
              ],
            ),
      
            if (pharmacy.lastPaymentDate !=
                null) ...[
              const SizedBox(height: 8),
      
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 15,
                    color: Color(0xff7A869A),
                  ),
      
                  const SizedBox(width: 5),
      
                  Text(
                    'تاريخ آخر دفعة: '
                    '${_formatDate(pharmacy.lastPaymentDate!)}',
                    style: const TextStyle(
                      color:
                          Color(0xff7A869A),
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
      
            const SizedBox(height: 12),
      
            Row(
              children: [
                if (canCall) ...[
        const SizedBox(height: 7),
      
        InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        final String phoneNumber =
            pharmacy.phoneNumber!.trim();
      
        await Clipboard.setData(
          ClipboardData(text: phoneNumber),
        );
      
        if (!context.mounted) {
          return;
        }
      
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('تم نسخ رقم الموبايل'),
              behavior: SnackBarBehavior.floating,
            ),
          );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.phone_outlined,
              size: 16,
              color: Color(0xff7A869A),
            ),
      
            const SizedBox(width: 6),
      
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                pharmacy.phoneNumber!.trim(),
                style: const TextStyle(
                  color: Color(0xff536179),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
      
            const SizedBox(width: 7),
      
            const Icon(
              Icons.copy_outlined,
              size: 14,
              color: Color(0xff0A2954),
            ),
          ],
        ),
      ),
        ),
      ],
      
                const SizedBox(width: 8),
      
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: isSettled ||
                              hasPendingCollection
                          ? null
                          : ()async {
                            final CollectionPaymentModel?
                                result =
                                await Navigator.push<
                                    CollectionPaymentModel>(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CollectionPaymentFormPage(
                pharmacy: pharmacy,
              ),
            ),
          );
                 if (result != null && context.mounted) {
        context.read<CollectionPharmaciesBloc>().add(
          const RefreshCollectionPharmaciesEvent(),
        );
      }             
                            },
                      icon: Icon(
                        isSettled
                            ? Icons
                                .check_circle_outline
                            : hasPendingCollection
                                ? Icons
                                    .hourglass_empty_rounded
                                : Icons
                                    .payments_outlined,
                        size: 18,
                      ),
                      label: Text(
                        isSettled
                            ? 'مسدد'
                            : hasPendingCollection
                                ? 'دفعة معلقة'
                                : 'تسديد',
                        style:
                            const TextStyle(
                          fontSize: 13,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                          0xff0A2954,
                        ),
                        disabledBackgroundColor:
                            hasPendingCollection
                                ? const Color(
                                    0xffE78324,
                                  )
                                : const Color(
                                    0xffA0A7B2,
                                  ),
                        foregroundColor:
                            Colors.white,
                        disabledForegroundColor:
                            Colors.white,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            9,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      
            if (hasPendingCollection) ...[
              const SizedBox(height: 9),
      
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color:
                      const Color(0xffFFF2E3),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: const Text(
                  'لديها دفعة معلقة بانتظار اعتماد المفوتر',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xffE78324),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
Future<void> _openPharmacyDetails(
  BuildContext listContext,
  CollectionPharmacyModel pharmacy,
) async {
  await Navigator.of(listContext).push<void>(
    MaterialPageRoute<void>(
      builder: (routeContext) {
        CollectionPharmacyModel currentPharmacy =
            pharmacy;

        return StatefulBuilder(
          builder: (
            detailsContext,
            setDetailsState,
          ) {
            Future<void> reloadPharmacy() async {
              final CollectionPharmacyModel
                  updatedPharmacy =
                  await sl<CollectionRepository>()
                      .getCollectionPharmacyDetails(
                currentPharmacy.id,
              );

              if (!detailsContext.mounted) {
                return;
              }

              setDetailsState(() {
                currentPharmacy =
                    updatedPharmacy;
              });
            }

            final bool canRecordPayment =
                currentPharmacy.hasDebt &&
                    !currentPharmacy
                        .isPendingCollection;

            return CollectionPharmacyDetailsPage(
              pharmacy: currentPharmacy,

              onRecordPayment: canRecordPayment
                  ? () async {
                      final CollectionPaymentModel?
                          savedPayment =
                          await Navigator.of(
                        detailsContext,
                      ).push<
                          CollectionPaymentModel>(
                        MaterialPageRoute<
                            CollectionPaymentModel>(
                          builder: (_) {
                            return CollectionPaymentFormPage(
                              pharmacy:
                                  currentPharmacy,
                            );
                          },
                        ),
                      );

                      if (savedPayment == null) {
                        return;
                      }

                      await reloadPharmacy();

                      if (!listContext.mounted) {
                        return;
                      }

                      listContext
                          .read<
                              CollectionPharmaciesBloc>()
                          .add(
                            const RefreshCollectionPharmaciesEvent(),
                          );
                    }
                  : null,

              onOpenHistory: () {
                Navigator.of(detailsContext)
                    .push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) {
                      return CollectionPaymentsHistoryPage(
                        pharmacyId:
                            currentPharmacy.id,
                        pharmacyName:
                            currentPharmacy.name,
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    ),
  );

  if (!listContext.mounted) {
    return;
  }

  listContext
      .read<CollectionPharmaciesBloc>()
      .add(
        const RefreshCollectionPharmaciesEvent(),
      );
}
  Widget _buildAmountBox({
    required String title,
    required double? amount,
    required Color amountColor,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF7F9FC),
        borderRadius:
            BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xffEDF0F5),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff7A869A),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            amount == null
                ? 'لا توجد'
                : '${amount.toStringAsFixed(2)} ر.س',
            style: TextStyle(
              color: amount == null
                  ? const Color(0xff7A869A)
                  : amountColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();

    final day =
        localDate.day.toString().padLeft(2, '0');

    final month =
        localDate.month.toString().padLeft(2, '0');

    return '$day/$month/${localDate.year}';
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xff0A2954),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 65,
              color: Color(0xffD63B35),
            ),

            const SizedBox(height: 12),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xff0A2954),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<
                        CollectionPharmaciesBloc>()
                    .add(
                      const LoadCollectionPharmaciesEvent(),
                    );
              },
              icon: const Icon(Icons.refresh),
              label:
                  const Text('إعادة المحاولة'),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xff0A2954),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return CustomScrollView(
      physics:
          const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons
                      .local_pharmacy_outlined,
                  size: 65,
                  color: Colors.grey.shade400,
                ),

                const SizedBox(height: 12),

                const Text(
                  'لا توجد صيدليات مطابقة',
                  style: TextStyle(
                    color:
                        Color(0xff0A2954),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'غيّري كلمة البحث أو الفلتر',
                  style: TextStyle(
                    color:
                        Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}