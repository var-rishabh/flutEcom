import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:flut_mart/provider/routes.dart';
import 'package:flut_mart/models/user.dart';
import 'package:flut_mart/utils/helper/responsive.dart';
import 'package:flut_mart/utils/constants/routes.dart';
import 'package:flut_mart/services/auth.service.dart';

import 'package:flut_mart/widgets/input.dart';
import 'package:flut_mart/widgets/notification.dart';
import 'package:flut_mart/widgets/submit_button.dart';

class SignUpScreen extends StatefulWidget {
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
  bool _isLoading = false;

  void _signupUser() async {
    try {
      if (_isLoading) return;
      setState(() {
        _isLoading = true;
      });
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
        KNotification.show(
          context: context,
          label: 'Please fill all the fields',
          type: 'error',
        );
        setState(() {
          _isLoading = false;
        });
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
        setState(() {
          _isLoading = false;
        });
        KNotification.show(
          context: context,
          label: 'SignUp Successful. Please login.',
          type: 'success',
        );
        context.go(KRoutes.login);
        Provider.of<RoutesProvider>(context, listen: false)
            .setCurrentRoute(KRoutes.login);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        KNotification.show(
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Responsive.isMobile(context)
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Lottie.asset(
                        'assets/animations/signup.json',
                        height: 250,
                      ),
                    ),
                    _signUpScreen(
                      context,
                      _firstNameController,
                      _lastNameController,
                      _emailController,
                      _passwordController,
                      _streetController,
                      _cityController,
                      _zipCodeController,
                      _signupUser,
                      _isLoading,
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Lottie.asset(
                      'assets/animations/signup.json',
                      height: 500,
                    ),
                  ),
                  const SizedBox(width: 50),
                  SizedBox(
                    width: 400,
                    child: _signUpScreen(
                      context,
                      _firstNameController,
                      _lastNameController,
                      _emailController,
                      _passwordController,
                      _streetController,
                      _cityController,
                      _zipCodeController,
                      _signupUser,
                      _isLoading,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Widget _signUpScreen(
  BuildContext context,
  firstNameController,
  lastNameController,
  emailController,
  passwordController,
  streetController,
  cityController,
  zipCodeController,
  signupUser,
  isLoading,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
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
              controller: firstNameController,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: KInputField(
              labelText: 'Last Name',
              controller: lastNameController,
            ),
          ),
        ],
      ),
      KInputField(
        labelText: 'Email',
        icon: Icons.email,
        controller: emailController,
      ),
      KInputField(
        labelText: 'Password',
        icon: Icons.lock,
        controller: passwordController,
        obscureText: true,
      ),
      KInputField(
        labelText: 'Street',
        icon: Icons.add_road,
        controller: streetController,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: KInputField(
              labelText: 'City',
              controller: cityController,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: KInputField(
              labelText: 'Zip Code',
              controller: zipCodeController,
              maxLength: 6,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: SubmitButton(
              onSubmit: signupUser,
              text: 'Submit',
              isLoading: isLoading,
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
              'Already have an account? ',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            GestureDetector(
              onTap: () {
                context.go(KRoutes.login);
                Provider.of<RoutesProvider>(context, listen: false)
                    .setCurrentRoute(KRoutes.login);
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
  );
}
