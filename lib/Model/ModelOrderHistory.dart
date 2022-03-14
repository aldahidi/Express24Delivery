import 'package:delivery_boy/BLoC/CommonBlocClass/BaseMode.dart';

class ResOrderHistory extends BaseModel {
  int code;
  String message;
  List<HistoryOrder> historyOrderList;

  ResOrderHistory({this.code, this.message, this.historyOrderList});

  ResOrderHistory.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      // ignore: deprecated_member_use
      historyOrderList = new List<HistoryOrder>();
      json['result'].forEach((v) {
        historyOrderList.add(new HistoryOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.historyOrderList != null) {
      data['result'] = this.historyOrderList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HistoryOrder {
  String name;
  String bannerImage;
  String address;
  String pincode;
  String orderId;
  String userId;
  String orderStatus;
  String totalPrice;
  String created;
  String updated;
  String driverStatus;
  String trackingNumber;

  HistoryOrder(
      {this.name,
      this.bannerImage,
      this.address,
      this.pincode,
      this.orderId,
      this.userId,
      this.orderStatus,
      this.totalPrice,
      this.created,
      this.updated,
      this.driverStatus,
      this.trackingNumber});

  HistoryOrder.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    bannerImage = json['banner_image'];
    address = json['address'];
    pincode = json['pincode'];
    orderId = json['order_id'];
    userId = json['user_id'];
    orderStatus = json['order_status'];
    totalPrice = json['total_price'];
    created = json['created'];
    updated = json['updated'];
    driverStatus = json['driver_status'];
    trackingNumber = json['trackingnumber'] == null ? "11" : json['trackingnumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['banner_image'] = this.bannerImage;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['order_status'] = this.orderStatus;
    data['total_price'] = this.totalPrice;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['driver_status'] = this.driverStatus;
    data['trackingnumber'] = this.trackingNumber == null ? "11" : this.trackingNumber;
    return data;
  }
}
