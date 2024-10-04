import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:flut_mart/models/user.dart';
import 'package:flut_mart/provider/location.dart';
import 'package:flut_mart/provider/product.dart';
import 'package:flut_mart/utils/constants/routes.dart';
import 'package:flut_mart/services/auth.service.dart';
import 'package:flut_mart/services/cart.service.dart';
import 'package:flut_mart/services/favourite.service.dart';
import 'package:flut_mart/services/token.service.dart';

import 'package:flut_mart/widgets/notification.dart';
import 'package:flut_mart/widgets/submit_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthApiService _authApiService = AuthApiService();
  User? _user;
  bool _isLoading = true;
  bool _isLoggingOut = false;

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
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _logout() async {
    setState(() {
      _isLoggingOut = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    await TokenService.deleteToken();
    if (mounted) {
      context.go(KRoutes.login);
      KNotification.show(
        context: context,
        label: 'Logout Successful',
        type: 'success',
      );
      await CartService().clearCart();
      await FavoritesService().clearFavorites();
      await Provider.of<ProductProvider>(context, listen: false)
          .clearRecentProducts();
      await Provider.of<ProductProvider>(context, listen: false)
          .clearSearchHistory();
    }
    setState(() {
      _isLoggingOut = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final LocationProvider locationProvider =
        Provider.of<LocationProvider>(context);

    final String fullAddress = locationProvider.address.values
        .where((element) => element.isNotEmpty)
        .join(', ');

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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 30,
                            spreadRadius: 1,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          _user!.avatar,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Container(
                              width: 200,
                              height: 200,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildProfileInfo('Name', _user!.name),
                  _buildProfileInfo('Email', _user!.email),
                  _buildProfileInfo('Username', "testUser"),
                  _buildProfileInfo('Phone', '+91 78458 94578'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Address",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (fullAddress.isEmpty)
                        InkWell(
                          onTap: () {
                            locationProvider.getCurrentLocation();
                          },
                          child: locationProvider.isLoading
                              ? const SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(),
                                )
                              : Row(
                                  children: [
                                    if (fullAddress.isEmpty)
                                      Text(
                                        ' (Tap to fetch location)',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                      ),
                                  ],
                                ),
                        ),
                    ],
                  ),
                  if (fullAddress.isNotEmpty)
                    Column(
                      children: [
                        _buildProfileInfo("Street",
                            '${locationProvider.address['street']!}, ${locationProvider.address['subLocality']!}'),
                        _buildProfileInfo("City",
                            '${locationProvider.address['locality']!}, ${locationProvider.address['postalCode']!}'),
                        _buildProfileInfo("State",
                            locationProvider.address['administrativeArea']!),
                      ],
                    ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: SubmitButton(
                          onSubmit: _logout,
                          text: 'Logout',
                          isLoading: _isLoggingOut,
                        ),
                      ),
                    ],
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
          const SizedBox(width: 30),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
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
