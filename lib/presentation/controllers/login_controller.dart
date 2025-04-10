import 'package:get/get.dart';
import 'package:gayaku/core/routes/app_pages.dart';

class LoginController extends GetxController {
  String email = '';
  String password = '';
  bool isLoading = false;

  void updateEmail(String value) {
    email = value;
    update();
  }

  void updatePassword(String value) {
    password = value;
    update();
  }

  void login() async {
    isLoading = true;
    update();

    // Simulasi proses login
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Implementasi login dengan API
    if (email.isNotEmpty && password.isNotEmpty) {
      isLoading = false;
      update();
      Get.offAllNamed(Routes.HOME);
    } else {
      isLoading = false;
      update();
      Get.snackbar(
        'Error',
        'Invalid email or password',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    email = '';
    password = '';
    super.onClose();
  }
} 