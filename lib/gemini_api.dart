import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiApi {
  final String apiKey;
  final Uri endpoint = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent',
  );

  GeminiApi(this.apiKey);

Future<String> sendPrompt(String prompt) async {
  final response = await http.post(
    endpoint,
    headers: {
      'Content-Type': 'application/json',
      'X-goog-api-key': apiKey,
    },
    body: json.encode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    final parts = data['candidates']?[0]?['content']?['parts'];
    if (parts != null && parts is List && parts.isNotEmpty) {
      final text = parts[0]['text'];
      if (text != null) return text;
    }
    return 'No text found in response parts';
  } else {
    throw Exception('Failed: ${response.statusCode} ${response.body}');
  }
}
}