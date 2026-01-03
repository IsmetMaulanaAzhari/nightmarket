import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nightmarket/providers/user_provider.dart';
import 'package:nightmarket/core/theme/app_theme.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final List<Map<String, dynamic>> _addresses = [
    {
      'id': '1',
      'label': 'Rumah',
      'name': 'John Doe',
      'phone': '081234567890',
      'address': 'Jl. Sudirman No. 123',
      'city': 'Jakarta Pusat',
      'postalCode': '10110',
      'isDefault': true,
    },
    {
      'id': '2',
      'label': 'Kantor',
      'name': 'John Doe',
      'phone': '081234567891',
      'address': 'Jl. Thamrin No. 456, Gedung A Lt. 5',
      'city': 'Jakarta Pusat',
      'postalCode': '10350',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = context.watch<UserProvider>();

    if (!userProvider.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Alamat Pengiriman')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Login untuk mengelola alamat'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.push('/login'),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alamat Pengiriman'),
      ),
      body: _addresses.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return _buildAddressCard(context, address, index);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Alamat'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.cream,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_outlined,
              size: 60,
              color: AppTheme.primaryBrown,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum ada alamat',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Tambahkan alamat pengiriman Anda',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, Map<String, dynamic> address, int index) {
    final theme = Theme.of(context);
    final isDefault = address['isDefault'] as bool;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDefault
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    address['label'],
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isDefault) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.softGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Utama',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.softGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    if (!isDefault)
                      const PopupMenuItem(
                        value: 'default',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, size: 20),
                            SizedBox(width: 8),
                            Text('Jadikan Utama'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Hapus', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showAddEditDialog(context, address: address, index: index);
                        break;
                      case 'default':
                        _setAsDefault(index);
                        break;
                      case 'delete':
                        _deleteAddress(index);
                        break;
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              address['name'],
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              address['phone'],
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              address['address'],
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              '${address['city']}, ${address['postalCode']}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, {Map<String, dynamic>? address, int? index}) {
    final isEdit = address != null;
    final labelController = TextEditingController(text: address?['label'] ?? '');
    final nameController = TextEditingController(text: address?['name'] ?? '');
    final phoneController = TextEditingController(text: address?['phone'] ?? '');
    final addressController = TextEditingController(text: address?['address'] ?? '');
    final cityController = TextEditingController(text: address?['city'] ?? '');
    final postalCodeController = TextEditingController(text: address?['postalCode'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEdit ? 'Edit Alamat' : 'Tambah Alamat',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: labelController,
                decoration: const InputDecoration(
                  labelText: 'Label (contoh: Rumah, Kantor)',
                  prefixIcon: Icon(Icons.label),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Penerima',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat Lengkap',
                  prefixIcon: Icon(Icons.location_on),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'Kota',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: postalCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Kode Pos',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (labelController.text.isEmpty ||
                        nameController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        addressController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mohon lengkapi semua field')),
                      );
                      return;
                    }

                    final newAddress = {
                      'id': isEdit ? address['id'] : DateTime.now().millisecondsSinceEpoch.toString(),
                      'label': labelController.text,
                      'name': nameController.text,
                      'phone': phoneController.text,
                      'address': addressController.text,
                      'city': cityController.text,
                      'postalCode': postalCodeController.text,
                      'isDefault': isEdit ? address['isDefault'] : _addresses.isEmpty,
                    };

                    setState(() {
                      if (isEdit && index != null) {
                        _addresses[index] = newAddress;
                      } else {
                        _addresses.add(newAddress);
                      }
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEdit ? 'Alamat diperbarui' : 'Alamat ditambahkan'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Alamat'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _setAsDefault(int index) {
    setState(() {
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i]['isDefault'] = i == index;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alamat utama diperbarui'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteAddress(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Alamat'),
        content: const Text('Apakah Anda yakin ingin menghapus alamat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _addresses.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Alamat dihapus'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
