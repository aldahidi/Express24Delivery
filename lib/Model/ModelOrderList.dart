import 'package:delivery_boy/BLoC/CommonBlocClass/BaseMode.dart';

class ResOrderList extends BaseModel {
  int code;
  String message;
  List<Order> orderList;

  ResOrderList({this.code, this.message, this.orderList});

  ResOrderList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      // ignore: deprecated_member_use
      orderList = new List<Order>();
      json['result'].forEach((v) {
        orderList.add(new Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.orderList != null) {
      data['result'] = this.orderList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  String name;
  String bannerImage;
  String address;
  String pincode;
  String orderId;
  String trackingNumber;
  String orderStatus;
  String totalPrice;
  String created;
  String updated;
  String driverStatus;
  String userId;
  String orderStatusName;

  Order(
      {this.name,
      this.bannerImage,
      this.address,
      this.pincode,
      this.orderId,
      this.trackingNumber,
      this.orderStatus,
      this.totalPrice,
      this.created,
      this.updated,
      this.driverStatus,
      this.userId,
      this.orderStatusName});

  Order.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    bannerImage = json['banner_image'];
    address = json['address'];
    pincode = json['pincode'];
    orderId = json['order_id'];
    trackingNumber = json['trackingnumber'];
    orderStatus = json['order_status'];
    totalPrice = json['total_price'];
    created = json['created'];
    updated = json['updated'];
    driverStatus = json['driver_status'];
    userId = json['user_id'];
    orderStatusName = json['order_status_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['banner_image'] = this.bannerImage;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['order_id'] = this.orderId;
    data['trackingnumber'] = this.trackingNumber;
    data['order_status'] = this.orderStatus;
    data['total_price'] = this.totalPrice;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['driver_status'] = this.driverStatus;
    data['user_id'] = this.userId;
    data['order_status_name'] = this.orderStatusName;

    return data;
  }
}
