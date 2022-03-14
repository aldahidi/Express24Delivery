import 'package:delivery_boy/BLoC/CommonBlocClass/BaseBloc.dart';
import 'package:delivery_boy/Model/ModelStatus.dart';

class OrderStatus extends BaseBloc<ResOrderStatus> {
  Stream<ResOrderStatus> get profileData => fetcher.stream;
  getOrderStatus(String orderId) async {
    ResOrderStatus addNewAddress = await repository.getOrderStatus(orderId);
    fetcher.sink.add(addNewAddress);
  }
}

final orderStatus = OrderStatus();
