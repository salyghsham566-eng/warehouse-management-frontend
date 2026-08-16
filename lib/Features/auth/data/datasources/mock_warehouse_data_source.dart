import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:project_2/Features/auth/data/datasources/warehouse_data_source.dart';
import 'package:project_2/Features/auth/data/models/warehouse_company_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_inventory_file_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_medicine_details_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_medicine_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_overview_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_stock_item_model.dart';

class MockWarehouseDataSource
    implements WarehouseDataSource {
  @override
  Future<WarehouseOverviewModel>
      getWarehouseOverview() async {
    await Future<void>.delayed(
      const Duration(
        milliseconds: 450,
      ),
    );

    return const WarehouseOverviewModel(
      hasLowStockItems: true,
      hasOutOfStockItems: true,
      hasInventoryFile: true,
      inventoryFileName:
          'جرد المستودع - آب 2026.pdf',
    );
  }

  @override
  Future<List<WarehouseCompanyModel>>
      getWarehouseCompanies() async {
    await Future<void>.delayed(
      const Duration(
        milliseconds: 400,
      ),
    );

    return const [
      WarehouseCompanyModel(
        id: 'company-1',
        name: 'ابن حيان للصناعات الدوائية',
        itemsCount: 4,
      ),
      WarehouseCompanyModel(
        id: 'company-2',
        name: 'يونيفارما',
        itemsCount: 4,
      ),
      WarehouseCompanyModel(
        id: 'company-3',
        name: 'آسيا للصناعات الدوائية',
        itemsCount: 31,
      ),
      WarehouseCompanyModel(
        id: 'company-4',
        name: 'الرازي للصناعات الدوائية',
        itemsCount: 15,
      ),
      WarehouseCompanyModel(
        id: 'company-5',
        name: 'دلتا فارما',
      ),
    ];
  }
  @override
Future<List<WarehouseMedicineModel>>
    getWarehouseCompanyMedicines(
  String companyId,
) async {
  await Future<void>.delayed(
    const Duration(milliseconds: 400),
  );

  switch (companyId) {
    case 'company-1':
      return const [
        WarehouseMedicineModel(
          id: 'medicine-1',
          tradeName: 'سيتامول 500',
          scientificName: 'Paracetamol',
        ),
        WarehouseMedicineModel(
          id: 'medicine-2',
          tradeName: 'Amoclan 625',
          scientificName:
              'Amoxicillin + Clavulanic Acid',
        ),
        WarehouseMedicineModel(
          id: 'medicine-3',
          tradeName: 'Loratan 10',
          scientificName: 'Loratadine',
        ),
        WarehouseMedicineModel(
          id: 'medicine-4',
          tradeName: 'Omepra 20',
          scientificName: 'Omeprazole',
        ),
      ];

    case 'company-2':
      return const [
        WarehouseMedicineModel(
          id: 'medicine-5',
          tradeName: 'Univit C',
          scientificName: 'Ascorbic Acid',
        ),
        WarehouseMedicineModel(
          id: 'medicine-6',
          tradeName: 'Diclofast 50',
          scientificName: 'Diclofenac Sodium',
        ),
        WarehouseMedicineModel(
          id: 'medicine-7',
          tradeName: 'Metformin Uni 500',
          scientificName: 'Metformin HCl',
        ),
        WarehouseMedicineModel(
          id: 'medicine-8',
          tradeName: 'Azithro Uni 500',
          scientificName: 'Azithromycin',
        ),
      ];

    case 'company-3':
      return const [
        WarehouseMedicineModel(
          id: 'medicine-9',
          tradeName: 'Asia Cold',
          scientificName:
              'Paracetamol + Chlorpheniramine',
        ),
        WarehouseMedicineModel(
          id: 'medicine-10',
          tradeName: 'Cefixime Asia 400',
          scientificName: 'Cefixime',
        ),
        WarehouseMedicineModel(
          id: 'medicine-11',
          tradeName: 'Pantoprazole Asia 40',
          scientificName: 'Pantoprazole',
        ),
        WarehouseMedicineModel(
          id: 'medicine-12',
          tradeName: 'Ibuprofen Asia 400',
          scientificName: 'Ibuprofen',
        ),
      ];

    case 'company-4':
      return const [
        WarehouseMedicineModel(
          id: 'medicine-13',
          tradeName: 'Razi Pain',
          scientificName: 'Ibuprofen',
        ),
        WarehouseMedicineModel(
          id: 'medicine-14',
          tradeName: 'Razi Cough',
          scientificName: 'Dextromethorphan',
        ),
        WarehouseMedicineModel(
          id: 'medicine-15',
          tradeName: 'Razi Zinc',
          scientificName: 'Zinc Sulfate',
        ),
        WarehouseMedicineModel(
          id: 'medicine-16',
          tradeName: 'Razi B12',
          scientificName: 'Cyanocobalamin',
        ),
      ];

    case 'company-5':
      return const [
        WarehouseMedicineModel(
          id: 'medicine-17',
          tradeName: 'Delta Vita D3',
          scientificName: 'Cholecalciferol',
        ),
        WarehouseMedicineModel(
          id: 'medicine-18',
          tradeName: 'Delta Calcium',
          scientificName: 'Calcium Carbonate',
        ),
        WarehouseMedicineModel(
          id: 'medicine-19',
          tradeName: 'Delta Omega',
          scientificName: 'Omega-3 Fatty Acids',
        ),
      ];

    default:
      return const [];
  }
}@override
Future<WarehouseMedicineDetailsModel>
    getWarehouseMedicineDetails(
  String medicineId,
) async {
  await Future<void>.delayed(
    const Duration(milliseconds: 350),
  );

  const medicines = <String, List<Object?>>{
    'medicine-1': [
      'سيتامول 500',
      'Paracetamol',
      'ابن حيان للصناعات الدوائية',
      8500.0,
      'خصم 10%',
      '2027-12-31',
      'صالح',
      'متوفر',
    ],
    'medicine-2': [
      'Amoclan 625',
      'Amoxicillin + Clavulanic Acid',
      'ابن حيان للصناعات الدوائية',
      26500.0,
      null,
      '2027-08-20',
      'صالح',
      'متوفر',
    ],
    'medicine-3': [
      'Loratan 10',
      'Loratadine',
      'ابن حيان للصناعات الدوائية',
      11000.0,
      null,
      '2026-11-15',
      'قريب الانتهاء',
      'قابل للنفاد',
    ],
    'medicine-4': [
      'Omepra 20',
      'Omeprazole',
      'ابن حيان للصناعات الدوائية',
      14500.0,
      'عرض خاص للصيدليات',
      '2028-02-10',
      'صالح',
      'متوفر',
    ],

    'medicine-5': [
      'Univit C',
      'Ascorbic Acid',
      'يونيفارما',
      9500.0,
      null,
      '2027-05-22',
      'صالح',
      'متوفر',
    ],
    'medicine-6': [
      'Diclofast 50',
      'Diclofenac Sodium',
      'يونيفارما',
      12000.0,
      null,
      '2026-10-01',
      'قريب الانتهاء',
      'قابل للنفاد',
    ],
    'medicine-7': [
      'Metformin Uni 500',
      'Metformin HCl',
      'يونيفارما',
      16000.0,
      'خصم 5%',
      '2028-01-15',
      'صالح',
      'متوفر',
    ],
    'medicine-8': [
      'Azithro Uni 500',
      'Azithromycin',
      'يونيفارما',
      28500.0,
      null,
      '2027-07-18',
      'صالح',
      'غير متوفر',
    ],

    'medicine-9': [
      'Asia Cold',
      'Paracetamol + Chlorpheniramine',
      'آسيا للصناعات الدوائية',
      10500.0,
      null,
      '2027-04-12',
      'صالح',
      'متوفر',
    ],
    'medicine-10': [
      'Cefixime Asia 400',
      'Cefixime',
      'آسيا للصناعات الدوائية',
      32000.0,
      'خصم 8%',
      '2028-03-30',
      'صالح',
      'متوفر',
    ],
    'medicine-11': [
      'Pantoprazole Asia 40',
      'Pantoprazole',
      'آسيا للصناعات الدوائية',
      17500.0,
      null,
      '2026-09-20',
      'قريب الانتهاء',
      'قابل للنفاد',
    ],
    'medicine-12': [
      'Ibuprofen Asia 400',
      'Ibuprofen',
      'آسيا للصناعات الدوائية',
      9000.0,
      null,
      '2027-09-09',
      'صالح',
      'متوفر',
    ],

    'medicine-13': [
      'Razi Pain',
      'Ibuprofen',
      'الرازي للصناعات الدوائية',
      10000.0,
      null,
      '2027-06-01',
      'صالح',
      'متوفر',
    ],
    'medicine-14': [
      'Razi Cough',
      'Dextromethorphan',
      'الرازي للصناعات الدوائية',
      13500.0,
      null,
      '2026-08-01',
      'منتهي الصلاحية',
      'غير متوفر',
    ],
    'medicine-15': [
      'Razi Zinc',
      'Zinc Sulfate',
      'الرازي للصناعات الدوائية',
      8000.0,
      'خصم 5%',
      '2027-12-01',
      'صالح',
      'متوفر',
    ],
    'medicine-16': [
      'Razi B12',
      'Cyanocobalamin',
      'الرازي للصناعات الدوائية',
      11500.0,
      null,
      '2027-02-25',
      'صالح',
      'قابل للنفاد',
    ],

    'medicine-17': [
      'Delta Vita D3',
      'Cholecalciferol',
      'دلتا فارما',
      15000.0,
      null,
      '2028-04-10',
      'صالح',
      'متوفر',
    ],
    'medicine-18': [
      'Delta Calcium',
      'Calcium Carbonate',
      'دلتا فارما',
      18500.0,
      'خصم 12%',
      '2027-11-11',
      'صالح',
      'متوفر',
    ],
    'medicine-19': [
      'Delta Omega',
      'Omega-3 Fatty Acids',
      'دلتا فارما',
      24000.0,
      null,
      null,
      'غير محدد',
      'قابل للنفاد',
    ],
  };

  final data = medicines[medicineId];

  if (data == null) {
    throw Exception(
      'لم يتم العثور على بيانات الدواء',
    );
  }

  return WarehouseMedicineDetailsModel(
    id: medicineId,
    tradeName: data[0] as String,
    scientificName: data[1] as String,
    companyName: data[2] as String,
    price: data[3] as double?,
    offerText: data[4] as String?,
    expiryDate: data[5] as String?,
    expiryStatus: data[6] as String,
    availabilityStatus: data[7] as String,
  );
}@override
Future<List<WarehouseStockItemModel>>
    getWarehouseStockItems(
  WarehouseStockFilter filter,
) async {
  await Future<void>.delayed(
    const Duration(milliseconds: 400),
  );

  if (filter ==
      WarehouseStockFilter.lowStock) {
    return const [
      WarehouseStockItemModel(
        id: 'medicine-3',
        tradeName: 'Loratan 10',
        companyName:
            'ابن حيان للصناعات الدوائية',
        availabilityStatus:
            'قابل للنفاد',
        expiryDate: '2026-11-15',
        expiryStatus:
            'قريب الانتهاء',
      ),

      WarehouseStockItemModel(
        id: 'medicine-6',
        tradeName: 'Diclofast 50',
        companyName: 'يونيفارما',
        availabilityStatus:
            'قابل للنفاد',
        expiryDate: '2026-10-01',
        expiryStatus:
            'قريب الانتهاء',
      ),

      WarehouseStockItemModel(
        id: 'medicine-11',
        tradeName:
            'Pantoprazole Asia 40',
        companyName:
            'آسيا للصناعات الدوائية',
        availabilityStatus:
            'قابل للنفاد',
        expiryDate: '2026-09-20',
        expiryStatus:
            'قريب الانتهاء',
      ),

      WarehouseStockItemModel(
        id: 'medicine-16',
        tradeName: 'Razi B12',
        companyName:
            'الرازي للصناعات الدوائية',
        availabilityStatus:
            'قابل للنفاد',
        expiryDate: '2027-02-25',
        expiryStatus: 'صالح',
      ),

      WarehouseStockItemModel(
        id: 'medicine-19',
        tradeName: 'Delta Omega',
        companyName: 'دلتا فارما',
        availabilityStatus:
            'قابل للنفاد',
        expiryDate: null,
        expiryStatus: 'غير محدد',
      ),
    ];
  }

  return const [
    WarehouseStockItemModel(
      id: 'medicine-8',
      tradeName: 'Azithro Uni 500',
      companyName: 'يونيفارما',
      availabilityStatus:
          'غير متوفر',
      expiryDate: '2027-07-18',
      expiryStatus: 'صالح',
    ),

    WarehouseStockItemModel(
      id: 'medicine-14',
      tradeName: 'Razi Cough',
      companyName:
          'الرازي للصناعات الدوائية',
      availabilityStatus:
          'غير متوفر',
      expiryDate: '2026-08-01',
      expiryStatus:
          'منتهي الصلاحية',
    ),
  ];
}// =========================================================
// UC-232
// =========================================================
@override
Future<WarehouseInventoryFileModel?>
    getWarehouseInventoryFile() async {
  await Future<void>.delayed(
    const Duration(milliseconds: 350),
  );

  return const WarehouseInventoryFileModel(
    id: 'inventory-aug-2026',
    fileName: 'جرد المستودع - آب 2026.pdf',
    uploadedAt: '2026-08-15 14:30',
    uploadedBy: 'محمد خالد - المفوتر',
    notes:
        'ملف الجرد الدوري الأخير للمستودع.',
  );
}

// =========================================================
// UC-233 + UC-234
// =========================================================
@override
Future<Uint8List> getWarehouseInventoryPdf(
  String fileId,
) async {
  await Future<void>.delayed(
    const Duration(milliseconds: 400),
  );

  if (fileId != 'inventory-aug-2026') {
    throw Exception(
      'لم يتم العثور على ملف الجرد',
    );
  }

  final regularFont =
      await PdfGoogleFonts.cairoRegular();

  final boldFont =
      await PdfGoogleFonts.cairoBold();

  final document = pw.Document(
    title: 'جرد المستودع - آب 2026',
    author: 'قسم الفوترة',
  );

  final pageTheme = pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(28),
    theme: pw.ThemeData.withFont(
      base: regularFont,
      bold: boldFont,
    ),
    textDirection: pw.TextDirection.rtl,
  );

  final rows = List.generate(
    55,
    (index) {
      final availability =
          index % 7 == 0
              ? 'غير متوفر'
              : index % 4 == 0
                  ? 'قابل للنفاد'
                  : 'متوفر';

      final expiryStatus =
          index % 9 == 0
              ? 'قريب الانتهاء'
              : 'صالح';

      return [
        'صنف دوائي تجريبي',
        index % 2 == 0
            ? 'يونيفارما'
            : 'ابن حيان',
        availability,
        expiryStatus,
      ];
    },
  );

  document.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      header: (context) {
        return pw.Container(
          margin:
              const pw.EdgeInsets.only(
            bottom: 14,
          ),
          child: pw.Text(
            'ملف جرد المستودع',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 18,
              color: PdfColors.blue900,
            ),
          ),
        );
      },
      footer: (context) {
        return pw.Align(
          alignment:
              pw.Alignment.center,
          child: pw.Text(
            'صفحة ${context.pageNumber} من '
            '${context.pagesCount}',
            style: const pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey600,
            ),
          ),
        );
      },
      build: (context) {
        return [
          pw.Container(
            width: double.infinity,
            padding:
                const pw.EdgeInsets.all(14),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius:
                  pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment:
                  pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'تاريخ الرفع: 2026-08-15',
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'المفوتر: محمد خالد',
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'ملاحظة: لا تظهر الكميات الرقمية للمندوب.',
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 18),

          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.6,
            ),
            children: [
              pw.TableRow(
                decoration:
                    const pw.BoxDecoration(
                  color: PdfColors.blue100,
                ),
                children: [
                  'الصنف',
                  'الشركة',
                  'التوفر',
                  'الصلاحية',
                ]
                    .map(
                      (text) => pw.Padding(
                        padding:
                            const pw.EdgeInsets.all(
                          7,
                        ),
                        child: pw.Text(
                          text,
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              ...rows.map(
                (row) => pw.TableRow(
                  children: row
                      .map(
                        (text) =>
                            pw.Padding(
                          padding:
                              const pw.EdgeInsets
                                  .all(7),
                          child: pw.Text(
                            text,
                            style:
                                const pw.TextStyle(
                              fontSize: 8.5,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ];
      },
    ),
  );

  return document.save();
}
}
