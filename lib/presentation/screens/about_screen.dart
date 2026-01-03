import 'package:flutter/material.dart';
import 'package:nightmarket/core/theme/app_theme.dart';
import 'package:nightmarket/core/constants/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Logo and App Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryBrown,
                    AppTheme.lightBrown,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      size: 60,
                      color: AppTheme.primaryBrown,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppConstants.appName,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.appTagline,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Versi 1.0.0',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // About Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Tentang BookCircle',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'BookCircle adalah platform jual beli buku bekas yang menghubungkan pecinta buku di seluruh Indonesia. '
                        'Kami percaya bahwa setiap buku berhak mendapat pembaca baru, dan setiap pembaca berhak menemukan buku impian mereka dengan harga terjangkau.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Dengan fitur barter yang unik, BookCircle juga memungkinkan Anda menukar buku yang sudah dibaca dengan buku baru yang ingin dibaca.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Features
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            'Fitur Unggulan',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        context,
                        Icons.qr_code_scanner,
                        'Scan ISBN',
                        'Scan barcode buku untuk mengisi detail otomatis',
                      ),
                      _buildFeatureItem(
                        context,
                        Icons.swap_horiz,
                        'Sistem Barter',
                        'Tukarkan buku Anda dengan buku lain',
                      ),
                      _buildFeatureItem(
                        context,
                        Icons.verified_user,
                        'Transaksi Aman',
                        'Pembayaran dilindungi sistem escrow',
                      ),
                      _buildFeatureItem(
                        context,
                        Icons.local_shipping,
                        'Pengiriman Terpercaya',
                        'Berbagai pilihan kurir terpercaya',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Developer Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.code, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Pengembang',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(context, 'Dibuat oleh', 'Ismet Maulana Azhari'),
                      _buildInfoRow(context, 'Universitas', 'Universitas Sultan Ageng Tirtayasa'),
                      _buildInfoRow(context, 'Semester', '5'),
                      _buildInfoRow(context, 'Framework', 'Flutter'),
                      _buildInfoRow(context, 'Bahasa Pemrograman', 'Dart'),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Legal Links
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text('Syarat & Ketentuan'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showLegalDialog(context, 'Syarat & Ketentuan');
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip),
                      title: const Text('Kebijakan Privasi'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showLegalDialog(context, 'Kebijakan Privasi');
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.article),
                      title: const Text('Lisensi Open Source'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        showLicensePage(
                          context: context,
                          applicationName: AppConstants.appName,
                          applicationVersion: '1.0.0',
                          applicationIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.menu_book,
                              size: 48,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Social Media
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    'Ikuti Kami',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(context, Icons.facebook, 'Facebook', Colors.blue),
                      const SizedBox(width: 16),
                      _buildSocialButton(context, Icons.camera_alt, 'Instagram', Colors.pink),
                      const SizedBox(width: 16),
                      _buildSocialButton(context, Icons.alternate_email, 'Twitter', Colors.lightBlue),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Copyright
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '© 2026 BookCircle. All rights reserved.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Membuka $label...')),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }

  void _showLegalDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
            'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
            'nisi ut aliquip ex ea commodo consequat.\n\n'
            'Duis aute irure dolor in reprehenderit in voluptate velit esse '
            'cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat '
            'cupidatat non proident, sunt in culpa qui officia deserunt mollit '
            'anim id est laborum.\n\n'
            'Sed ut perspiciatis unde omnis iste natus error sit voluptatem '
            'accusantium doloremque laudantium, totam rem aperiam, eaque ipsa '
            'quae ab illo inventore veritatis et quasi architecto beatae vitae '
            'dicta sunt explicabo.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
