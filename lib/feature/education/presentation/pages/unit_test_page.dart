import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/feature/education/data/models/book_model.dart';
import 'package:brain_box/feature/education/presentation/manager/education_bloc.dart';
import 'package:brain_box/feature/settings/presentation/manager/settings/settings_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/exceptions/failure.dart';
import '../../../../core/singletons/storage/storage_repository.dart';
import '../../../../core/singletons/storage/store_keys.dart';
import '../../data/models/essential_model.dart';
import 'incorrect_words_page.dart';

class UnitTestPage extends StatefulWidget {
  final Essential book;
  final List<int> selectedUnits;

  const UnitTestPage({super.key, required this.book, required this.selectedUnits});

  @override
  State<UnitTestPage> createState() => _UnitTestPageState();
}

class _UnitTestPageState extends State<UnitTestPage> {
  List<EssentialModel> incorrectAnswers = [];
  ValueNotifier<EssentialModel> current = ValueNotifier(EssentialModel());
  ValueNotifier<int> size = ValueNotifier(0);
  ValueNotifier<int> testIndex = ValueNotifier(1);
  ValueNotifier<int> timerCount = ValueNotifier(160);
  ValueNotifier<bool> isDisable = ValueNotifier(false);
  AudioPlayer audioPlayer = AudioPlayer(playerId: const Uuid().v4())..audioCache.prefix = 'assets/';
  ValueNotifier<List<String>> options = ValueNotifier(['varA', 'varB', 'varC', 'varD']);
  ValueNotifier<int?> selectedOptionIndex = ValueNotifier(null);
  ValueNotifier<int?> correctOptionIndex = ValueNotifier(null);
  Timer? _timer;
  List<EssentialModel> testList = [];
  bool isLoading = true;

  @override
  void initState() {
    // timerCount = ValueNotifier(60 * widget.selectedUnits.length);

    context.read<EducationBloc>().add(GetWordsByUnitsEvent(
        essential: widget.book,
        unit: widget.selectedUnits,
        onFail: (Failure fail) {},
        onSuccess: (List<EssentialModel> list) {
          testList.addAll(list);
          startTimer();
          setupQuestion(testList[0]);
          setState(() {
            isLoading = false;
          });
        }));
    super.initState();
  }

  @override
  void dispose() async {
    await audioPlayer.dispose();
    super.dispose();
  }

  void onVariantSelected(String selectedVariant) {
    // Check if the selected variant is correct

    // Provide visual feedback
    // You might need to store the selected index and use setState to trigger a rebuild for visual feedback
    setState(() {
      selectedOptionIndex.value = options.value.indexOf(selectedVariant);
      isDisable.value = true; // Disable further clicks until the next question loads
    });

    // Show correct/incorrect feedback here if you want, perhaps using a dialog or a SnackBar

    // Load the next question after a delay
    Future.delayed(const Duration(seconds: 1), () {
      // Move to the next question
      loadNextQuestion();
    });
  }

  void loadNextQuestion() {
    // Increment the index for the next question
    int nextIndex = testIndex.value + 1;

    // If there are more questions
    if (nextIndex < testList.length) {
      setState(() {
        testIndex.value = nextIndex; // Update the test index
        current.value = testList[nextIndex]; // Set the new current question
        isDisable.value = false; // Re-enable the selection
        selectedOptionIndex.value = null; // Reset the selected option

        // Reset the timer for the new question
        timerCount.value = 60;
      });

      // Generate a new set of variants for the next question
      generateVariantsForQuestion(current.value);
    } else {
      // No more questions, navigate to the results page or handle the test end
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => IncorrectWordsPage(
                    list: incorrectAnswers,
                  )));
    }
  }

  void generateVariantsForQuestion(EssentialModel question) {
    // Extract the correct answer
    String correctAnswer = (context.read<SettingsBloc>().state.languageModel.shortName == 'ru'
        ? question.translationRu
        : question.translationEn)!;

    // Create a set to hold unique options and add the correct answer
    Set<String> newOptions = {correctAnswer};

    // Add random options until we have the desired number
    while (newOptions.length < 4) {
      EssentialModel randomContent = testList[Random().nextInt(testList.length)];
      newOptions.add((context.read<SettingsBloc>().state.languageModel.shortName == 'ru'
          ? randomContent.translationRu
          : randomContent.translationEn)!);
    }

    // Convert the set to a list and shuffle it to randomize the options
    List<String> shuffledOptions = newOptions.toList()..shuffle();

    // Update the options ValueNotifier
    options.value = shuffledOptions;

    // Find the index of the correct answer in the shuffled options
    correctOptionIndex.value = shuffledOptions.indexOf(correctAnswer);

    // Reset timer or other relevant state here if needed
    // timerCount.value = 60;
  }

  void setupQuestion(EssentialModel question) {
    // Identify the correct answer
    String correctAnswer = (context.read<SettingsBloc>().state.languageModel.shortName == 'ru'
        ? question.translationRu
        : question.translationEn)!;

    // Shuffle the list of content to get random options
    List<EssentialModel> randomOptions = List.of(testList)..shuffle();
    // Remove the correct answer if it exists in the list to avoid duplication
    randomOptions.removeWhere((content) =>
        (context.read<SettingsBloc>().state.languageModel.shortName == 'ru'
            ? content.translationRu
            : content.translationEn) ==
        correctAnswer);
    // Take the first three items as wrong answers
    List<String> wrongAnswers = randomOptions
        .take(3)
        .map((content) => (context.read<SettingsBloc>().state.languageModel.shortName == 'ru'
            ? content.translationRu
            : content.translationEn)!)
        .toList();

    // Now, add the correct answer and shuffle the options
    List<String> allOptions = [...wrongAnswers, correctAnswer]..shuffle();

    // Now update the ValueNotifiers
    current.value = question; // Set the current question
    options.value = allOptions; // Set the options
    correctOptionIndex.value = allOptions.indexOf(correctAnswer); // Set the index of the correct answer
    // Size and other initializations...
    size.value = testList.length;
    // Reset the selected option index
    selectedOptionIndex.value = null;
    // Other relevant state like timer
    timerCount.value = 60 * widget.selectedUnits.length;
  }

  void nextTest(String selectedVariant) {
    // First, check if the user has selected an option.
    if (selectedOptionIndex.value == null) {
      // Optionally, show a message to prompt the user to select an option.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an option!')),
      );
      return;
    }

    // Check if the selected answer is correct.
    bool isCorrect = selectedOptionIndex.value == correctOptionIndex.value;
    if (isCorrect) {
      // Update logic for correct answer
      // For example, increment a score counter or update state
    } else {
      // Update logic for incorrect answer
      // For example, record the mistake or provide feedback
    }

    // Prepare to load the next test.
    if (testIndex.value < size.value - 1) {
      // Move to the next test if there are more tests available.
      testIndex.value += 1;
      current.value = testList[testIndex.value];

      // Reset the test state for the new question.
      selectedOptionIndex.value = null;
      correctOptionIndex.value = null;
      isDisable.value = false;

      // Optionally, reset the timer or other relevant state.
      timerCount.value = 60;
    } else {
      // If there are no more tests, navigate to the results page or finish the test.
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => IncorrectWordsPage(
                    list: incorrectAnswers,
                  )));
    }
  }

  Future<void> selectOption(int index) async {
    if (isDisable.value) return; // If already disabled, ignore the taps

    bool isCorrect = index == correctOptionIndex.value;

    // Provide immediate feedback
    setState(() {
      selectedOptionIndex.value = index;
      isDisable.value = true; // Disable further selections
    });
    await audioPlayer.stop();
    if (!isCorrect) {
      try {
        await audioPlayer.play(AssetSource('not_correct.mp3'));
      } catch (e) {
        await audioPlayer.stop();
        // await audioPlayer.play(AssetSource('not_correct.mp3'));
      }
      // If the answer is incorrect, add to the incorrectAnswers list
      incorrectAnswers.add(current.value); // Add the index of the current question
    } else {
      try {
        await audioPlayer.play(AssetSource('correct.mp3'));
      } catch (e) {
        await audioPlayer.stop();

      }
    }

    // Load the next question after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      loadNextQuestion();
    });
  }

  Color getOptionColor(int index) {
    if (selectedOptionIndex.value == null) return Colors.grey;

    if (index == selectedOptionIndex.value) {
      if (StorageRepository.getBool(StoreKeys.appSound)) {
        if (index == correctOptionIndex.value) {
          // audioPlayer.play(AssetSource('correct.mp3'));
        } else {
          // audioPlayer.play(AssetSource('not_correct.mp3'));
        }
      }
      return index == correctOptionIndex.value ? Colors.green : Colors.red;
    } else if (index == correctOptionIndex.value) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  Widget optionWidget(int index) {
    return Container(
      width: double.maxFinite,
      height: 50,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
      decoration: BoxDecoration(
        color: getOptionColor(index),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text('${String.fromCharCode('A'.codeUnitAt(0) + index)})'),
          const SizedBox(
            width: 10,
          ),
          ValueListenableBuilder(
            valueListenable: options,
            builder: (context, List<String> values, _) {
              return Text(values[index]);
            },
          ),
        ],
      ),
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (timerCount.value == 0) {
          timer.cancel(); // Stop the timer as it has reached zero
          // Here you can handle what happens when the timer runs out
          // For example, automatically move to the next question
          loadNextQuestion();
        } else {
          timerCount.value--;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Book test 1'),
                      ValueListenableBuilder(
                          valueListenable: timerCount, builder: (context, value, _) => Text('$value s')),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 0,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 150,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 10,
                            top: 10,
                            child: ValueListenableBuilder(
                              valueListenable: testIndex,
                              builder: (context, indexValue, _) => ValueListenableBuilder(
                                  valueListenable: size,
                                  builder: (context, sizeValue, _) => Text('$indexValue/$sizeValue')),
                            ),
                          ),
                          Center(
                            child: ValueListenableBuilder(
                              valueListenable: current,
                              builder: (context, EssentialModel value, _) => AutoSizeText(
                                value.word ?? 'null',
                                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Text('Choose one of the answers:', textAlign: TextAlign.center),
                ...List.generate(options.value.length, (index) {
                  return GestureDetector(
                    onTap: () => selectOption(index),
                    child: optionWidget(index),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10, bottom: 10),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Leave test')),
                  ),
                ),
              ],
            ),
    );
  }
}
