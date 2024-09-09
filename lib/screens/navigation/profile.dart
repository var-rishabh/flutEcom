import 'package:flutter/material.dart';

// models
import 'package:flut_mart/utils/models/user.model.dart';

// services
import 'package:flut_mart/services/auth.service.dart';
import 'package:flut_mart/services/token.service.dart';

// widgets
import 'package:flut_mart/widgets/snackbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthApiService _authApiService = AuthApiService();
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final token = await TokenService.getToken();
      final decodedToken = TokenService.decodeToken(token!);
      final userId = decodedToken!['sub'];

      final response = await _authApiService.getUserProfile(userId);

      setState(() {
        _user = User.fromJson(response);
        _isLoading = false;
      });
    } catch (error) {
      // Handle error appropriately
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _logout() async {
    await TokenService.deleteToken();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
      KSnackBar.show(
        context: context,
        label: 'Logout Successful',
        type: 'success',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(_user!.avatar),
            ),
            const SizedBox(height: 20),

            // User Information
            _buildProfileInfo('Name', _user!.name),
            _buildProfileInfo('Email', _user!.email),
            _buildProfileInfo('Username', "N/A"),
            _buildProfileInfo('Phone', 'N/A'),
            _buildProfileInfo('Address', 'N/A'),

            const SizedBox(height: 40),

            // Logout Button
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display each profile information
  Widget _buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
