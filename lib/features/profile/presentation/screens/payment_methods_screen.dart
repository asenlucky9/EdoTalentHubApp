import 'package:flutter/material.dart';
import '../../../../config/app_config.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<String> _methods = ['Visa **** 1234', 'Mastercard **** 5678'];

  void _addMethod() {
    setState(() {
      _methods.add('New Card **** ${1000 + _methods.length}');
    });
  }

  void _removeMethod(int index) {
    setState(() {
      _methods.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _methods.length,
        itemBuilder: (context, i) => ListTile(
          leading: const Icon(Icons.credit_card),
          title: Text(_methods[i]),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeMethod(i),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMethod,
        backgroundColor: AppConfig.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
} 