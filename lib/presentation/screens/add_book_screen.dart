import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nightmarket/providers/book_provider.dart';
import 'package:nightmarket/providers/user_provider.dart';
import 'package:nightmarket/core/constants/app_constants.dart';

class AddBookScreen extends StatefulWidget {
  final String? bookId; // If editing an existing book
  final Map<String, dynamic>? prefilledData; // Data from barcode scanner

  const AddBookScreen({super.key, this.bookId, this.prefilledData});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedCategory = AppConstants.categories[1]; // Skip 'All'
  String _selectedCondition = AppConstants.bookConditions.first;
  bool _acceptsBarter = false;
  List<String> _imageUrls = [];
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Prefill data from barcode scanner
    if (widget.prefilledData != null) {
      final data = widget.prefilledData!;
      _titleController.text = data['title'] ?? '';
      _authorController.text = data['author'] ?? '';
      _isbnController.text = data['isbn'] ?? '';
      
      // Add cover image if available
      if (data['coverUrl'] != null && data['coverUrl'].toString().isNotEmpty) {
        _imageUrls.add(data['coverUrl']);
      }
      
      // Set category if available
      if (data['category'] != null) {
        final category = data['category'] as String;
        if (AppConstants.categories.contains(category)) {
          _selectedCategory = category;
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        // In a real app, you'd upload this to a server
        // For now, we'll use a placeholder URL
        _imageUrls.add('https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400');
      });
    }
  }

  Future<void> _saveListing() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_imageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final user = userProvider.currentUser;

    if (user == null) return;

    try {
      if (widget.bookId == null) {
        // Add new book
        await bookProvider.addBook(
          title: _titleController.text,
          author: _authorController.text,
          isbn: _isbnController.text.isEmpty ? null : _isbnController.text,
          category: _selectedCategory,
          condition: _selectedCondition,
          price: double.parse(_priceController.text),
          acceptsBarter: _acceptsBarter,
          description: _descriptionController.text,
          imageUrls: _imageUrls,
          sellerId: user.id,
          sellerName: user.name,
        );
      } else {
        // Update existing book
        await bookProvider.updateBook(
          widget.bookId!,
          title: _titleController.text,
          author: _authorController.text,
          isbn: _isbnController.text.isEmpty ? null : _isbnController.text,
          category: _selectedCategory,
          condition: _selectedCondition,
          price: double.parse(_priceController.text),
          acceptsBarter: _acceptsBarter,
          description: _descriptionController.text,
          imageUrls: _imageUrls,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.bookId == null
                  ? 'Book listed successfully!'
                  : 'Book updated successfully!',
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookId == null ? 'Add New Book' : 'Edit Book'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Images Section
              Text(
                'Book Images',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ..._imageUrls.map((url) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  url,
                                  width: 100,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _imageUrls.remove(url);
                                    });
                                  },
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.black54,
                                    padding: const EdgeInsets.all(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    // Add Image Button
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outline,
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 40,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Add Photo',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Book Details
              Text(
                'Book Details',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Book Title *',
                  hintText: 'Enter the book title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the book title';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Author *',
                  hintText: 'Enter the author name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _isbnController,
                decoration: const InputDecoration(
                  labelText: 'ISBN (Optional)',
                  hintText: 'Enter ISBN number',
                ),
              ),
              
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category *',
                ),
                items: AppConstants.categories
                    .where((cat) => cat != 'All')
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedCondition,
                decoration: const InputDecoration(
                  labelText: 'Condition *',
                ),
                items: AppConstants.bookConditions
                    .map((condition) => DropdownMenuItem(
                          value: condition,
                          child: Text(condition),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCondition = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price *',
                  hintText: '0.00',
                  prefixText: '\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: const Text('Accept Barter'),
                subtitle: const Text('Allow buyers to propose exchange offers'),
                value: _acceptsBarter,
                onChanged: (value) {
                  setState(() {
                    _acceptsBarter = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Describe the book condition, any markings, etc.',
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveListing,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(widget.bookId == null ? 'List Book' : 'Update Book'),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
