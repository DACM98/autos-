import 'package:flutter/material.dart';

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  // Variables para el cálculo
  String _output = "0";
  String _currentNumber = "";
  double _num1 = 0.0;
  double _num2 = 0.0;
  String _operand = "";

  // Maneja la lógica de los botones de la calculadora
  void _buttonPressed(String buttonText) {
    if (buttonText == "CLEAR") {
      setState(() {
        _output = "0";
        _currentNumber = "";
        _num1 = 0.0;
        _num2 = 0.0;
        _operand = "";
      });
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "*" || buttonText == "/") {
      setState(() {
        _num1 = double.parse(_output);
        _operand = buttonText;
        _currentNumber = "";
      });
    } else if (buttonText == ".") {
      if (!_currentNumber.contains(".")) {
        setState(() {
          _currentNumber += buttonText;
          _output = _currentNumber;
        });
      }
    } else if (buttonText == "=") {
      setState(() {
        _num2 = double.parse(_currentNumber);
        switch (_operand) {
          case "+":
            _output = (_num1 + _num2).toString();
            break;
          case "-":
            _output = (_num1 - _num2).toString();
            break;
          case "*":
            _output = (_num1 * _num2).toString();
            break;
          case "/":
            _output = (_num1 / _num2).toString();
            break;
        }
        _num1 = 0.0;
        _operand = "";
        _currentNumber = _output;
      });
    } else {
      setState(() {
        _currentNumber += buttonText;
        _output = _currentNumber;
      });
    }
  }

  // Construye un botón de la calculadora
  Widget _buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[100],
            padding: const EdgeInsets.all(20.0),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 12, 165, 45),
        title: const Text('Calculadora'),
      ),
      body: Column(
        children: <Widget>[
          // Muestra el resultado
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 12.0,
            ),
            child: Text(
              _output,
              style: const TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          // Botones de la calculadora
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _buildButton("7"),
                    _buildButton("8"),
                    _buildButton("9"),
                    _buildButton("/"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("4"),
                    _buildButton("5"),
                    _buildButton("6"),
                    _buildButton("*"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("1"),
                    _buildButton("2"),
                    _buildButton("3"),
                    _buildButton("-"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("."),
                    _buildButton("0"),
                    _buildButton("CLEAR"),
                    _buildButton("+"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _buildButton("="),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
} 