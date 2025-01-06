

// ai_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/models.dart';

class AIService {
  static const _apiKey = 'YOUR_OPENAI_API_KEY';
  static const _apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<AIEnhancementResult> enhanceDescription({
    required String description,
    required List<String> skills,
    required List<Experience> experience,
  }) async {
    try {
      final prompt = _buildPrompt(description, skills, experience);
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a professional CV writer. Extract keywords and enhance the description while maintaining authenticity.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final enhancedText = data['choices'][0]['message']['content'];
        final keywords = _extractKeywords(enhancedText);
        
        return AIEnhancementResult(
          enhancedDescription: enhancedText,
          extractedKeywords: keywords,
        );
      } else {
        throw Exception('Failed to enhance description');
      }
    } catch (e) {
      throw Exception('AI service error: ${e.toString()}');
    }
  }

  String _buildPrompt(String description, List<String> skills, List<Experience> experience) {
    return '''
    Original Description: $description
    
    Skills: ${skills.join(', ')}
    
    Experience: ${experience.map((e) => '${e!.position} at ${e.company}').join(', ')}
    
    Please enhance this description by:
    1. Making it more professional and impactful
    2. Incorporating relevant skills naturally
    3. Highlighting key achievements
    4. Maintaining authenticity
    5. Extracting key keywords
    ''';
  }

  List<String> _extractKeywords(String text) {
    // Implement keyword extraction logic
    // This is a simple implementation - consider using NLP for better results
    final words = text.toLowerCase().split(' ');
    final keywords = words.where((word) => word.length > 4).toSet().toList();
    return keywords.take(10).toList();
  }
}

class AIEnhancementResult {
  final String enhancedDescription;
  final List<String> extractedKeywords;

  AIEnhancementResult({
    required this.enhancedDescription,
    required this.extractedKeywords,
  });
}

