import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../custom_widgets//custom_textfield.dart';

class RegisterPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _register(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (usernameController.text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username must be at least 3 characters')),
      );
      return;
    }

    final res = await auth.register(
      usernameController.text,
      emailController.text,
      passwordController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message'] ?? 'Registration completed!')),
    );

    if (res['success'] == true) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(controller: usernameController, label: 'Username', minLength: 3),
            CustomTextField(controller: emailController, label: 'Email', keyboardType: TextInputType.emailAddress),
            CustomTextField(controller: passwordController, label: 'Password', obscureText: true),
            SizedBox(height: 20),
            auth.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: () => _register(context), child: Text('Register')),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
