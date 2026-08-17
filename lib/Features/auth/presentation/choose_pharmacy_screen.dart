import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/pharmacies_bloc.dart';
import 'package:project_2/Features/auth/bloc/pharmacies_event.dart';
import 'package:project_2/Features/auth/bloc/pharmacies_state.dart';
import 'package:project_2/Core/widgets/app_image.dart';
class ChoosePharmacyPage extends StatelessWidget {
  final double currentOrderTotal;

  const ChoosePharmacyPage({super.key, this.currentOrderTotal = 0});
@override
   Widget build(BuildContext context) {
    return BlocProvider<PharmaciesBloc>(
      create: (_) => sl<PharmaciesBloc>()
        ..add(const PharmaciesStarted()),
      child: ChoosePharmacyScreen(
        currentOrderTotal: currentOrderTotal,
      ),
    );
  }
}

class ChoosePharmacyScreen extends StatefulWidget {
  final double currentOrderTotal;

  const ChoosePharmacyScreen({super.key, this.currentOrderTotal = 0});

  @override
  State<ChoosePharmacyScreen> createState() => _ChoosePharmacyScreenState();
}

class _ChoosePharmacyScreenState extends State<ChoosePharmacyScreen> {
  final TextEditingController searchController = TextEditingController();

  double _asDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? "") ?? 0;
  }

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
        backgroundColor: const Color(0xffF3F4F8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "اختيار الصيدلية",
            style: TextStyle(
              color: Color(0xff1C2B4A),
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
              size: 18,
              color: Color(0xff1C2B4A),
            ),
          ),
        ),
        body: BlocBuilder<PharmaciesBloc, PharmaciesState>(
          builder: (context, state) {
            if (state.status == PharmaciesStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == PharmaciesStatus.failure) {
              return Center(
                child: Text(
                state.errorMessage.isNotEmpty
    ? state.errorMessage
    : 'حدث خطأ أثناء تحميل الصيدليات',
                  style: const TextStyle(
                    color: Color(0xff0A2954),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            final pharmaciesList = state.visiblePharmacies;

            return Column(
              children: [
                _buildSearchField(),
                _buildAreaFilters(state),
                const SizedBox(height: 8),
                Expanded(
                  child: pharmaciesList.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 20),
                          itemCount: pharmaciesList.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return _buildPharmacyCard(
                              pharmaciesList[index].toMap(),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          context.read<PharmaciesBloc>().add(PharmaciesSearchChanged(value));
        },
        decoration: InputDecoration(
          hintText: "ابحث عن صيدلية...",
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: Color(0xff7A869A)),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    searchController.clear();
                    context.read<PharmaciesBloc>().add(
                      PharmaciesSearchChanged(""),
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.close, size: 19),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xffD9DFEA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xff0A2954), width: 1.3),
          ),
        ),
      ),
    );
  }

  Widget _buildAreaFilters(PharmaciesState state) {
    final areas = state.pharmacies
        .map((pharmacy) => pharmacy.area)
        .where((area) => area.trim().isNotEmpty)
        .toSet()
        .toList();

    final allAreas = ["الكل", ...areas];

    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: allAreas.length,
        itemBuilder: (context, index) {
          final area = allAreas[index];
          final isSelected = state.selectedArea == area;

          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ChoiceChip(
              selected: isSelected,
              showCheckmark: false,
              onSelected: (_) {
                context.read<PharmaciesBloc>().add(PharmaciesAreaChanged(area));
              },
              label: Text(area),
              backgroundColor: Colors.white,
              selectedColor: const Color(0xff0A2954),
              side: BorderSide(
                color: isSelected
                    ? const Color(0xff0A2954)
                    : const Color(0xffD9E0EA),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xff53657E),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPharmacyCard(Map<String, dynamic> pharmacy) {
    final double dueAmount = _asDouble(pharmacy["dueAmount"]);

    final double balanceToShow = widget.currentOrderTotal > 0
        ? widget.currentOrderTotal
        : dueAmount;

    final bool hasDebt = balanceToShow > 0;

    final String balanceTitle = widget.currentOrderTotal > 0
        ? "رصيد الطلبية"
        : "الرصيد المستحق";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE4E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPharmacyImage(pharmacy),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${pharmacy["name"]} - ${pharmacy["branch"]}",
                  style: const TextStyle(
                    color: Color(0xff26344D),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Color(0xff7D8898),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        pharmacy["address"].toString(),
                        style: const TextStyle(
                          color: Color(0xff7D8898),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () {
                            final selectedPharmacy = Map<String, dynamic>.from(
                              pharmacy,
                            );

                            selectedPharmacy["dueAmount"] = balanceToShow;
                            selectedPharmacy["orderBalance"] =
                                widget.currentOrderTotal;

                            Navigator.pop(context, selectedPharmacy);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0A2954),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          child: const Text(
                            "اختيار الصيدلية",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          balanceTitle,
                          style: const TextStyle(
                            color: Color(0xff7D8898),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "${balanceToShow.toStringAsFixed(2)} ر.س",
                          style: TextStyle(
                            color: hasDebt
                                ? const Color(0xffD63B35)
                                : const Color(0xff18A05E),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacyImage(Map<String, dynamic> pharmacy) {
    return Container(
      width: 56,
      height: 56,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xffF2F5F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: AppImage(
  image:
      pharmacy["image"]?.toString(),
  fit: BoxFit.contain,
  fallbackIcon:
      Icons.local_pharmacy_outlined,
  fallbackColor:
      const Color(0xff6B8A92),
  fallbackSize: 28,
),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_pharmacy_outlined,
            size: 65,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            "لا توجد صيدليات مطابقة",
            style: TextStyle(
              color: Color(0xff0A2954),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "غيّري كلمة البحث أو الفلتر",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
