import 'package:flutter/material.dart';
import 'package:gayaku/core/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gayaku/presentation/providers/wishlist_provider.dart';
import 'package:gayaku/presentation/providers/cart_provider.dart';
import '../../data/services/auth_service.dart';

class AuthProvider extends GetxController {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> _user = Rx<User?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final currentUser = Rxn<User>();
  final displayName = ''.obs;
  final photoURL = ''.obs;
  final email = ''.obs;

  User? get user => _user.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  set errorMessage(String value) => _errorMessage.value = value;

  @override
  void onInit() {
    super.onInit();
    _user.value = _auth.currentUser;
    currentUser.value = _auth.currentUser;
    
    if (_auth.currentUser != null) {
      displayName.value = _auth.currentUser?.displayName ?? '';
      photoURL.value = _auth.currentUser?.photoURL ?? '';
      email.value = _auth.currentUser?.email ?? '';
    }
    
    _auth.authStateChanges().listen((User? user) {
      _user.value = user;
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

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _errorMessage.value = _getErrorMessage(e.code);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      print('Starting Google Sign In process...');
      
      final userCredential = await _authService.signInWithGoogle();
      print('Google Sign In result: ${userCredential != null ? 'Success' : 'Failed'}');
      
      if (userCredential == null) {
        _errorMessage.value = 'Google sign in failed';
        print('Google Sign In failed: No user credential returned');
        return;
      }

      // Update user data
      currentUser.value = userCredential.user;
      displayName.value = userCredential.user?.displayName ?? '';
      photoURL.value = userCredential.user?.photoURL ?? '';
      email.value = userCredential.user?.email ?? '';
      print('User data updated: ${userCredential.user?.email}');

      // Reinitialize providers after successful login
      Get.put(CartProvider());
      Get.put(WishlistProvider());

      // Navigate to home page
      Get.offAllNamed(Routes.HOME);
      Get.snackbar(
        'Berhasil',
        'Login berhasil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e, stackTrace) {
      print('Error during Google Sign In: $e');
      print('Stack trace: $stackTrace');
      _errorMessage.value = 'An error occurred during Google sign in';
      Get.snackbar(
        'Error',
        'Gagal login dengan Google. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      _errorMessage.value = _getErrorMessage(e.code);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      await _authService.signOut();
    } catch (e) {
      _errorMessage.value = 'An error occurred during sign out';
    } finally {
      _isLoading.value = false;
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Email is invalid';
      default:
        return 'An error occurred';
    }
  }

  Future<void> registerUser(String email, String password, String displayName) async {
    try {
      _isLoading.value = true;
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
      _isLoading.value = false;
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      _isLoading.value = true;
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update user data after successful login
      currentUser.value = userCredential.user;
      displayName.value = userCredential.user?.displayName ?? '';
      photoURL.value = userCredential.user?.photoURL ?? '';
      this.email.value = userCredential.user?.email ?? '';
      
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
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      _isLoading.value = true;
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
      _errorMessage.value = e.toString();
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateProfile({required String newDisplayName}) async {
    try {
      _isLoading.value = true;
      await _auth.currentUser?.updateDisplayName(newDisplayName);
      // Refresh current user data
      final user = _auth.currentUser;
      currentUser.value = user;
      update();
    } catch (e) {
      _errorMessage.value = e.toString();
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }
} 