import 'package:flutter/material.dart';

// models
import 'package:flut_mart/utils/models/user.model.dart';

// services
import 'package:flut_mart/services/auth.service.dart';
import 'package:flut_mart/services/cart.service.dart';
import 'package:flut_mart/services/favourite.service.dart';
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
      await CartService().clearCart();
      await FavoritesService().clearFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _isLoading
          ? const SizedBox(
              width: double.infinity,
              height: 500,
              child: Center(child: CircularProgressIndicator()),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 30,
                            spreadRadius: 1,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 90,
                        backgroundImage: NetworkImage(_user!.avatar),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildProfileInfo('Name', _user!.name),
                  _buildProfileInfo('Email', _user!.email),
                  _buildProfileInfo('Username', "testUser"),
                  _buildProfileInfo('Phone', '+91 78458 94578'),
                  const SizedBox(height: 20),
                  Text(
                    "Addresses",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  _buildProfileInfo('Home',
                      '508, Le-Bestow Co-Living Aira\nNear Shilparamam, Hitech City\nHyderabad, India'),
                  _buildProfileInfo('Office',
                      'Cyber Towers, 1st Floor, Hitech\nCity, Hyderabad, India'),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
