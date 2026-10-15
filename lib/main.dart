import 'package:flutter/material.dart';

void main() {
  runApp(const CurrencyCalcApp());
}

class CurrencyCalcApp extends StatelessWidget {
  const CurrencyCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Divisas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const CurrencyConverterScreen(),
    );
  }
}

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  double _inputAmount = 0.0;
  String _fromCurrency = 'MXN';
  String _toCurrency = 'USD';
  double _convertedResult = 0.0;

  // Tasas de cambio base de referencia
  final Map<String, double> _ratesToUSD = {
    'USD': 1.0,
    'MXN': 0.051,
    'EUR': 1.08,
    'GBP': 1.28,
  };

  void _calculateConversion() {
    setState(() {
      double amountInUSD = _inputAmount * (_ratesToUSD[_fromCurrency] ?? 1.0);
      _convertedResult = amountInUSD / (_ratesToUSD[_toCurrency] ?? 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CurrencyCalc Mobile 🪪'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Monto a Convertir',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      onChanged: (value) {
                        _inputAmount = double.tryParse(value) ?? 0.0;
                        _calculateConversion();
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDropdown(_fromCurrency, (val) {
                          setState(() {
                            _fromCurrency = val!;
                            _calculateConversion();
                          });
                        }),
                        const Icon(Icons.swap_horiz, size: 32, color: Colors.teal),
                        _buildDropdown(_toCurrency, (val) {
                          setState(() {
                            _toCurrency = val!;
                            _calculateConversion();
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text('Resultado Calculado:', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(
                    '${_convertedResult.toStringAsFixed(2)} $_toCurrency',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String currentValue, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: currentValue,
      items: _ratesToUSD.keys.map((String currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(currency, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}