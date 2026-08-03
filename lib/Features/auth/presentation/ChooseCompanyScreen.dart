import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/companies_bloc.dart';
import 'package:project_2/Features/auth/bloc/companies_event.dart';
import 'package:project_2/Features/auth/bloc/companies_state.dart';
import 'package:project_2/Features/auth/data/models/company_model.dart';
import 'package:project_2/Features/auth/presentation/company_products_screen.dart';

class ChooseCompanyPage extends StatelessWidget {
  const ChooseCompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompaniesBloc>(
      create: (_) => sl<CompaniesBloc>()
        ..add(CompaniesStarted()),
      child: const ChooseCompanyScreen(),
    );
  }
}

class ChooseCompanyScreen extends StatefulWidget {
  const ChooseCompanyScreen({super.key});

  @override
  State<ChooseCompanyScreen> createState() => _ChooseCompanyScreenState();
}

class _ChooseCompanyScreenState extends State<ChooseCompanyScreen> {
  final TextEditingController searchController = TextEditingController();

  final Map<String, Map<String, dynamic>> sharedCartItems = {};

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: const Text(
          "اختيار الشركة",
          style: TextStyle(
            color: Color(0xff0A2954),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<CompaniesBloc, CompaniesState>(
          builder: (context, state) {
            if (state.status == CompaniesStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == CompaniesStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? "حدث خطأ غير متوقع",
                  style: const TextStyle(
                    color: Color(0xff0A2954),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            final visibleCompanies = state.visibleCompanies;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      context.read<CompaniesBloc>().add(
                        CompaniesSearchChanged(value),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: "ابحث عن اسم الشركة...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xff0A2954),
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                context.read<CompaniesBloc>().add(
                                  CompaniesSearchChanged(""),
                                );
                                setState(() {});
                              },
                              icon: const Icon(Icons.close, size: 20),
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xff0A2954),
                          width: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    children: [
                      _buildFilterChip(
                        context: context,
                        title: "الكل",
                        filter: CompanyFilter.all,
                        selectedFilter: state.selectedFilter,
                      ),
                      _buildFilterChip(
                        context: context,
                        title: "لديها عروض",
                        filter: CompanyFilter.hasOffers,
                        selectedFilter: state.selectedFilter,
                      ),
                      _buildFilterChip(
                        context: context,
                        title: "بدون عروض",
                        filter: CompanyFilter.noOffers,
                        selectedFilter: state.selectedFilter,
                      ),
                      _buildFilterChip(
                        context: context,
                        title: "الأكثر منتجات",
                        filter: CompanyFilter.mostProducts,
                        selectedFilter: state.selectedFilter,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: visibleCompanies.isEmpty
                      ? _buildEmptyState()
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
                          itemCount: visibleCompanies.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 175,
                              ),
                          itemBuilder: (context, index) {
                            final company = visibleCompanies[index];

                            return _buildCompanyCard(context, company);
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

  Widget _buildFilterChip({
    required BuildContext context,
    required String title,
    required CompanyFilter filter,
    required CompanyFilter selectedFilter,
  }) {
    final isSelected = selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        selected: isSelected,
        showCheckmark: false,
        label: Text(title),
        onSelected: (_) {
          context.read<CompaniesBloc>().add(CompaniesFilterChanged(filter));
        },
        backgroundColor: const Color(0xffE8F0FC),
        selectedColor: const Color(0xff0A2954),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xff53657E),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, CompanyModel company) {
    final int offers = company.offers;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xffE4EAF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xffF5F7FC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xffEDF0F5)),
                        ),
                        child: Image.asset(
                          company.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.business,
                              color: Color(0xff0A2954),
                              size: 30,
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                company.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xff0A2954),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${company.productsCount} منتج متاح",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 90),
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: offers > 0
                          ? const Color(0xffE4FAEF)
                          : const Color(0xffEDF3FB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          offers > 0 ? Icons.access_time : Icons.info_outline,
                          size: 14,
                          color: offers > 0
                              ? const Color(0xff26A76F)
                              : const Color(0xff60758F),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          offers > 0 ? "$offers عروض فعالة" : "لا توجد عروض",
                          style: TextStyle(
                            color: offers > 0
                                ? const Color(0xff26A76F)
                                : const Color(0xff60758F),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: 43,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CompanyProductsScreen(
                      company: company.toMap(),
                      cartItems: sharedCartItems,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff062B57),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "عرض الأدوية",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_left, size: 21),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.business_outlined, size: 65, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            "لا توجد شركات مطابقة",
            style: TextStyle(
              color: Color(0xff0A2954),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "جرّبي تغيير كلمة البحث أو الفلتر",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
