import 'package:flutter/material.dart';
import 'package:number_to_word_arabic/number_to_word_arabic.dart';
import 'package:number_to_words_english/number_to_words_english.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Currency converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double? _currentValue = 0;
  String arabicValue = '';
  String englishValue = '';

  void onChangeValue(double? t) {
    if (t != null) {
      setState(() {
        _currentValue = t;
      });
    }
  }

  // Method to convert both integer and decimal parts to Arabic
  String convertNumberToArabicWords(double value) {
    int integerPart = value.toInt(); // Get the integer part
    String integerPartInWords = Tafqeet.convert(
        integerPart.toString()); // Convert integer part to words

    String decimalPart = (value - integerPart)
        .toStringAsFixed(2)
        .split('.')[1]; // Get the decimal part
    int decimalPartAsInt =
        int.parse(decimalPart); // Convert decimal to int for word conversion

    if (decimalPartAsInt > 0) {
      String decimalPartInWords = Tafqeet.convert(decimalPartAsInt.toString());
      return '$integerPartInWords دينار و $decimalPartInWords مليم '; // Combine integer and decimal parts
    } else {
      return '$integerPartInWords دينار'; // Only integer part
    }
  }

  // Method to convert both integer and decimal parts to English
  String convertNumberToEnglishWords(double value) {
    int integerPart = value.toInt(); // Get the integer part
    String integerPartInWords = NumberToWordsEnglish.convert(integerPart);

    String decimalPart = (value - integerPart)
        .toStringAsFixed(2)
        .split('.')[1]; // Get the decimal part
    int decimalPartAsInt = int.parse(decimalPart);

    if (decimalPartAsInt > 0) {
      String decimalPartInWords =
          NumberToWordsEnglish.convert(decimalPartAsInt);
      return '$integerPartInWords dollars and $decimalPartInWords cents'; // Combine integer and decimal parts
    } else {
      return '$integerPartInWords dollars'; // Only integer part
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (t) {
                double? parsedValue = double.tryParse(t);
                onChangeValue(parsedValue);
              },
            ),
            Text(
              'Current Value: $_currentValue',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
              onPressed: () {
                if (_currentValue != null) {
                  String v = convertNumberToArabicWords(_currentValue!);

                  setState(() {
                    arabicValue = v;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                shape: const LinearBorder(),
              ),
              child: const Text("Convert to Arabic"),
            ),
            const SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
              onPressed: () {
                if (_currentValue != null) {
                  String v = convertNumberToEnglishWords(_currentValue!);
                  setState(() {
                    englishValue = v;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: const LinearBorder(),
              ),
              child: const Text("Convert to English"),
            ),
            const SizedBox(
              height: 20.0,
            ),
            if (arabicValue.isNotEmpty)
              Text(
                'Arabic Value: $arabicValue',
                style: const TextStyle(fontSize: 24, color: Colors.black),
              ),
            if (englishValue.isNotEmpty)
              Text(
                'English Value: $englishValue',
                style: const TextStyle(fontSize: 24, color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}
