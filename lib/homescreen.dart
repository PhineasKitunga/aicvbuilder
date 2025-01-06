

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/auth_services.dart';
import 'services/storage.dart';
import 'models/models.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = Get.find();
  
  final List<Map<String, String>> _templates = [
    {'name': 'Professional', 'description': 'Traditional corporate style'},
    {'name': 'Creative', 'description': 'Modern design-focused layout'},
    {'name': 'Academic', 'description': 'Research & publication focused'},
    {'name': 'Technical', 'description': 'IT & Engineering oriented'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [
            Icon(Icons.description, size: 28),
            SizedBox(width: 12),
            Text('CV Builder Pro'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
          TextButton.icon(
            icon: Icon(Icons.logout, color: Colors.white),
            label: Text('Logout', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _authService.signOut();
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        future: _authService.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return _buildEmptyState();
          }

          final user = snapshot.data!;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 300,
                child: _buildSidePanel(user, context),
              ),
              Expanded(
                child: _buildMainContent(user, context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSidePanel(User user, BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  Text(
                    user.fullName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(Icons.email, user.email),
                  SizedBox(height: 4),
                  _buildInfoRow(Icons.phone, user.phoneNumber),
                  SizedBox(height: 16),
                  OutlinedButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text('Edit Profile'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Tips',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 12),
                  _buildTipItem('Write a strong summary'),
                  _buildTipItem('Include relevant skills'),
                  _buildTipItem('Highlight achievements'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(User user, BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create New CV',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: _templates.map((template) => _buildTemplateCard(
                      template['name']!,
                      template['description']!,
                      onTap: () => _createNewCV(template['name']!),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Your CVs',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                if (user.cvs.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text('No CVs yet. Create your first one!'),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: user.cvs.length,
                    itemBuilder: (context, index) => _buildCVCard(user.cvs[index], user.uid),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(String name, String description, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCVCard(CV cv, String userId) {
    return Card(
      child: InkWell(
        onTap: () => Get.toNamed('/cv/editor', arguments: cv),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cv.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                        ),
                        value: 'edit',
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Delete'),
                        ),
                        value: 'delete',
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        Get.toNamed('/cv/editor', arguments: cv);
                      } else if (value == 'delete') {
                        _deleteCV(userId, cv.id);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Last updated: ${_formatDate(cv.updatedAt)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.tips_and_updates, size: 16, color: Colors.amber),
          SizedBox(width: 8),
          Expanded(child: Text(tip, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No CVs found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Create your first CV to get started'),
        ],
      ),
    );
  }

  void _createNewCV(String template) {
    final newCV = CV(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New $template CV',
      education: [],
      experience: [],
      skills: [],
      languages: [],
      description: '',
      extractedKeywords: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    Get.toNamed('/cv/editor', arguments: newCV);
  }

  Future<void> _deleteCV(String userId, String cvId) async {
    try {
      await Get.find<StorageService>().deleteCV(userId, cvId);
      Get.snackbar('Success', 'CV deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete CV');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('CV Writing Tips'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Keep your CV concise and relevant'),
            Text('• Use action verbs to describe achievements'),
            Text('• Customize for each job application'),
            Text('• Proofread carefully'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }
}