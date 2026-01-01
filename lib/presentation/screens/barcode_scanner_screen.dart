import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:nightmarket/core/theme/app_theme.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  MobileScannerController? _controller;
  bool _isScanning = true;
  bool _isLoading = false;
  Map<String, dynamic>? _bookInfo;
  String? _scannedCode;
  String? _errorMessage;
  bool _torchEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (!_isScanning || _isLoading) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final code = barcode.rawValue;

    if (code == null || code.isEmpty) return;

    // Check if it looks like an ISBN (10 or 13 digits)
    final cleanCode = code.replaceAll(RegExp(r'[^0-9X]'), '');
    if (cleanCode.length != 10 && cleanCode.length != 13) {
      setState(() {
        _errorMessage = 'Bukan ISBN yang valid. Coba scan barcode buku lainnya.';
        _scannedCode = code;
      });
      return;
    }

    setState(() {
      _isScanning = false;
      _isLoading = true;
      _scannedCode = cleanCode;
      _errorMessage = null;
    });

    await _fetchBookInfo(cleanCode);
  }

  Future<void> _fetchBookInfo(String isbn) async {
    try {
      // Try Open Library API first
      final response = await http.get(
        Uri.parse('https://openlibrary.org/api/books?bibkeys=ISBN:$isbn&format=json&jscmd=data'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data.isNotEmpty && data['ISBN:$isbn'] != null) {
          final bookData = data['ISBN:$isbn'];
          
          setState(() {
            _bookInfo = {
              'title': bookData['title'] ?? 'Tidak diketahui',
              'authors': (bookData['authors'] as List?)
                  ?.map((a) => a['name'])
                  .join(', ') ?? 'Tidak diketahui',
              'publishers': (bookData['publishers'] as List?)
                  ?.map((p) => p['name'])
                  .join(', ') ?? 'Tidak diketahui',
              'publishDate': bookData['publish_date'] ?? 'Tidak diketahui',
              'numberOfPages': bookData['number_of_pages']?.toString() ?? 'Tidak diketahui',
              'cover': bookData['cover']?['large'] ?? bookData['cover']?['medium'],
              'subjects': (bookData['subjects'] as List?)
                  ?.take(5)
                  .map((s) => s['name'])
                  .join(', ') ?? 'Tidak diketahui',
              'isbn': isbn,
            };
            _isLoading = false;
          });
          return;
        }
      }

      // Try Google Books API as fallback
      final googleResponse = await http.get(
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn'),
      ).timeout(const Duration(seconds: 10));

      if (googleResponse.statusCode == 200) {
        final googleData = json.decode(googleResponse.body);
        
        if (googleData['totalItems'] > 0) {
          final volumeInfo = googleData['items'][0]['volumeInfo'];
          
          setState(() {
            _bookInfo = {
              'title': volumeInfo['title'] ?? 'Tidak diketahui',
              'authors': (volumeInfo['authors'] as List?)?.join(', ') ?? 'Tidak diketahui',
              'publishers': volumeInfo['publisher'] ?? 'Tidak diketahui',
              'publishDate': volumeInfo['publishedDate'] ?? 'Tidak diketahui',
              'numberOfPages': volumeInfo['pageCount']?.toString() ?? 'Tidak diketahui',
              'cover': volumeInfo['imageLinks']?['thumbnail']?.replaceAll('http:', 'https:'),
              'subjects': (volumeInfo['categories'] as List?)?.join(', ') ?? 'Tidak diketahui',
              'description': volumeInfo['description'],
              'isbn': isbn,
            };
            _isLoading = false;
          });
          return;
        }
      }

      // No book found
      setState(() {
        _errorMessage = 'Buku dengan ISBN $isbn tidak ditemukan di database.';
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mengambil data: $e';
        _isLoading = false;
      });
    }
  }

  void _resetScanner() {
    setState(() {
      _isScanning = true;
      _bookInfo = null;
      _scannedCode = null;
      _errorMessage = null;
    });
  }

  void _toggleTorch() {
    _controller?.toggleTorch();
    setState(() {
      _torchEnabled = !_torchEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan ISBN Buku'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_isScanning)
            IconButton(
              icon: Icon(
                _torchEnabled ? Icons.flash_on : Icons.flash_off,
                color: _torchEnabled ? Colors.yellow : Colors.white,
              ),
              onPressed: _toggleTorch,
            ),
        ],
      ),
      body: _isScanning ? _buildScannerView() : _buildResultView(),
    );
  }

  Widget _buildScannerView() {
    return Stack(
      children: [
        // Camera View
        MobileScanner(
          controller: _controller,
          onDetect: _onDetect,
        ),
        
        // Overlay
        Container(
          decoration: ShapeDecoration(
            shape: _ScannerOverlayShape(
              borderColor: AppTheme.primaryBrown,
              borderWidth: 3.0,
              overlayColor: Colors.black.withValues(alpha: 0.5),
              borderRadius: 12,
              cutOutSize: 280,
            ),
          ),
        ),
        
        // Instructions
        Positioned(
          bottom: 120,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Arahkan kamera ke barcode ISBN buku',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Manual Input Button
        Positioned(
          bottom: 40,
          left: 24,
          right: 24,
          child: ElevatedButton.icon(
            onPressed: () => _showManualInputDialog(),
            icon: const Icon(Icons.keyboard),
            label: const Text('Input ISBN Manual'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBrown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.primaryBrown),
            SizedBox(height: 24),
            Text(
              'Mencari informasi buku...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              if (_scannedCode != null) ...[
                const SizedBox(height: 16),
                Text(
                  'ISBN: $_scannedCode',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _resetScanner,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan Ulang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBrown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_bookInfo != null) {
      return _buildBookInfoCard();
    }

    return const SizedBox.shrink();
  }

  Widget _buildBookInfoCard() {
    return Container(
      color: AppTheme.warmWhite,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover & Title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover
                Container(
                  width: 120,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _bookInfo!['cover'] != null
                        ? Image.network(
                            _bookInfo!['cover'],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildPlaceholderCover(),
                          )
                        : _buildPlaceholderCover(),
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _bookInfo!['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'oleh ${_bookInfo!['authors']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoChip(Icons.qr_code, 'ISBN: ${_bookInfo!['isbn']}'),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            
            // Details
            const Text(
              'Informasi Buku',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBrown,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildInfoRow(Icons.business, 'Penerbit', _bookInfo!['publishers']),
            _buildInfoRow(Icons.calendar_today, 'Tahun Terbit', _bookInfo!['publishDate']),
            _buildInfoRow(Icons.menu_book, 'Jumlah Halaman', _bookInfo!['numberOfPages']),
            _buildInfoRow(Icons.category, 'Kategori', _bookInfo!['subjects']),
            
            if (_bookInfo!['description'] != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBrown,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _bookInfo!['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            const SizedBox(height: 32),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetScanner,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan Lagi'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryBrown,
                      side: const BorderSide(color: AppTheme.primaryBrown),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Pass book info back and navigate to add book screen
                      context.push('/add-book', extra: _bookInfo);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Jual Buku Ini'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBrown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCover() {
    return Container(
      color: AppTheme.cream,
      child: const Center(
        child: Icon(
          Icons.menu_book,
          size: 50,
          color: AppTheme.lightBrown,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryBrown),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryBrown),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showManualInputDialog() {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input ISBN Manual'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 13,
          decoration: const InputDecoration(
            hintText: 'Masukkan 10 atau 13 digit ISBN',
            prefixIcon: Icon(Icons.qr_code),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final isbn = controller.text.trim();
              if (isbn.length == 10 || isbn.length == 13) {
                setState(() {
                  _isScanning = false;
                  _isLoading = true;
                  _scannedCode = isbn;
                  _errorMessage = null;
                });
                _fetchBookInfo(isbn);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ISBN harus 10 atau 13 digit'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBrown,
            ),
            child: const Text('Cari'),
          ),
        ],
      ),
    );
  }
}

// Custom overlay shape for scanner
class _ScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double cutOutSize;

  const _ScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.5),
    this.borderRadius = 0,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: rect.center,
            width: cutOutSize,
            height: cutOutSize,
          ),
          Radius.circular(borderRadius),
        ),
      );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRect(rect)
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: rect.center,
            width: cutOutSize,
            height: cutOutSize,
          ),
          Radius.circular(borderRadius),
        ),
      )
      ..fillType = PathFillType.evenOdd;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final backgroundPath = Path()
      ..addRect(rect)
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: rect.center,
            width: cutOutSize,
            height: cutOutSize,
          ),
          Radius.circular(borderRadius),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(backgroundPath, paint);

    // Draw border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final borderRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: rect.center,
        width: cutOutSize,
        height: cutOutSize,
      ),
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(borderRect, borderPaint);

    // Draw corner accents
    final cornerLength = 30.0;
    final cornerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 2
      ..strokeCap = StrokeCap.round;

    final cutOutRect = Rect.fromCenter(
      center: rect.center,
      width: cutOutSize,
      height: cutOutSize,
    );

    // Top left
    canvas.drawLine(
      Offset(cutOutRect.left, cutOutRect.top + cornerLength),
      Offset(cutOutRect.left, cutOutRect.top + borderRadius),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutOutRect.left + cornerLength, cutOutRect.top),
      Offset(cutOutRect.left + borderRadius, cutOutRect.top),
      cornerPaint,
    );

    // Top right
    canvas.drawLine(
      Offset(cutOutRect.right, cutOutRect.top + cornerLength),
      Offset(cutOutRect.right, cutOutRect.top + borderRadius),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutOutRect.right - cornerLength, cutOutRect.top),
      Offset(cutOutRect.right - borderRadius, cutOutRect.top),
      cornerPaint,
    );

    // Bottom left
    canvas.drawLine(
      Offset(cutOutRect.left, cutOutRect.bottom - cornerLength),
      Offset(cutOutRect.left, cutOutRect.bottom - borderRadius),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutOutRect.left + cornerLength, cutOutRect.bottom),
      Offset(cutOutRect.left + borderRadius, cutOutRect.bottom),
      cornerPaint,
    );

    // Bottom right
    canvas.drawLine(
      Offset(cutOutRect.right, cutOutRect.bottom - cornerLength),
      Offset(cutOutRect.right, cutOutRect.bottom - borderRadius),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cutOutRect.right - cornerLength, cutOutRect.bottom),
      Offset(cutOutRect.right - borderRadius, cutOutRect.bottom),
      cornerPaint,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}
