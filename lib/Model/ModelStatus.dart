import 'package:delivery_boy/BLoC/CommonBlocClass/BaseMode.dart';

class ResOrderStatus extends BaseModel {
  int code;
  String message;
  Status result;

  ResOrderStatus({this.code, this.message, this.result});

  ResOrderStatus.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    result =
        json['result'] != null ? new Status.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Status {
  String ticketstatus;

  Status({
    this.ticketstatus,
  });

  Status.fromJson(Map<String, dynamic> json) {
    ticketstatus = json['order_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_status'] = this.ticketstatus;

    return data;
  }
}
