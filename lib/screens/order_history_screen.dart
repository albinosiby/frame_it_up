// screens/order_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frame_it_up/services/storage_service.dart';
import 'package:frame_it_up/widgets/background_wrapper.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final StorageService _storageService = StorageService();
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final orders = await _storageService.getOrders();
    setState(() {
      _orders = orders.reversed.toList(); // Show newest first
    });
  }

  Future<void> _clearHistory() async {
    await _storageService.clearOrders();
    _loadOrders();
  }

  Future<void> _updateStatus(int index, Map<String, dynamic> order) async {
    // Determine the actual index in the storage list (since _orders is reversed)
    // _orders[0] is the Last item in storage.
    // Storage: [Order1, Order2, Order3] -> len 3
    // UI: [Order3, Order2, Order1]
    // UI Index 0 -> Order3 (Storage Index 2) -> 3 - 1 - 0 = 2

    // We need to fetch fresh list size to be safe, or assume _orders matches storage
    int storageIndex = (_orders.length - 1) - index;

    String? newStatus = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Update Status'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Pending'),
            child:
                const Text('Pending', style: TextStyle(color: Colors.orange)),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'In Progress'),
            child:
                const Text('In Progress', style: TextStyle(color: Colors.blue)),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Completed'),
            child:
                const Text('Completed', style: TextStyle(color: Colors.green)),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Delivered'),
            child:
                const Text('Delivered', style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );

    if (newStatus != null && newStatus != order['status']) {
      final updatedOrder = Map<String, dynamic>.from(order);
      updatedOrder['status'] = newStatus;

      await _storageService.updateOrder(storageIndex, updatedOrder);
      _loadOrders(); // Reload UI

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status updated to $newStatus')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History', style: TextStyle(fontSize: 20.sp)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear History?'),
                  content: const Text('This will delete all stored orders.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearHistory();
                      },
                      child: const Text('Clear',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: BackgroundWrapper(
        child: _orders.isEmpty
            ? Center(
                child: Text(
                  'No orders yet',
                  style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  final String type = order['type']?.toString() ?? 'Standard';
                  final String date =
                      order['date']?.toString() ?? 'Unknown Date';
                  final String status =
                      order['status']?.toString() ?? 'Pending';
                  final int totalPrice =
                      (order['totalPrice'] as num?)?.toInt() ?? 0;

                  Color typeColor;
                  if (type == 'Custom') {
                    typeColor = Colors.amber;
                  } else if (type == 'Polaroid') {
                    typeColor = Colors.pink;
                  } else {
                    typeColor = Colors.deepPurple;
                  }

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 16.h),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: typeColor.withOpacity(0.2),
                        child: Icon(
                          type == 'Polaroid'
                              ? Icons.camera_alt
                              : (type == 'Custom'
                                  ? Icons.dashboard_customize
                                  : Icons.crop_portrait),
                          color: typeColor,
                          size: 20.sp,
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$type Order',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.sp),
                          ),
                          // Edit Status Button
                          IconButton(
                            icon: Icon(Icons.edit,
                                size: 20.sp, color: Colors.grey),
                            onPressed: () => _updateStatus(index, order),
                            tooltip: 'Update Status',
                          ),
                        ],
                      ),
                      subtitle: Text(
                        'Date: $date\nStatus: $status',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      trailing: Text(
                        '₹$totalPrice',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: Colors.green,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Status', status),
                              _buildDetailRow(
                                  'Customer', order['customerName'] ?? 'N/A'),
                              _buildDetailRow(
                                  'Phone', order['phoneNumber'] ?? 'N/A'),
                              _buildDetailRow(
                                  'Address', order['deliveryAddress'] ?? 'N/A'),
                              Divider(),
                              if (type == 'Polaroid') ...[
                                _buildDetailRow('Sets', '${order['quantity']}'),
                                _buildDetailRow('Dimensions', '20 Photos/Set'),
                              ] else ...[
                                _buildDetailRow('Size', order['size'] ?? 'N/A'),
                                _buildDetailRow(
                                    'Frame Type', order['frameType'] ?? 'N/A'),
                                if (type == 'Custom')
                                  _buildDetailRow(
                                      'Profile', order['profile'] ?? 'N/A'),
                                _buildDetailRow(
                                    'Quantity', '${order['quantity']}'),
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
