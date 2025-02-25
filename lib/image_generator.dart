import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ImageGenerator {
  Future<String?> generate(String name);
}

class ImageGeneratorFactory {
  static ImageGenerator create() {
    return kDebugMode ? RandomImageGenerator() : OpenAiImageGenerator();
  }
}

class RandomImageGenerator implements ImageGenerator {
  var images = [
    "https://picsum.photos/200",
    "https://picsum.photos/500",
    "https://picsum.photos/300",
    "https://picsum.photos/450",
    "https://picsum.photos/250",
    "https://picsum.photos/350",
  ];

  @override
  Future<String?> generate(String name) async {
    return images[Random().nextInt(images.length)];
  }
}

class OpenAiImageGenerator implements ImageGenerator {
  static final String _apiUrl = "https://api.openai.com/v1/images/generations";

  @override
  Future<String?> generate(String name) async {
    final String _apiKey = dotenv.env['OPEN_AI_KEY'] ?? '';
    print("in the function");
    if (_apiKey.isEmpty) {
      return null;
    }
    print("$name, name");
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "dall-e-2",
          "prompt": "Generate an image of $name",
          "n": 1,
          "size": "256x256"
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Generated image: ${data['images'][0]['url']}");
        return data['images'][0]['url'];
      } else {
        print("Failed to generate image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
