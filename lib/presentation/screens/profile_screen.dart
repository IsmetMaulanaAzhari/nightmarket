import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nightmarket/providers/user_provider.dart';
import 'package:nightmarket/providers/book_provider.dart';
import 'package:nightmarket/providers/wishlist_provider.dart';
import 'package:nightmarket/providers/order_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final bookProvider = Provider.of<BookProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    
    final user = userProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, size: 20, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${user.rating.toStringAsFixed(1)} Rating',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${user.totalSales} Sales',
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Quick Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Listings',
                      '${bookProvider.myListings.length}',
                      Icons.sell,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Orders',
                      '${orderProvider.getUserOrders(user.id).length}',
                      Icons.shopping_bag,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Wishlist',
                      '${wishlistProvider.itemCount}',
                      Icons.favorite,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Menu Items
            _buildMenuItem(
              context,
              Icons.shopping_bag_outlined,
              'My Orders',
              'View purchase history',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Orders screen coming soon')),
                );
              },
            ),
            _buildMenuItem(
              context,
              Icons.sell_outlined,
              'My Listings',
              'Manage your books for sale',
              () {
                context.push('/my-listings');
              },
            ),
            _buildMenuItem(
              context,
              Icons.favorite_border,
              'Wishlist',
              'Books you want to buy',
              () {
                context.push('/wishlist');
              },
            ),
            _buildMenuItem(
              context,
              Icons.person_outline,
              'Edit Profile',
              'Update your information',
              () {
                // Navigate to edit profile
              },
            ),
            _buildMenuItem(
              context,
              Icons.location_on_outlined,
              'Addresses',
              'Manage shipping addresses',
              () {
                // Navigate to addresses
              },
            ),
            _buildMenuItem(
              context,
              Icons.help_outline,
              'Help & Support',
              'Get help with your account',
              () {
                // Navigate to help
              },
            ),
            _buildMenuItem(
              context,
              Icons.info_outline,
              'About',
              'Learn more about BookCircle',
              () {
                // Navigate to about
              },
            ),
            
            const SizedBox(height: 16),
            
            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              userProvider.logout();
                              Navigator.pop(context);
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
