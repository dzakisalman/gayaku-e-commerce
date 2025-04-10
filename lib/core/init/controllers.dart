import 'package:get/get.dart';
import 'package:gayaku/presentation/controllers/login_controller.dart';

class Controllers {
  static void init() {
    Get.put(LoginController());
  }
} 