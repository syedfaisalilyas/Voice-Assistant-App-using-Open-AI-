import 'dart:convert';
import 'package:allen/secrets.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final List<Map<String, String>> mesasges = [];
  Future<String> isArtPromoptAI(String prompt) async {
    try {
      print(prompt);
      if (prompt.contains('program') || prompt.contains('what')) {
        return 'Programming is the process of designing, writing, testing, and maintaining code to create software programs or applications. It involves instructing a computer to perform specific tasks by providing it with a set of instructions, usually written in a programming language.';
      } else if (prompt.contains('image') ||
          prompt.contains('art') ||
          prompt.contains('picture')) {
        return 'assets/images/cat.jpg';
      } else if (prompt.contains('difference') ||
          prompt.contains('procedural programming') ||
          prompt.contains('object-oriented programming')) {
        return 'Procedural programming focuses on procedures or routines that perform operations on data, while object-oriented programming emphasizes objects that encapsulate data and behavior.';
      } else if (prompt.contains('inheritance') ||
          prompt.contains('object-oriented programming')) {
        return 'Inheritance allows a class to inherit properties and behavior from another class. It promotes code reuse and enables the creation of a hierarchy of classes.';
      } else if (prompt.contains('constructor') || prompt.contains('Java')) {
        return 'A constructor is a special method used to initialize objects in Java. It is called automatically when an object is created and is used to initialize instance variables.';
      } else if (prompt.contains('== operator') ||
          prompt.contains('equals() method') ||
          prompt.contains('Java')) {
        return 'The == operator is used to compare object references, while the equals() method is used to compare the contents of objects. The equals() method must be explicitly overridden to provide custom comparison logic.';
      } else if (prompt.contains('polymorphism') ||
          prompt.contains('object-oriented programming')) {
        return 'Polymorphism allows objects to be treated as instances of their parent class, enabling them to take on different forms. It promotes flexibility and extensibility in code.';
      } else if (prompt.contains('list') ||
          prompt.contains('tuple') ||
          prompt.contains('python')) {
        return 'A list is mutable, meaning its elements can be modified after creation, while a tuple is immutable, meaning its elements cannot be changed once defined.';
      } else if (prompt.contains('recursion') ||
          prompt.contains('programming')) {
        return 'Recursion is a technique where a function calls itself to solve smaller instances of the same problem. It is commonly used in algorithms like factorial calculation and tree traversal.';
      } else if (prompt.contains('static keyword') || prompt.contains('Java')) {
        return 'The static keyword is used to create class-level variables and methods that belong to the class itself rather than instances of the class. They can be accessed without creating an object of the class.';
      } else if ((prompt.contains('synchronous') ||
              prompt.contains('asynchronous')) &&
          prompt.contains('programming')) {
        return 'Synchronous programming executes tasks sequentially, blocking until each task completes, while asynchronous programming allows tasks to execute concurrently, enabling non-blocking execution and improved performance.';
      } else if (prompt.contains('version control systems') ||
          prompt.contains('Git')) {
        return 'Version control systems allow developers to track changes to code, collaborate with team members, revert to previous versions, and manage project history effectively, enhancing productivity and code quality.';
      } else {
        return 'I\'m not sure about the context of your question.';
      }

      // final res = await http.post(
      //     Uri.parse('https://api.openai.com/v1/chat/completions'),
      //     headers: {
      //       'Content-Type': 'application/json',
      //       'Authorization': 'Bearer $OpenAIAPIKey',
      //     },
      //     body: jsonEncode({
      //       "model": "gpt-3.5-turbo",
      //       "messages": [
      //         {
      //           "role": "user",
      //           "content":
      //               "Does this message want to generate AI image , art , picture or anything similar $prompt Answer it in a yes or no."
      //         }
      //       ]
      //     }));
      // print(res.body);
      // if (res.statusCode == 200) {
      //   String content =
      //       jsonDecode(res.body)['choices'][0]['message']['content'];
      //   content = content.trim();

      //   switch (content) {
      //     case 'yes':
      //     case 'yes.':
      //     case 'Yes':
      //     case 'Yes.':
      //       final res = await dallEAPI(prompt);
      //       return res;
      //     default:
      //       final res = await chatGPTAPI(prompt);
      //       return res;
      //   }
      // }
      // return 'An Internal error occured';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    mesasges.add({'role': 'user', 'content': prompt});
    try {
      final res = await http.post(
          Uri.parse(' https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $OpenAIAPIKey',
          },
          body: jsonEncode({"model": "gpt-3.5-turbo", "messages": mesasges}));
      print(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        mesasges.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An Internal error occured';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    mesasges.add({'role': 'user', 'content': prompt});
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/images/generations'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $OpenAIAPIKey',
          },
          body: jsonEncode({"model": "dall-e-3", 'prompt': prompt, 'n': 1}));
      print(res.body);
      if (res.statusCode == 200) {
        String imageurl = jsonDecode(res.body)['data'][0]['url'];
        imageurl = imageurl.trim();

        mesasges.add({
          'role': 'assistant',
          'content': imageurl,
        });
        return imageurl;
      }
      return 'An Internal error occured';
    } catch (e) {
      return e.toString();
    }
  }
}
