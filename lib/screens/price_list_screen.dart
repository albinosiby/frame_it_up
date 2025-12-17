// screens/price_list_screen.dart
import 'package:flutter/material.dart';
import 'package:frame_it_up/widgets/background_wrapper.dart';

class FramePrice {
  final String size;
  final String profileSize;
  final int mdfPrice;
  final int hdfPrice;

  FramePrice({
    required this.size,
    required this.profileSize,
    required this.mdfPrice,
    required this.hdfPrice,
  });
}

class PriceListScreen extends StatefulWidget {
  const PriceListScreen({Key? key}) : super(key: key);

  @override
  _PriceListScreenState createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  List<FramePrice> framePrices = [
    FramePrice(
      size: "3 x 3",
      profileSize: ".5 inch Profile",
      mdfPrice: 22,
      hdfPrice: 23,
    ),
    FramePrice(
      size: "4 x 4",
      profileSize: ".5 inch Profile",
      mdfPrice: 29,
      hdfPrice: 30,
    ),
    FramePrice(
      size: "4 x 6",
      profileSize: ".5 inch Profile",
      mdfPrice: 37,
      hdfPrice: 39,
    ),
    FramePrice(
      size: "7 x 5",
      profileSize: ".5 inch Profile",
      mdfPrice: 47,
      hdfPrice: 49,
    ),
    FramePrice(
      size: "8 x 6",
      profileSize: ".5 inch Profile",
      mdfPrice: 57,
      hdfPrice: 60,
    ),
    FramePrice(
      size: "6 x 9",
      profileSize: ".5 inch Profile",
      mdfPrice: 62,
      hdfPrice: 65,
    ),
    FramePrice(
      size: "8 x 12",
      profileSize: ".5 inch Profile",
      mdfPrice: 96,
      hdfPrice: 101,
    ),
    FramePrice(
      size: "8 x 12",
      profileSize: ".75 inch Profile",
      mdfPrice: 99,
      hdfPrice: 104,
    ),
    FramePrice(
      size: "12 x 12",
      profileSize: ".75 Inch Frame",
      mdfPrice: 134,
      hdfPrice: 141,
    ),
    FramePrice(
      size: "12 x 12",
      profileSize: "1 Inch Frame",
      mdfPrice: 158,
      hdfPrice: 166,
    ),
    FramePrice(
      size: "12 x 15",
      profileSize: ".75 Inch Frame",
      mdfPrice: 161,
      hdfPrice: 169,
    ),
    FramePrice(
      size: "12 x 15",
      profileSize: "1 Inch Frame",
      mdfPrice: 187,
      hdfPrice: 196,
    ),
    FramePrice(
      size: "15 x 15",
      profileSize: "1 Inch Frame",
      mdfPrice: 222,
      hdfPrice: 233,
    ),
    FramePrice(
      size: "15 x 15",
      profileSize: "1.5 Inch Frame",
      mdfPrice: 352,
      hdfPrice: 370,
    ),
    FramePrice(
      size: "12 x 18",
      profileSize: "1 Inch Frame",
      mdfPrice: 217,
      hdfPrice: 228,
    ),
    FramePrice(
      size: "12 x 18",
      profileSize: "1.5 Inch Frame",
      mdfPrice: 346,
      hdfPrice: 363,
    ),
    FramePrice(
      size: "18 x 18",
      profileSize: "1.5 Inch Frame",
      mdfPrice: 449,
      hdfPrice: 471,
    ),
    FramePrice(
      size: "18 x 18",
      profileSize: "2.5 Inch Frame",
      mdfPrice: 713,
      hdfPrice: 749,
    ),
    FramePrice(
      size: "18 x 24",
      profileSize: "1.5 Inch Frame",
      mdfPrice: 552,
      hdfPrice: 580,
    ),
    FramePrice(
      size: "18 x 24",
      profileSize: "2.5 Inch Frame",
      mdfPrice: 853,
      hdfPrice: 896,
    ),
    FramePrice(
      size: "24 x 30",
      profileSize: "2.5 Inch Frame",
      mdfPrice: 1175,
      hdfPrice: 1234,
    ),
  ];

  List<String> standardSizes = [
    '6x4 - ₹250',
    'A5 - ₹280',
    'A4 - ₹380',
    'A3 - ₹680',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frame Price List'),
        backgroundColor: Colors.deepPurple,
      ),
      body: BackgroundWrapper(
        child: Column(
          children: [
            // Standard Sizes Card
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Standard Size Prices',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      children: standardSizes.map((size) {
                        return Chip(
                          label: Text(size),
                          backgroundColor: Colors.amber[100],
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Frame Prices Table
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Custom Frame Prices (Vendor Rates)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.deepPurple.withOpacity(0.1),
                      ),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Size\n(Inch)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Profile\nSize',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'MDF\nFrame (₹)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'HDF\nFrame (₹)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: framePrices.map((price) {
                        return DataRow(
                          cells: [
                            DataCell(Text(price.size)),
                            DataCell(Text(price.profileSize)),
                            DataCell(Text('₹${price.mdfPrice}')),
                            DataCell(Text('₹${price.hdfPrice}')),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
