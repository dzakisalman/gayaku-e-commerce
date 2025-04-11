import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gayaku/core/theme/app_colors.dart';
import 'package:gayaku/core/theme/app_text_styles.dart';
import 'package:gayaku/presentation/providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  final _authProvider = Get.find<AuthProvider>();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ProfilePage({super.key}) {
    final user = _authProvider.currentUser.value;
    _nameController.text = user?.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: GetBuilder<AuthProvider>(
        builder: (controller) {
          final user = controller.currentUser.value;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: user?.photoURL != null
                            ? NetworkImage(user?.photoURL ?? '')
                            : null,
                        child: user?.photoURL == null
                            ? Text(
                                (user?.displayName ?? 'U')[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Display Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: user?.email ?? 'No email',
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    await controller.updateProfile(
                                      newDisplayName: _nameController.text,
                                    );
                                  }
                                },
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Save Changes'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.logout(),
                          child: const Text('Logout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 