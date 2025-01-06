import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/models.dart';
import '../services/auth_services.dart';
import '../services/storage.dart';

class CVEditorScreen extends StatefulWidget {
  @override
  _CVEditorScreenState createState() => _CVEditorScreenState();
}

class _CVEditorScreenState extends State<CVEditorScreen> {
  final CV cv = Get.arguments as CV;
  // final StorageService _storageService = Get.find();
  bool _isLoading = false;

  //   final CV cv = Get.arguments as CV;
  // final StorageService _storageService = Get.find();
  // final AuthService _authService = Get.find();
  // bool _isLoading = false;
    late final StorageService _storageService;
  late final AuthService _authService;


 @override
  void initState() {
    super.initState();
    // Initialize services in initState
    _storageService = Get.find<StorageService>();
    _authService = Get.find<AuthService>();
  }


   Future<void> _saveCV() async {
    setState(() => _isLoading = true);
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        await _storageService.saveCV(currentUser.uid, cv);
        Get.snackbar('Success', 'CV saved successfully');
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save CV: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.description),
            SizedBox(width: 8),
            Text('Edit CV'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _downloadCV,
          ),
          IconButton(
            icon: _isLoading ? 
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white)
              ) : 
              Icon(Icons.save),
            onPressed: _isLoading ? null : _saveCV,
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Panel - Navigation
          Container(
            width: 250,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey.shade200)),
            ),
            child: ListView(
              padding: EdgeInsets.all(12),
              children: [
                _buildNavItem('Basic Information', '/cv/basic-info', Icons.person),
                _buildNavItem('Education', '/cv/education', Icons.school),
                _buildNavItem('Experience', '/cv/experience', Icons.work),
                _buildNavItem('Skills', '/cv/skills', Icons.psychology),
                _buildNavItem('Languages', '/cv/languages', Icons.language),
                Divider(height: 32),
                _buildNavItem('AI Description', '/cv/ai-description', Icons.auto_awesome),
              ],
            ),
          ),
          // Right Panel - Content
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                _buildPreviewSection(
                  'Basic Information',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cv.title, style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
                _buildPreviewSection(
                  'Education',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cv.education.map((edu) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${edu.degree} in ${edu.field}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(edu.institution),
                          Text('${_formatDate(edu.startDate)} - ${edu.endDate != null ? _formatDate(edu.endDate!) : 'Present'}'),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
                _buildPreviewSection(
                  'Experience',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cv.experience.map((exp) => Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exp.position,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${exp.company} - ${exp.location}'),
                          Text('${_formatDate(exp.startDate)} - ${exp.endDate != null ? _formatDate(exp.endDate!) : 'Present'}'),
                          if (exp.responsibilities.isNotEmpty) ...[
                            SizedBox(height: 8),
                            Text('Responsibilities:', 
                              style: TextStyle(fontWeight: FontWeight.w500)),
                            ...exp.responsibilities.map((r) => Padding(
                              padding: EdgeInsets.only(left: 16, top: 4),
                              child: Text('• $r'),
                            )),
                          ],
                          if (exp.achievements.isNotEmpty) ...[
                            SizedBox(height: 8),
                            Text('Achievements:', 
                              style: TextStyle(fontWeight: FontWeight.w500)),
                            ...exp.achievements.map((a) => Padding(
                              padding: EdgeInsets.only(left: 16, top: 4),
                              child: Text('• $a'),
                            )),
                          ],
                        ],
                      ),
                    )).toList(),
                  ),
                ),
                _buildPreviewSection(
                  'Skills',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: cv.skills.map((skill) => Chip(
                      label: Text(skill),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    )).toList(),
                  ),
                ),
                _buildPreviewSection(
                  'Languages',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: cv.languages.map((lang) => Chip(
                      label: Text(lang),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    )).toList(),
                  ),
                ),
                _buildPreviewSection(
                  'AI-Enhanced Description',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cv.description),
                      SizedBox(height: 12),
                      if (cv.extractedKeywords.isNotEmpty) ...[
                        Text(
                          'Keywords:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: cv.extractedKeywords.map((keyword) => Chip(
                            label: Text(keyword),
                            backgroundColor: Colors.blue.shade50,
                          )).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, String route, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => Get.toNamed(route, arguments: cv),
      trailing: Icon(Icons.chevron_right),
    );
  }

  Widget _buildPreviewSection(String title, Widget content) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => Get.toNamed('/cv/${title.toLowerCase().replaceAll(' ', '-')}', arguments: cv),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: content,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.year}';
  }

  // Future<void> _saveCV() async {
  //   setState(() => _isLoading = true);
  //   try {
  //     await _storageService.saveCV(cv);
  //     Get.snackbar('Success', 'CV saved successfully');
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to save CV');
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  void _downloadCV() {
    // Implement download functionality
  }
}