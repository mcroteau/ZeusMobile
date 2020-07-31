import 'package:get/get.dart';

class ZeusData extends GetxController{

  var q;
  var id;
  var session;

  ZeusData();
  ZeusData.withData(this.q, this.id, this.session);

  void setQ(q) {
    this.q = q;
    update();
  }

  void setId(id) {
    this.id = id;
    update();
  }

  void setSession(session) {
    this.session = session;
    update();
  }
}