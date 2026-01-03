import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nightmarket/providers/theme_provider.dart';
import 'package:nightmarket/providers/user_provider.dart';
import 'package:nightmarket/core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _buildSectionHeader(context, 'Tampilan'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(themeProvider.themeModeIcon),
                  title: const Text('Mode Tema'),
                  subtitle: Text(themeProvider.themeModeLabel),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemeDialog(context, themeProvider),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Notification Section
          _buildSectionHeader(context, 'Notifikasi'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications),
                  title: const Text('Notifikasi Push'),
                  subtitle: const Text('Terima notifikasi pesanan & promo'),
                  value: true,
                  onChanged: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pengaturan notifikasi diperbarui')),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.email),
                  title: const Text('Notifikasi Email'),
                  subtitle: const Text('Terima update via email'),
                  value: true,
                  onChanged: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pengaturan email diperbarui')),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Privacy Section
          _buildSectionHeader(context, 'Privasi & Keamanan'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                if (userProvider.isLoggedIn) ...[
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Ubah Password'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showChangePasswordDialog(context);
                    },
                  ),
                  const Divider(height: 1),
                ],
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint),
                  title: const Text('Biometrik'),
                  subtitle: const Text('Login dengan sidik jari'),
                  value: false,
                  onChanged: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur biometrik segera hadir')),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Data & Storage Section
          _buildSectionHeader(context, 'Data & Penyimpanan'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_sweep),
                  title: const Text('Hapus Cache'),
                  subtitle: const Text('Bersihkan data sementara'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hapus Cache'),
                        content: const Text('Apakah Anda yakin ingin menghapus cache?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cache berhasil dihapus'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Download Data'),
                  subtitle: const Text('Unduh salinan data Anda'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur download data segera hadir')),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Language Section
          _buildSectionHeader(context, 'Bahasa & Region'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Bahasa'),
                  subtitle: const Text('Bahasa Indonesia'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showLanguageDialog(context);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: const Text('Mata Uang'),
                  subtitle: const Text('IDR (Rupiah)'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pengaturan mata uang segera hadir')),
                    );
                  },
                ),
              ],
            ),
          ),

          if (userProvider.isLoggedIn) ...[
            const SizedBox(height: 24),
            
            // Danger Zone
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: Colors.red.withOpacity(0.1),
                child: ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    'Hapus Akun',
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text('Hapus akun dan semua data Anda'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hapus Akun'),
                        content: const Text(
                          'Apakah Anda yakin ingin menghapus akun? '
                          'Tindakan ini tidak dapat dibatalkan dan semua data Anda akan dihapus secara permanen.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fitur hapus akun segera hadir'),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('Hapus Akun'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Mode Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Sistem'),
              subtitle: const Text('Ikuti pengaturan perangkat'),
              secondary: const Icon(Icons.brightness_auto),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                themeProvider.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Terang'),
              secondary: const Icon(Icons.light_mode),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                themeProvider.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Gelap'),
              secondary: const Icon(Icons.dark_mode),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                themeProvider.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                decoration: const InputDecoration(
                  labelText: 'Password Saat Ini',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newController,
                decoration: const InputDecoration(
                  labelText: 'Password Baru',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmController,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password tidak cocok'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password berhasil diubah'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Bahasa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Bahasa Indonesia'),
              value: 'id',
              groupValue: 'id',
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bahasa diatur ke Bahasa Indonesia')),
                );
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: 'id',
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur multi-bahasa segera hadir')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
