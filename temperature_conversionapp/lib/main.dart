import 'package:flutter/material.dart';

void main() {
  runApp(TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Temperature Converter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TemperatureConverter(),
    );
  }
}

class TemperatureConverter extends StatefulWidget {
  const TemperatureConverter({super.key});

  @override
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  final TextEditingController _controller = TextEditingController();
  String _conversionType = 'F to C';
  String _result = '';
  final List<String> _history = [];

  void _convert() {
    final input = double.tryParse(_controller.text);
    if (input == null) {
      setState(() {
        _result = 'Invalid input';
      });
      return;
    }

    double output;
    String historyEntry;

    if (_conversionType == 'F to C') {
      output = (input - 32) * 5 / 9;
      historyEntry = 'F to C: ${input.toStringAsFixed(1)} => ${output.toStringAsFixed(2)}';
    } else {
      output = (input * 9 / 5) + 32;
      historyEntry = 'C to F: ${input.toStringAsFixed(1)} => ${output.toStringAsFixed(2)}';
    }

    setState(() {
      _result = output.toStringAsFixed(2);
      _history.insert(0, historyEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Temperature Converter')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Enter temperature',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('F to C'),
                    value: 'F to C',
                    groupValue: _conversionType,
                    onChanged: (value) => setState(() => _conversionType = value!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('C to F'),
                    value: 'C to F',
                    groupValue: _conversionType,
                    onChanged: (value) => converte(() => _conversionType = value!),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Convert'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Result: $_result',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Divider(height: 32.0),
            Text('History:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _history.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_history[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
