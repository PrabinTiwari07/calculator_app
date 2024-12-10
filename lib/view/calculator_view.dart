import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const CalculatorView(),
      },
    );
  }
}

class CalculatorView extends StatefulWidget {
  const CalculatorView({Key? key}) : super(key: key);

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  String displayText = '0';
  String operand = '';
  double? firstNumber;
  double? secondNumber;

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        displayText = '0';
        firstNumber = null;
        secondNumber = null;
        operand = '';
      } else if (value == '⌫') {
        displayText = displayText.length > 1
            ? displayText.substring(0, displayText.length - 1)
            : '0';
      } else if (['+', '-', '*', '/', '%'].contains(value)) {
        firstNumber = double.tryParse(displayText);
        operand = value;
        displayText = '0';
      } else if (value == '=') {
        secondNumber = double.tryParse(displayText);
        displayText = _evaluateExpression();
      } else {
        if (displayText == '0' && value != '.') {
          displayText = value;
        } else {
          displayText += value;
        }
      }
    });
  }

  String _evaluateExpression() {
    if (firstNumber == null || secondNumber == null || operand.isEmpty) {
      return 'Error';
    }
    double result;
    switch (operand) {
      case '+':
        result = firstNumber! + secondNumber!;
        break;
      case '-':
        result = firstNumber! - secondNumber!;
        break;
      case '*':
        result = firstNumber! * secondNumber!;
        break;
      case '/':
        if (secondNumber == 0) return 'Error';
        result = firstNumber! / secondNumber!;
        break;
      case '%':
        result = firstNumber! % secondNumber!;
        break;
      default:
        return 'Error';
    }
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonLabels = [
      'C',
      '⌫',
      '%',
      '/',
      '7',
      '8',
      '9',
      '*',
      '4',
      '5',
      '6',
      '-',
      '1',
      '2',
      '3',
      '+',
      '<-',
      '0',
      '.',
      '='
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                displayText,
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              padding: const EdgeInsets.all(8),
              itemCount: buttonLabels.length,
              itemBuilder: (context, index) {
                final label = buttonLabels[index];
                return ElevatedButton(
                  onPressed: () => onButtonPressed(label),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getButtonColor(label),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 24,
                      color: label == '=' ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getButtonColor(String label) {
    if (['C', '⌫', '%', '/', '*', '-', '+', '='].contains(label)) {
      return Colors.orange;
    } else {
      return Colors.grey.shade200;
    }
  }
}
