
// ai_description.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/models.dart';
import 'ai_servicec.dart';





class AIDescriptionScreen extends StatefulWidget {
  @override
  _AIDescriptionScreenState createState() => _AIDescriptionScreenState();
}

class _AIDescriptionScreenState extends State<AIDescriptionScreen> {
  final CV cv = Get.arguments as CV;
  final _jobDescriptionController = TextEditingController();
  final _enhancedDescriptionController = TextEditingController();
  final _aiService = AIService();
  bool _isProcessing = false;
  List<String> _keywords = [];

  @override
  void initState() {
    super.initState();
    _enhancedDescriptionController.text = cv.description;
    _keywords = cv.extractedKeywords;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI CV Enhancement'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveDescription,
          ),
        ],
      ),
      body: Row(
        children: [
          // Left panel - Job Description Input
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  right: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Job Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _jobDescriptionController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Paste the job description here...',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _enhanceWithAI,
                    icon: _isProcessing 
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.auto_awesome),
                    label: Text(_isProcessing ? 'Processing...' : 'Enhance CV'),
                  ),
                ],
              ),
            ),
          ),
          // Right panel - Enhanced Content
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Enhanced CV Content',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _enhancedDescriptionController,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Key Terms',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _keywords.map((keyword) => Chip(
                      label: Text(keyword),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      onDeleted: () => _removeKeyword(keyword),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _enhanceWithAI() async {
    if (_jobDescriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a job description');
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final result = await _aiService.enhanceDescription(
        description: _jobDescriptionController.text,
        skills: cv.skills,
        experience: cv.experience,
      );
      
      setState(() {
        _enhancedDescriptionController.text = result.enhancedDescription;
        _keywords = result.extractedKeywords;
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to enhance description: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _removeKeyword(String keyword) {
    setState(() {
      _keywords.remove(keyword);
    });
  }

  void _saveDescription() {
    cv.description = _enhancedDescriptionController.text;
    cv.extractedKeywords = _keywords;
    Get.back();
  }
}