// education_form.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/models.dart';

class EducationForm extends StatefulWidget {
  @override
  _EducationFormState createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  final CV cv = Get.arguments as CV;
  final _formKey = GlobalKey<FormState>();
  late List<Education> educationList;

  @override
  void initState() {
    super.initState();
    educationList = List.from(cv.education);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Education'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addEducation,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: educationList.length,
          itemBuilder: (context, index) => _buildEducationCard(index),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _saveEducation,
          child: Text('Save Education'),
        ),
      ),
    );
  }

  Widget _buildEducationCard(int index) {
    final education = educationList[index];
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              initialValue: education.institution,
              decoration: InputDecoration(labelText: 'Institution'),
              onChanged: (value) => education.institution = value,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required field' : null,
            ),
            TextFormField(
              initialValue: education.degree,
              decoration: InputDecoration(labelText: 'Degree'),
              onChanged: (value) => education.degree = value,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required field' : null,
            ),
            TextFormField(
              initialValue: education.field,
              decoration: InputDecoration(labelText: 'Field of Study'),
              onChanged: (value) => education.field = value,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required field' : null,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: education.gpa?.toString(),
                    decoration: InputDecoration(labelText: 'GPA (Optional)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                        education.gpa = double.tryParse(value),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removeEducation(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addEducation() {
    setState(() {
      educationList.add(Education(
        institution: '',
        degree: '',
        field: '',
        startDate: DateTime.now(),
        achievements: [],
      ));
    });
  }

  void _removeEducation(int index) {
    setState(() {
      educationList.removeAt(index);
    });
  }

  void _saveEducation() {
    if (_formKey.currentState!.validate()) {
      cv.education = educationList;
      Get.back();
    }
  }
}