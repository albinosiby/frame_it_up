enum OrderStatus { pending, inProgress, ready, delivered }

class FrameOrder {
  String customerName;
  String size;
  int price;
  OrderStatus status;

  FrameOrder({
    required this.customerName,
    required this.size,
    required this.price,
    this.status = OrderStatus.pending,
  });

  Map<String, dynamic> toJson() => {
    'customerName': customerName,
    'size': size,
    'price': price,
    'status': status.index,
  };

  factory FrameOrder.fromJson(Map<String, dynamic> json) {
    return FrameOrder(
      customerName: json['customerName'],
      size: json['size'],
      price: json['price'],
      status: OrderStatus.values[json['status']],
    );
  }
}
