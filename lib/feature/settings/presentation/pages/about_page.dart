import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'.tr()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome to BrainBox'.tr(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your Gateway to Language Mastery Through the Magic of Movies!'.tr(),
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16),
            Text(
              'Our Mission:'.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'At BrainBox, we believe that language learning should be engaging, effective, and fun. Our unique approach to language acquisition harnesses the power of movie subtitles to immerse you in a world where learning meets entertainment.'.tr(),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'How It Works:'.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Add bullet points or numbered list for 'How It Works' section
            SizedBox(height: 15),
            Text(
              '1. Choose Your Movie: Dive into our extensive library of films and select your favorite. Whether it\'s a Hollywood blockbuster or a foreign indie gem, our collection is tailored to cater to all tastes and learning levels.'.tr(),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '2. Pick Your Language: Select the language you want to learn. From Spanish to Mandarin, French to Japanese, we offer a wide range of languages.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
                '3. Learn with Subtitles: As you watch, our intuitive app displays subtitles in both your native language and the language you\'re learning. This dual-subtitle system ensures comprehension while challenging you to expand your vocabulary.'.tr(),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '4. Interactive Learning Tools: Engage with interactive quizzes, flashcards, and vocabulary lists generated from the movie\'s dialogue. Test your knowledge and track your progress after each film.'.tr(),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '5. Customized Learning Experience: Set your own pace and choose specific topics or words you want to focus on. Our app adapts to your learning style, making every movie-watching experience a step towards language proficiency.'.tr(),
              style: TextStyle(fontSize: 16),
            ),
            // ... Continue with other steps
            SizedBox(height: 16),
            Text(
              'Why Movies?'.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Movies are not just about entertainment; they are cultural snapshots. They provide contextual learning, making it easier to understand idiomatic expressions, slang, and the natural flow of conversation. By learning through movies, you\'re not just memorizing words; you\'re experiencing the language as it\'s spoken by natives in real-life situations.'.tr(),
              style: TextStyle(fontSize: 16),
            ),
            // ... Add more sections as needed
            SizedBox(height: 16),
            Text(
              'Safe and Secure:'.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Your privacy and online safety are paramount. BrainBox is committed to protecting your data and providing a secure learning environment.'.tr(),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Join Our Community:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Become part of a global community of language enthusiasts. Share insights, discuss movies, and practice your new language skills with learners from around the world.'.tr(),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
