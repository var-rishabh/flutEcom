import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

// services
import 'package:flut_mart/services/auth.service.dart';
import 'package:flut_mart/services/token.service.dart';

// widgets
import 'package:flut_mart/widgets/input.dart';
import 'package:flut_mart/widgets/snackbar.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthApiService _authApiService = AuthApiService();

  // method to login user
  void _loginUser() async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        KSnackBar.show(
          context: context,
          label: 'Please fill all fields',
          type: 'error',
        );
        return;
      }

      final response = await _authApiService.loginUser(email, password);
      final token = response['access_token'];
      await TokenService.saveToken(token);

      if (mounted) {
        KSnackBar.show(
          context: context,
          label: 'Login Successful',
          type: 'success',
        );
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/app',
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        KSnackBar.show(
          context: context,
          label: 'Invalid Credentials',
          type: 'error',
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/animations/auth.json',
                  height: 350,
                ),
              ),
              Text(
                'Login',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your credentials to login.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              const SizedBox(height: 30),
              KInputField(
                labelText: 'Email',
                icon: Icons.email,
                controller: _emailController,
              ),
              const SizedBox(height: 8),
              KInputField(
                labelText: 'Password',
                icon: Icons.lock,
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: Text(
                        'SignUp',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
