import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

// models
import 'package:flut_mart/utils/models/user.model.dart';

// services
import 'package:flut_mart/services/auth.service.dart';

// widgets
import 'package:flut_mart/widgets/input.dart';
import 'package:flut_mart/widgets/snackbar.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  final AuthApiService _authApiService = AuthApiService();

  // method to signup user
  void _signupUser() async {
    try {
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final street = _streetController.text;
      final city = _cityController.text;
      final zipCode = _zipCodeController.text;

      if (email.isEmpty ||
          password.isEmpty ||
          firstName.isEmpty ||
          lastName.isEmpty ||
          city.isEmpty ||
          street.isEmpty ||
          zipCode.isEmpty) {
        KSnackBar.show(
          context: context,
          label: 'Please fill all the fields',
          type: 'error',
        );
        return;
      }

      User userData = User(
        email: email,
        name: '$firstName $lastName',
        password: password,
        avatar:
            "https://www.shareicon.net/data/128x128/2016/07/05/791220_people_512x512.png",
      );

      final response = await _authApiService.signupUser(userData);
      final id = response['id'];

      if (mounted && id != null) {
        KSnackBar.show(
          context: context,
          label: 'SignUp Successful. Please login.',
          type: 'success',
        );
        Navigator.of(context).pushReplacementNamed('/login');
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/animations/signup.json',
                  height: 250,
                ),
              ),
              Text(
                'Signup',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your credentials to signup.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: KInputField(
                      labelText: 'First Name',
                      controller: _firstNameController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: KInputField(
                      labelText: 'Last Name',
                      controller: _lastNameController,
                    ),
                  ),
                ],
              ),
              KInputField(
                labelText: 'Email',
                icon: Icons.email,
                controller: _emailController,
              ),
              KInputField(
                labelText: 'Password',
                icon: Icons.lock,
                controller: _passwordController,
                obscureText: true,
              ),
              KInputField(
                labelText: 'Street',
                icon: Icons.add_road,
                controller: _streetController,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: KInputField(
                      labelText: 'City',
                      controller: _cityController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: KInputField(
                      labelText: 'Zip Code',
                      controller: _zipCodeController,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _signupUser,
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
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: Text(
                        'Login',
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
