import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:renbo/utils/constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// A data class to hold the structured response from the Gemini API.
class GeminiClassifiedResponse {
  final bool isHarmful;
  final String response;

  GeminiClassifiedResponse({
    this.isHarmful = false,
    this.response = "Sorry, I couldn't connect. Please try again.",
  });
}

// *** FIX: THERE IS ONLY ONE GeminiService CLASS DEFINITION NOW ***
class GeminiService {
  final String _apiKey = AppConstants.geminiApiKey;

  // For the manual HTTP request
  final String _modelUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-05-20:generateContent?key=';

  // *** FIX: Initialize the GenerativeModel from the SDK ***
  // This is needed for the generateThoughtOfTheDay method.
  final GenerativeModel _model;

  // Constructor to initialize the model
  GeminiService()
      : _model = GenerativeModel(
          model: 'gemini-2.5-flash-preview-05-20',
          apiKey: AppConstants.geminiApiKey,
        );

  /// Your existing method for chat classification - no changes needed here.
  Future<GeminiClassifiedResponse> generateAndClassify(String prompt) async {
    final headers = {'Content-Type': 'application/json'};

    final systemPrompt = """
You are Renbot, a supportive and non-judgmental AI assistant. Your role is to provide a safe space for users to express their thoughts and feelings. First, create an empathetic and supportive response to the user's message. Second, classify the user's message for self-harm or suicidal ideation.
** always be empathetic and supportive in your response. **
** always be calm, neutral, and non-judgmental. **
** listen and validate the user's feelings. **
** donot give a long reply , keep it simple and crisp **
*Your core principles:*
- *Listen Empathetically:* Acknowledge the user's feelings and perspectives.
- *Be Neutral and Calm:* Use a calm, measured, and conversational tone. Be professional and cool.
- *Offer Support:* Provide encouragement and validation.
- *Avoid Overly Passionate Language:* Use simple, direct language. Avoid excessive emojis or exclamation points.
- *Disclaimers:* You are not a human therapist and cannot give medical or diagnostic advice. Only state this when the user's message is directly related to a medical or clinical topic.
- *Language support:* If the user talks to you in a regional indian language reply to them using the same.
- *Concluding the talk:* If the conversation is leading to conclusion, give them support and tend towards conclusion.
You MUST respond in a valid JSON format that follows this exact schema:
{
  "type": "OBJECT",
  "properties": {
    "isHarmful": { "type": "BOOLEAN" },
    "response": { "type": "STRING" }
  }
}

- "isHarmful": Set to 'true' if the user's message contains any indication of self-harm, suicide, or immediate danger. Otherwise, set to 'false'.
- "response": This field must contain your complete, empathetic, and supportive message based on your core principles (calm, neutral, supportive, non-judgmental).

User's message: "$prompt"
""";

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": systemPrompt}
          ]
        }
      ],
      "generationConfig": {
        "responseMimeType": "application/json",
      }
    });

    try {
      final response = await http.post(
        Uri.parse('$_modelUrl$_apiKey'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jsonString = data['candidates'][0]['content']['parts'][0]['text'];
        final classifiedData = jsonDecode(jsonString);

        return GeminiClassifiedResponse(
          isHarmful: classifiedData['isHarmful'] ?? false,
          response: classifiedData['response'] ??
              "I'm having trouble understanding right now. Could we talk about something else?",
        );
      } else {
        return GeminiClassifiedResponse();
      }
    } catch (e) {
      return GeminiClassifiedResponse(
          response:
              "Something went wrong. Please check your internet connection. 😞");
    }
  }

  // *** FIX: THE NEW METHOD IS NOW INSIDE THE CORRECT CLASS ***
  Future<String> generateThoughtOfTheDay() async {
    try {
      const prompt =
          'Generate a short, positive, and insightful thought of the day for a mental wellness app. Make it concise and uplifting, like a fortune cookie message.';

      final response = await _model.generateContent([Content.text(prompt)]);

      if (response.text != null) {
        return response.text!;
      } else {
        return "The best way to predict the future is to create it."; // A fallback thought
      }
    } catch (e) {
      print("Error generating thought: $e");
      return "Kindness is a language which the deaf can hear and the blind can see."; // An error fallback
    }
  }
}
