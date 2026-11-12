import 'package:flutter/material.dart';

import '../../widgets/app_text_field.dart';
import '../../widgets/operator_button.dart';
import '../../widgets/result_card.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final num1Controller = TextEditingController();
  final num2Controller = TextEditingController();
  String result = '0';
  String? errorText;

  String format(double value) {
    return value == value.truncateToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  void calculate(String operator) {
    final a = double.tryParse(num1Controller.text.trim());
    final b = double.tryParse(num2Controller.text.trim());

    if (a == null || b == null) {
      setState(() {
        errorText = 'Enter valid numbers in both fields.';
        result = '0';
      });
      return;
    }

    if (operator == '/' && b == 0) {
      setState(() {
        errorText = 'Cannot divide by zero.';
        result = '0';
      });
      return;
    }

    double answer;
    switch (operator) {
      case '+':
        answer = a + b;
        break;
      case '-':
        answer = a - b;
        break;
      case '*':
        answer = a * b;
        break;
      default:
        answer = a / b;
    }

    setState(() {
      errorText = null;
      result = format(answer);
    });
  }

  void clear() {
    num1Controller.clear();
    num2Controller.clear();
    setState(() {
      errorText = null;
      result = '0';
    });
  }

  @override
  void dispose() {
    num1Controller.dispose();
    num2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const numberKeyboard = TextInputType.numberWithOptions(
      decimal: true,
      signed: true,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          AppTextField(
            controller: num1Controller,
            label: 'First number',
            keyboardType: numberKeyboard,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: num2Controller,
            label: 'Second number',
            keyboardType: numberKeyboard,
          ),
          if (errorText != null) ...[
            const SizedBox(height: 12),
            Text(
              errorText!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OperatorButton(
                  label: '+',
                  onPressed: () => calculate('+'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OperatorButton(
                  label: '−',
                  onPressed: () => calculate('-'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OperatorButton(
                  label: '×',
                  onPressed: () => calculate('*'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OperatorButton(
                  label: '÷',
                  onPressed: () => calculate('/'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: clear, child: const Text('Clear')),
          const SizedBox(height: 32),
          ResultCard(result: result),
        ],
      ),
    );
  }
}
