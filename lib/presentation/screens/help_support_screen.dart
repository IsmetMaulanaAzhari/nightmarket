import 'package:flutter/material.dart';
import 'package:nightmarket/core/theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan & Dukungan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryBrown, AppTheme.lightBrown],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.support_agent,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ada yang bisa kami bantu?',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pilih topik atau hubungi kami langsung',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // FAQ Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Pertanyaan Umum (FAQ)',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              context,
              'Bagaimana cara membeli buku?',
              'Pilih buku yang Anda inginkan, tambahkan ke keranjang, lalu lanjutkan ke checkout. Pilih metode pembayaran dan alamat pengiriman, kemudian konfirmasi pesanan Anda.',
            ),
            _buildFAQItem(
              context,
              'Bagaimana cara menjual buku?',
              'Klik tombol "+" di halaman utama atau pilih "Jual Buku" di profil Anda. Isi informasi buku, upload foto, tentukan harga, dan publikasikan listing Anda.',
            ),
            _buildFAQItem(
              context,
              'Berapa lama pengiriman?',
              'Waktu pengiriman tergantung pada metode yang dipilih:\n• JNE Regular: 3-5 hari kerja\n• SiCepat Express: 1-2 hari kerja\n• GoSend: Hari yang sama (area tertentu)',
            ),
            _buildFAQItem(
              context,
              'Bagaimana sistem barter bekerja?',
              'Jika penjual membuka opsi barter, Anda dapat mengajukan buku Anda sebagai tukar. Penjual akan meninjau dan menyetujui atau menolak tawaran barter Anda.',
            ),
            _buildFAQItem(
              context,
              'Bagaimana cara mengembalikan buku?',
              'Jika buku yang diterima tidak sesuai deskripsi, Anda dapat mengajukan pengembalian dalam 3 hari setelah penerimaan. Hubungi customer service untuk proses lebih lanjut.',
            ),
            _buildFAQItem(
              context,
              'Apakah pembayaran aman?',
              'Ya, semua transaksi dilindungi oleh sistem escrow. Pembayaran Anda ditahan hingga Anda konfirmasi penerimaan barang.',
            ),

            const SizedBox(height: 24),

            // Contact Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Hubungi Kami',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildContactItem(
              context,
              Icons.email,
              'Email',
              'support@bookcircle.com',
              'Balasan dalam 24 jam',
              Colors.red,
            ),
            _buildContactItem(
              context,
              Icons.chat,
              'WhatsApp',
              '+62 812-3456-7890',
              'Online 09:00 - 21:00 WIB',
              Colors.green,
            ),
            _buildContactItem(
              context,
              Icons.phone,
              'Telepon',
              '021-1234-5678',
              'Senin - Jumat, 09:00 - 17:00',
              Colors.blue,
            ),

            const SizedBox(height: 24),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Aksi Cepat',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      Icons.report_problem,
                      'Laporkan Masalah',
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      Icons.feedback,
                      'Kirim Feedback',
                      Colors.purple,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        Text(
          answer,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        value,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Membuka $title...')),
        );
      },
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Card(
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label - Fitur segera hadir')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
