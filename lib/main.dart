import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Üçgen Alan Hesaplama',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UcgenHesaplama(),
    );
  }
}

class UcgenHesaplama extends StatefulWidget {
  const UcgenHesaplama({Key? key}) : super(key: key);

  @override
  _UcgenHesaplamaState createState() => _UcgenHesaplamaState();
}

class _UcgenHesaplamaState extends State<UcgenHesaplama> {
  final _formKey = GlobalKey<FormState>();
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  double _sonuc = 0;

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  double _hesaplaAlan() {
    double a = double.parse(_controller1.text);
    double b = double.parse(_controller2.text);
    double c = double.parse(_controller3.text);
    
    double s = (a + b + c) / 2;
    return double.parse(
      (sqrt(s * (s - a) * (s - b) * (s - c))).toStringAsFixed(2)
    );
  }

  void _hesapla() {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      final alan = _hesaplaAlan();
      setState(() {
        _sonuc = alan;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hesaplama sırasında bir hata oluştu'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Üçgen Alan Hesaplama'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _controller1,
                decoration: const InputDecoration(labelText: '1. Kenar'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alan boş bırakılamaz';
                  }
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Geçerli bir pozitif sayı giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controller2,
                decoration: const InputDecoration(labelText: '2. Kenar'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alan boş bırakılamaz';
                  }
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Geçerli bir pozitif sayı giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controller3,
                decoration: const InputDecoration(labelText: '3. Kenar'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bu alan boş bırakılamaz';
                  }
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Geçerli bir pozitif sayı giriniz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _hesapla,
                child: const Text('Hesapla'),
                semanticsLabel: 'Üçgen alanını hesapla',
              ),
              const SizedBox(height: 20),
              Text(
                'Sonuç: $_sonuc',
                semanticsLabel: 'Hesaplanan alan: $_sonuc metrekare',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}