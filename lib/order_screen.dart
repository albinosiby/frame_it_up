import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  String selectedSize = 'A4';
  String searchQuery = '';

  final Map<String, int> framePrices = {'A3': 680, 'A4': 380, 'A5': 280};

  List<FrameOrder> orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  // ---------------- STORAGE ----------------
  Future<void> saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = orders.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('orders', data);
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('orders') ?? [];
    setState(() {
      orders = data.map((e) => FrameOrder.fromJson(jsonDecode(e))).toList();
    });
  }

  // ---------------- ADD ----------------
  void addOrder() {
    if (nameController.text.isEmpty) return;

    setState(() {
      orders.add(
        FrameOrder(
          customerName: nameController.text,
          size: selectedSize,
          price: framePrices[selectedSize]!,
        ),
      );
    });

    saveOrders();
    nameController.clear();
    Navigator.pop(context);
  }

  // ---------------- UPDATE STATUS ----------------
  void updateStatus(FrameOrder order) {
    setState(() {
      if (order.status == OrderStatus.pending) {
        order.status = OrderStatus.inProgress;
      } else if (order.status == OrderStatus.inProgress) {
        order.status = OrderStatus.ready;
      } else if (order.status == OrderStatus.ready) {
        order.status = OrderStatus.delivered;
      }
    });
    saveOrders();
  }

  // ---------------- DELETE ----------------
  void deleteOrder(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Order'),
        content: const Text('Are you sure you want to delete this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => orders.removeAt(index));
              saveOrders();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ---------------- EDIT ----------------
  void editOrder(FrameOrder order) {
    nameController.text = order.customerName;
    selectedSize = order.size;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 20.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Order',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.h),
            DropdownButtonFormField<String>(
              value: selectedSize,
              decoration: const InputDecoration(
                labelText: 'Frame Size',
                border: OutlineInputBorder(),
              ),
              items: framePrices.keys.map((size) {
                return DropdownMenuItem(
                  value: size,
                  child: Text('$size (₹${framePrices[size]})'),
                );
              }).toList(),
              onChanged: (v) => setState(() => selectedSize = v!),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  order.customerName = nameController.text;
                  order.size = selectedSize;
                  order.price = framePrices[selectedSize]!;
                });
                saveOrders();
                nameController.clear();
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------
  Color statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.inProgress:
        return Colors.blue;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.grey;
    }
  }

  String statusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final filteredOrders = orders.where((o) {
      return o.customerName.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Frame It Up'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddOrderSheet,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: EdgeInsets.all(12.w),
            child: TextField(
              controller: searchController,
              onChanged: (v) => setState(() => searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search customer...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
            ),
          ),

          // ORDER LIST
          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(child: Text('No orders found'))
                : ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: ListTile(
                          title: Text(
                            order.customerName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${order.size} • ₹${order.price}\n${statusText(order.status)}',
                          ),
                          isThreeLine: true,
                          leading: CircleAvatar(
                            backgroundColor: statusColor(order.status),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => editOrder(order),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    deleteOrder(orders.indexOf(order)),
                              ),
                            ],
                          ),
                          onTap: order.status != OrderStatus.delivered
                              ? () => updateStatus(order)
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------- ADD SHEET ----------------
  void showAddOrderSheet() {
    nameController.clear();
    selectedSize = 'A4';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 20.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'New Order',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.h),
            DropdownButtonFormField<String>(
              value: selectedSize,
              decoration: const InputDecoration(
                labelText: 'Frame Size',
                border: OutlineInputBorder(),
              ),
              items: framePrices.keys.map((size) {
                return DropdownMenuItem(
                  value: size,
                  child: Text('$size (₹${framePrices[size]})'),
                );
              }).toList(),
              onChanged: (v) => setState(() => selectedSize = v!),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(onPressed: addOrder, child: const Text('Add Order')),
          ],
        ),
      ),
    );
  }
}
