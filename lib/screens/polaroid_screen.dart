// screens/polaroid_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frame_it_up/services/storage_service.dart';
import 'package:frame_it_up/widgets/background_wrapper.dart';

class PolaroidScreen extends StatefulWidget {
  const PolaroidScreen({Key? key}) : super(key: key);

  @override
  _PolaroidScreenState createState() => _PolaroidScreenState();
}

class _PolaroidScreenState extends State<PolaroidScreen> {
  int quantity = 1; // Number of sets (1 set = 20 photos)
  static const int photosPerSet = 20;
  static const int pricePerSet = 210;

  String customerName = '';
  String phoneNumber = '';
  String deliveryAddress = '';

  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    int totalPhotos = quantity * photosPerSet;
    int totalPrice = quantity * pricePerSet;

    return Scaffold(
      appBar: AppBar(
        title: Text('Polaroid Prints', style: TextStyle(fontSize: 20.sp)),
        backgroundColor: Colors.deepPurple,
      ),
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Polaroid Info
              Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Polaroid Package',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '$photosPerSet Photos per set',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      Text(
                        '₹$pricePerSet per set',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
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
                        'Quantity (Sets)',
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
                      SizedBox(height: 10.h),
                      Text(
                        'Total Photos: $totalPhotos',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
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
            Text('Package: Polaroid ($quantity sets)'),
            Text('Total Photos: ${quantity * photosPerSet}'),
            Text('Customer: $customerName'),
            SizedBox(height: 10.h),
            Text(
              'Total: ₹${quantity * pricePerSet}',
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
                'type': 'Polaroid',
                'quantity': quantity, // Sets
                'totalPhotos': quantity * photosPerSet,
                'customerName': customerName,
                'phoneNumber': phoneNumber,
                'deliveryAddress': deliveryAddress,
                'totalPrice': quantity * pricePerSet,
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
