import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';
  
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Signup'),
      ),
    );
  }
}