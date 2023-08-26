import 'package:flutter/material.dart';
import 'dart:math';
import 'package:english_words/english_words.dart' as english_words;

class WordplayGameScreen extends StatefulWidget {
  const WordplayGameScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WordplayGameScreenState createState() => _WordplayGameScreenState();
}

class _WordplayGameScreenState extends State<WordplayGameScreen> {
  String randomLetters = '';
  TextEditingController wordGuessContr = TextEditingController();
  String feedbackMessage = '';
  //english word dictionary implement
  List<String> validWords = english_words.all.take(1000).toList();

  @override
  //init state bascially initiate the state when the stateful widget is called
  void initState() {
    super.initState();
    randomLetters = generateRandomLetters(6, 8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordplay Game'),
        backgroundColor: Colors.purple[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //label for random letter word
            Text(
              'Letter : $randomLetters',
              style: const TextStyle(fontSize: 24),
            ),
            //word guess label text
            TextField(
              controller: wordGuessContr,
              decoration: const InputDecoration(
                  labelText: 'Enter a Word Guess',
                  contentPadding: EdgeInsets.all(16)),
            ),
            //button to check guess
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                String wordGuess = wordGuessContr.text;
                checkWordGuess(wordGuess);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.purple[300], // Background color
                onPrimary: Colors.white, // Text color
                textStyle: TextStyle(fontSize: 18), // Text style
              ),
              child: const Text('Check Guess'),
            ),
            //feedbackmessage whether it is correct or not
            Text(
              feedbackMessage,
              style: TextStyle(
                fontSize: 18,
                color: feedbackMessage.contains('Correct')
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

//generating random letters from this letters
  String generateRandomLetters(int minLength, int maxLength) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final rand = Random();
    //this random letters can be of length greater than 6 it can be 6,7 or 8
    final length = minLength + rand.nextInt(maxLength - minLength + 1);
    String randomLetters = '';
    for (int i = 0; i < length; i++) {
      randomLetters += letters[rand.nextInt(letters.length)];
    }
    return randomLetters;
  }

// this is to keep track of wordguess if it is greater than 3 for wromg guess new round will get started
  int wordguesscounter = 0;
  bool isWordValid(String word) {
    return validWords.contains(word.toLowerCase());
  }

  void showWinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You won the game! Do you want to start a new game?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                randomLetters =
                    generateRandomLetters(6, 8); // Start a new round
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

// this method is to check the word if it is correct it will check with the
  void checkWordGuess(String wordGuess) {
    if (isWordValid(wordGuess) && canFormWord(wordGuess)) {
      setState(() {
        feedbackMessage =
            'Correct! "$wordGuess" is a valid word and can be formed from the random letters.';
        //clear the input field
        wordGuessContr.clear();
        //generate new random letters
        showWinDialog(context); // Show the win dialog
      });
    } else {
      setState(() {
        feedbackMessage =
            '"$wordGuess" is not a valid word, cannot be formed from the random letters.';
        wordguesscounter++;
        wordGuessContr.clear();
        if (wordguesscounter >= 3) {
          feedbackMessage = 'You lost!!!';
          wordGuessContr.clear(); // Clear the input field
          wordguesscounter = 0; // Reset the guess counter
          randomLetters =
              generateRandomLetters(6, 8); // Generate new random letters
        }
      });
    }
  }

  bool canFormWord(String wordGuess) {
    // Convert the randomLetters and wordGuess to lists for easy checking
    List<String> randomLetterList = randomLetters.split('');
    List<String> wordGuessList = wordGuess.split('');

    // Check if each letter in wordGuess is available in randomLetters
    for (String letter in wordGuessList) {
      if (randomLetterList.contains(letter)) {
        // Remove the used letter from randomLetters to avoid reusing it
        randomLetterList.remove(letter);
      } else {
        return false; // The letter is not available, word cannot be formed
      }
    }
    return true; // All letters are available, word can be formed
  }
}
