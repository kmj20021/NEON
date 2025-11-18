// lib/screens/my_page_screen.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'photo_service.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final PhotoService _photoService = PhotoService();
  final ImagePicker _picker = ImagePicker();

  List<String> _imageUrls = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMyPhotos();
  }

  Future<void> _loadMyPhotos() async {
    setState(() => _isLoading = true);
    try {
      final urls = await _photoService.getMyPhotos();
      setState(() {
        _imageUrls = urls;
      });
    } catch (e) {
      debugPrint('사진 불러오기 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사진 목록을 불러오지 못했습니다.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _isLoading = true);
    try {
      final imageUrl = await _photoService.uploadPhoto(picked);
      setState(() {
        _imageUrls.insert(0, imageUrl); // 새로 업로드된 사진을 맨 앞에
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사진 업로드 성공!')),
        );
      }
    } catch (e) {
      debugPrint('사진 업로드 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사진 업로드에 실패했습니다.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        actions: [
          IconButton(
            onPressed: _pickAndUploadImage,
            icon: const Icon(Icons.add_a_photo),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _imageUrls.isEmpty
              ? const Center(child: Text('업로드한 사진이 없습니다.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: _imageUrls.length,
                  itemBuilder: (context, index) {
                    final url = _imageUrls[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const ColoredBox(
                          color: Colors.grey,
                          child: Icon(Icons.broken_image),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndUploadImage,
        child: const Icon(Icons.upload),
      ),
    );
  }
}
