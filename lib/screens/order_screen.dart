// screens/order_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frame_it_up/services/storage_service.dart';
import 'package:frame_it_up/widgets/background_wrapper.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final Map<String, int> standardPrices = {
    '6x4': 250,
    'A5': 280,
    'A4': 380,
    'A3': 680,
  };

  String selectedSize = 'A4';
  int quantity = 1;
  String frameType = 'MDF';
  String customerName = '';
  String phoneNumber = '';
  String deliveryAddress = '';

  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    int totalPrice = (standardPrices[selectedSize] ?? 0) * quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text('New Order - Standard Size',
            style: TextStyle(fontSize: 20.sp)),
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
                        'Select Size',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        children: standardPrices.entries.map((entry) {
                          return ChoiceChip(
                            label: Text('${entry.key} - ₹${entry.value}',
                                style: TextStyle(fontSize: 14.sp)),
                            selected: selectedSize == entry.key,
                            selectedColor: Colors.deepPurple,
                            labelStyle: TextStyle(
                                color: selectedSize == entry.key
                                    ? Colors.white
                                    : Colors.white,
                                fontSize: 14.sp),
                            onSelected: (selected) {
                              setState(() {
                                selectedSize = entry.key;
                              });
                            },
                          );
                        }).toList(),
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
                        'Frame Type',
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
                              title: Text('MDF Frame',
                                  style: TextStyle(fontSize: 16.sp)),
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
                              title: Text('HDF Frame',
                                  style: TextStyle(fontSize: 16.sp)),
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

              // Customer Details
              Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Details',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Customer Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        onChanged: (value) {
                          setState(() {
                            customerName = value;
                          });
                        },
                      ),
                      SizedBox(height: 15.h),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          setState(() {
                            phoneNumber = value;
                          });
                        },
                      ),
                      SizedBox(height: 15.h),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Delivery Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          setState(() {
                            deliveryAddress = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // Total Price
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price:',
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
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
              ),

              SizedBox(height: 20.h),

              // Place Order Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    _placeOrder();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'PLACE ORDER',
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

  void _placeOrder() {
    if (customerName.isEmpty ||
        phoneNumber.isEmpty ||
        deliveryAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all customer details'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog before saving
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Size: $selectedSize'),
            Text('Frame Type: $frameType'),
            Text('Quantity: $quantity'),
            Text('Customer: $customerName'),
            SizedBox(height: 10.h),
            Text(
              'Total: ₹${(standardPrices[selectedSize] ?? 0) * quantity}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Save order using StorageService
              final order = {
                'type': 'Standard',
                'size': selectedSize,
                'frameType': frameType,
                'quantity': quantity,
                'customerName': customerName,
                'phoneNumber': phoneNumber,
                'deliveryAddress': deliveryAddress,
                'totalPrice': (standardPrices[selectedSize] ?? 0) * quantity,
                'status': 'Pending',
                'date': DateTime.now().toString().split(' ')[0],
              };

              await _storageService.saveOrder(order);

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order placed successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
