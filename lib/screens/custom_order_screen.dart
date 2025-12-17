// screens/custom_order_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frame_it_up/services/storage_service.dart';
import 'package:frame_it_up/widgets/background_wrapper.dart';

class CustomOrderScreen extends StatefulWidget {
  const CustomOrderScreen({Key? key}) : super(key: key);

  @override
  _CustomOrderScreenState createState() => _CustomOrderScreenState();
}

class _CustomOrderScreenState extends State<CustomOrderScreen> {
  // Use TextEditingController for manual inputs
  final TextEditingController _widthController =
      TextEditingController(text: '12');
  final TextEditingController _heightController =
      TextEditingController(text: '12');
  final TextEditingController _additionalCostController =
      TextEditingController(text: '0');

  String profileSize = '1 Inch Frame';
  String frameType = 'MDF';
  int quantity = 1;

  // New fields for customer details functionality (can be expanded later if needed for custom orders too)
  String customerName = '';
  String phoneNumber = '';
  String deliveryAddress = '';

  final StorageService _storageService = StorageService();

  final List<String> profileSizes = [
    '.5 inch Profile',
    '.75 inch Profile',
    '.75 Inch Frame',
    '1 Inch Frame',
    '1.5 Inch Frame',
    '2.5 Inch Frame',
  ];

  final Map<String, List<Map<String, dynamic>>> framePrices = {
    '.5 inch Profile': [
      {'size': '3x3', 'mdf': 22, 'hdf': 23},
      {'size': '4x4', 'mdf': 29, 'hdf': 30},
      {'size': '4x6', 'mdf': 37, 'hdf': 39},
      {'size': '7x5', 'mdf': 47, 'hdf': 49},
      {'size': '8x6', 'mdf': 57, 'hdf': 60},
      {'size': '6x9', 'mdf': 62, 'hdf': 65},
      {'size': '8x12', 'mdf': 96, 'hdf': 101},
    ],
    '.75 inch Profile': [
      {'size': '8x12', 'mdf': 99, 'hdf': 104},
    ],
    '.75 Inch Frame': [
      {'size': '12x12', 'mdf': 134, 'hdf': 141},
      {'size': '12x15', 'mdf': 161, 'hdf': 169},
    ],
    '1 Inch Frame': [
      {'size': '12x12', 'mdf': 158, 'hdf': 166},
      {'size': '12x15', 'mdf': 187, 'hdf': 196},
      {'size': '15x15', 'mdf': 222, 'hdf': 233},
      {'size': '12x18', 'mdf': 217, 'hdf': 228},
    ],
    '1.5 Inch Frame': [
      {'size': '15x15', 'mdf': 352, 'hdf': 370},
      {'size': '12x18', 'mdf': 346, 'hdf': 363},
      {'size': '18x18', 'mdf': 449, 'hdf': 471},
      {'size': '18x24', 'mdf': 552, 'hdf': 580},
    ],
    '2.5 Inch Frame': [
      {'size': '18x18', 'mdf': 713, 'hdf': 749},
      {'size': '18x24', 'mdf': 853, 'hdf': 896},
      {'size': '24x30', 'mdf': 1175, 'hdf': 1234},
    ],
  };

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    _additionalCostController.dispose();
    super.dispose();
  }

  int getPrice() {
    int w = int.tryParse(_widthController.text) ?? 12;
    int h = int.tryParse(_heightController.text) ?? 12;
    String sizeKey = '${w}x${h}';

    int basePrice = 0;

    if (framePrices.containsKey(profileSize)) {
      bool found = false;
      for (var price in framePrices[profileSize]!) {
        if (price['size'] == sizeKey) {
          basePrice = frameType == 'MDF' ? price['mdf'] : price['hdf'];
          found = true;
          break;
        }
      }

      if (!found) {
        // Approximate calculation if exact size not in table
        double calculated = w * h * 1.5;
        if (profileSize == '1.5 Inch Frame') calculated *= 1.5;
        if (profileSize == '2.5 Inch Frame') calculated *= 2.5;
        basePrice = calculated.toInt();
      }
    } else {
      double calculated = w * h * 1.5;
      basePrice = calculated.toInt();
    }

    // Add optional manual additional cost to the unit price
    int additional = int.tryParse(_additionalCostController.text) ?? 0;
    return basePrice + additional;
  }

  @override
  Widget build(BuildContext context) {
    int unitPrice = getPrice();
    int totalPrice = unitPrice * quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Order', style: TextStyle(fontSize: 20.sp)),
        backgroundColor: Colors.deepPurple,
      ),
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Size Selection
              Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Custom Size (Inches)',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _widthController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Width',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: TextField(
                              controller: _heightController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Height',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Frame Type Selection
              Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Frame Details',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('MDF',
                                  style: TextStyle(fontSize: 14.sp)),
                              value: 'MDF',
                              groupValue: frameType,
                              onChanged: (value) {
                                setState(() {
                                  frameType = value.toString();
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('HDF',
                                  style: TextStyle(fontSize: 14.sp)),
                              value: 'HDF',
                              groupValue: frameType,
                              onChanged: (value) {
                                setState(() {
                                  frameType = value.toString();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      DropdownButtonFormField(
                        value: profileSize,
                        decoration: const InputDecoration(
                          labelText: 'Profile Size',
                          border: OutlineInputBorder(),
                        ),
                        items: profileSizes.map((size) {
                          return DropdownMenuItem(
                              value: size,
                              child: Text(size,
                                  style: TextStyle(fontSize: 14.sp)));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            profileSize = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Additional Cost Section
              Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional Charges',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextField(
                        controller: _additionalCostController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Extra Cost (e.g. glass, mount)',
                          border: OutlineInputBorder(),
                          prefixText: '₹ ',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Quantity Selection
              Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) quantity--;
                              });
                            },
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              quantity.toString(),
                              style: TextStyle(fontSize: 18.sp),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Price Display
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Unit Price (incl. extras):',
                            style: TextStyle(fontSize: 16.sp)),
                        Text(
                          '₹$unitPrice',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    const Divider(),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹$totalPrice',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Place Order Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    _placeCustomOrder();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'PLACE CUSTOM ORDER',
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _placeCustomOrder() {
    // Show order summary and save order
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Order Summary'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Size: ${_widthController.text} x ${_heightController.text} inches'),
              Text('Profile: $profileSize'),
              Text('Frame Type: $frameType'),
              Text('Detail: Extras ₹${_additionalCostController.text}'),
              Text('Quantity: $quantity'),
              SizedBox(height: 10.h),
              Text(
                'Total Price: ₹${getPrice() * quantity}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Save order
              final order = {
                'type': 'Custom',
                'size': '${_widthController.text}x${_heightController.text}',
                'profile': profileSize,
                'frameType': frameType,
                'additionalCost': _additionalCostController.text,
                'quantity': quantity,
                'totalPrice': getPrice() * quantity,
                'status': 'Pending',
                'date': DateTime.now().toString().split(' ')[0],
              };

              await _storageService.saveOrder(order);

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Custom order placed successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context); // Return to home
              }
            },
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }
}
