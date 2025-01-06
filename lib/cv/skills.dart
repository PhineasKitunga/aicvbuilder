// skills_form.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/models.dart';


class SkillsForm extends StatefulWidget {
  @override
  _SkillsFormState createState() => _SkillsFormState();
}

class _SkillsFormState extends State<SkillsForm> {
  final CV cv = Get.arguments as CV;
  final _skillController = TextEditingController();
  final _languageController = TextEditingController();
  late List<String> skills;
  late List<String> languages;

  @override
  void initState() {
    super.initState();
    skills = List.from(cv.skills);
    languages = List.from(cv.languages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skills & Languages'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSkillsSection(),
            SizedBox(height: 24),
            _buildLanguagesSection(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _saveSkills,
          child: Text('Save Skills & Languages'),
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _skillController,
                decoration: InputDecoration(
                  hintText: 'Add a skill',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addSkill,
              child: Text('Add'),
            ),
          ],
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.map((skill) {
            return Chip(
              label: Text(skill),
              onDeleted: () => _removeSkill(skill),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLanguagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Languages',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _languageController,
                decoration: InputDecoration(
                  hintText: 'Add a language',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addLanguage,
              child: Text('Add'),
            ),
          ],
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: languages.map((language) {
            return Chip(
              label: Text(language),
              onDeleted: () => _removeLanguage(language),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !skills.contains(skill)) {
      setState(() {
        skills.add(skill);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      skills.remove(skill);
    });
  }

  void _addLanguage() {
    final language = _languageController.text.trim();
    if (language.isNotEmpty && !languages.contains(language)) {
      setState(() {
        languages.add(language);
        _languageController.clear();
      });
    }
  }

  void _removeLanguage(String language) {
    setState(() {
      languages.remove(language);
    });
  }

  void _saveSkills() {
    cv.skills = skills;
    cv.languages = languages;
    Get.back();
  }
}
