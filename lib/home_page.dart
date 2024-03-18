import 'package:allen/featurebox.dart';
import 'package:allen/openAIservice.dart';
import 'package:allen/palette.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final speechtotext = SpeechToText();
  String lastWords = '';
  FlutterTts flutterTts = FlutterTts();
  final OpenAIService openAIService = OpenAIService();
  String? generatedcontent;
  String? generatedimageurl;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initspeechtotext();
    inittexttospeech();
  }

  Future<void> inittexttospeech() async {
    await flutterTts.awaitSpeakCompletion(true);
    setState(() {});
  }

  Future<void> initspeechtotext() async {
    await speechtotext.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechtotext.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechtotext.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> SystemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechtotext.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: const Text('Allen')),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Virtual Assitant Image
          ZoomIn(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle),
                  ),
                ),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/virtualAssistant.png'))),
                )
              ],
            ),
          )
          // Chat Bubble
          ,
          FadeInRight(
            child: Visibility(
              visible: generatedimageurl == null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 40)
                    .copyWith(top: 30),
                decoration: BoxDecoration(
                    border: Border.all(color: Pallete.borderColor),
                    borderRadius: BorderRadius.circular(20)
                        .copyWith(topLeft: Radius.zero)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    generatedcontent == null
                        ? 'Good morning! What task can I do for you? '
                        : generatedcontent!,
                    style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallete.mainFontColor,
                        fontSize: generatedcontent == null ? 25 : 18),
                  ),
                ),
              ),
            ),
          ),
          if (generatedimageurl != null)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(generatedimageurl!)),
            ),
          SlideInLeft(
            child: Visibility(
              visible: generatedcontent == null && generatedimageurl == null,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 10, left: 22),
                child: const Text(
                  'Here are a few features',
                  style: TextStyle(
                      fontFamily: 'Cera Pro',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Pallete.mainFontColor),
                ),
              ),
            ),
          ),
          Visibility(
            visible: generatedcontent == null && generatedimageurl == null,
            child: Column(
              children: [
                SlideInLeft(
                  delay: Duration(milliseconds: start),
                  child: const FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headerText: 'ChatGPT',
                      descriptionText:
                          'A smarter way to stay organized and informed with ChatGPT'),
                ),
                SlideInLeft(
                  delay: Duration(milliseconds: start + delay),
                  child: const FeatureBox(
                      color: Pallete.secondSuggestionBoxColor,
                      headerText: 'Dall-E',
                      descriptionText:
                          'Get inspired and stay creative with your personal assistant powered by Dall-E'),
                ),
                SlideInLeft(
                  delay: Duration(milliseconds: start + 2 * delay),
                  child: const FeatureBox(
                      color: Pallete.thirdSuggestionBoxColor,
                      headerText: 'Smart Voice Assistant',
                      descriptionText:
                          'Get the best of both worlds with the voice assistant powered by Dall-E and ChatGPT'),
                ),
              ],
            ),
          ),
        ]),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if (await speechtotext.hasPermission &&
                speechtotext.isNotListening) {
              await initspeechtotext();
              await startListening();
            } else if (speechtotext.isListening) {
              final speech = await openAIService.isArtPromoptAI(lastWords);
              await stopListening();
              if (speech.contains('assets')) {
                generatedimageurl = speech;
                generatedcontent = null;
                setState(() {});
              } else {
                generatedimageurl = null;
                generatedcontent = speech;
                setState(() {});
                await SystemSpeak(speech);
              }
            } else {
              initspeechtotext();
            }
          },
          child: Icon(speechtotext.isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}
