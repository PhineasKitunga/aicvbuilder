
// experience_form.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/models.dart';

class ExperienceForm extends StatefulWidget {
  @override
  _ExperienceFormState createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<ExperienceForm> {
  final CV cv = Get.arguments as CV;
  final _formKey = GlobalKey<FormState>();
  late List<Experience> experienceList;

  @override
  void initState() {
    super.initState();
    experienceList = List.from(cv.experience);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Experience'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addExperience,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: experienceList.length,
          itemBuilder: (context, index) => _buildExperienceCard(index),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _saveExperience,
          child: Text('Save Experience'),
        ),
      ),
    );
  }

  Widget _buildExperienceCard(int index) {
    final experience = experienceList[index];
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              initialValue: experience.company,
              decoration: InputDecoration(labelText: 'Company'),
              onChanged: (value) => experience.company = value,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required field' : null,
            ),
            TextFormField(
              initialValue: experience.position,
              decoration: InputDecoration(labelText: 'Position'),
              onChanged: (value) => experience.position = value,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required field' : null,
            ),
            TextFormField(
              initialValue: experience.location,
              decoration: InputDecoration(labelText: 'Location'),
              onChanged: (value) => experience.location = value,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required field' : null,
            ),
            CheckboxListTile(
              title: Text('Current Position'),
              value: experience.isCurrentPosition,
              onChanged: (value) {
                setState(() {
                  experience.isCurrentPosition = value ?? false;
                });
              },
            ),
            _buildResponsibilitiesList(experience),
            _buildAchievementsList(experience),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _removeExperience(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsibilitiesList(Experience experience) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Responsibilities'),
        ...experience.responsibilities.asMap().entries.map((entry) {
          return Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: entry.value,
                  onChanged: (value) {
                    experience.responsibilities[entry.key] = value;
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    experience.responsibilities.removeAt(entry.key);
                  });
                },
              ),
            ],
          );
        }),
        TextButton(
          onPressed: () {
            setState(() {
              experience.responsibilities.add('');
            });
          },
          child: Text('Add Responsibility'),
        ),
      ],
    );
  }

  Widget _buildAchievementsList(Experience experience) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements'),
        ...experience.achievements.asMap().entries.map((entry) {
          return Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: entry.value,
                  onChanged: (value) {
                    experience.achievements[entry.key] = value;
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    experience.achievements.removeAt(entry.key);
                  });
                },
              ),
            ],
          );
        }),
        TextButton(
          onPressed: () {
            setState(() {
              experience.achievements.add('');
            });
          },
          child: Text('Add Achievement'),
        ),
      ],
    );
  }

  void _addExperience() {
    setState(() {
      experienceList.add(Experience(
        company: '',
        position: '',
        location: '',
        startDate: DateTime.now(),
        isCurrentPosition: false,
        responsibilities: [],
        achievements: [],
      ));
    });
  }

  void _removeExperience(int index) {
    setState(() {
      experienceList.removeAt(index);
    });
  }

  void _saveExperience() {
    if (_formKey.currentState!.validate()) {
      cv.experience = experienceList;
      Get.back();
    }
  }
}
