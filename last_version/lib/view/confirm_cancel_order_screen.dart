import 'package:flutter/material.dart';

class ConfirmCancelOrderScreen extends StatelessWidget {
  final String customerName;
  final String storeName;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  const ConfirmCancelOrderScreen({
    Key? key,
    required this.customerName,
    required this.storeName,
    required this.onConfirm,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تأكيد إلغاء الطلب'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('اسم العميل: $customerName',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Text('اسم المتجر: $storeName',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onConfirm,
              child: const Text('تأكيد الإلغاء'),
            ),
          ],
        ),
      ),
    );
  }
}
