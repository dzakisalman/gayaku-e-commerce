import 'package:flutter/material.dart';
import 'package:gayaku/core/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gayaku/presentation/providers/wishlist_provider.dart';
import 'package:gayaku/presentation/providers/cart_provider.dart';

class AuthProvider extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final isLoading = false.obs;
  final currentUser = Rxn<User>();
  final displayName = ''.obs;
  final photoURL = ''.obs;
  final email = ''.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
      if (user != null) {
        displayName.value = user.displayName ?? '';
        photoURL.value = user.photoURL ?? '';
        email.value = user.email ?? '';
      }
    });
  }

  void updateEmail(String value) => email.value = value;

  bool validateForm() {
    if (email.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Email tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  Future<void> registerUser(String email, String password, String displayName) async {
    try {
      isLoading.value = true;
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name after registration
      await userCredential.user?.updateDisplayName(displayName);
      this.displayName.value = displayName;
      
      // Reinitialize providers after successful registration
      Get.put(CartProvider());
      Get.put(WishlistProvider());
      
      Get.offAllNamed('/home');
      Get.snackbar(
        'Berhasil',
        'Akun berhasil dibuat',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email sudah terdaftar. Silakan gunakan email lain.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        case 'weak-password':
          message = 'Password terlalu lemah. Minimal 6 karakter.';
          break;
        default:
          message = 'Terjadi kesalahan. Silakan coba lagi.';
      }
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Reinitialize providers after successful login
      Get.put(CartProvider());
      Get.put(WishlistProvider());
      
      Get.offAllNamed(Routes.HOME);
      Get.snackbar(
        'Berhasil',
        'Login berhasil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
          break;
        case 'wrong-password':
          message = 'Password salah. Silakan coba lagi.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        default:
          message = 'Terjadi kesalahan. Silakan coba lagi.';
      }
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _auth.signOut();
      currentUser.value = null;
      displayName.value = '';
      photoURL.value = '';
      email.value = '';
      
      // Clean up providers
      Get.delete<WishlistProvider>();
      Get.delete<CartProvider>();
      
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({required String newDisplayName}) async {
    try {
      isLoading.value = true;
      await _auth.currentUser?.updateDisplayName(newDisplayName);
      // Refresh current user data
      final user = _auth.currentUser;
      currentUser.value = user;
      update();
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
} 