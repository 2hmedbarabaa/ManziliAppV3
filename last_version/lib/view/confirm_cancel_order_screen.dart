import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:manziliapp/widget/card/payment_receipt_widget.dart';

class ConfirmCancelOrderScreen extends StatefulWidget {
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
  State<ConfirmCancelOrderScreen> createState() => _ConfirmCancelOrderScreenState();
}

class _ConfirmCancelOrderScreenState extends State<ConfirmCancelOrderScreen> { 
   String? uploadedPdfPath;

   

  void _onPdfUploaded(String pdfPath) {
    setState(() => uploadedPdfPath = pdfPath);
    debugPrint('Uploaded PDF Path: $uploadedPdfPath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تأكيد إلغاء الطلب'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [


            Text('اسم العميل: ${widget.customerName}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Text('اسم المتجر: ${widget.storeName}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 32),
 PaymentReceipt(onPdfUploaded: _onPdfUploaded),

            ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('تأكيد الإلغاء'),
                    content: const Text('هل أنت متأكد أنك تريد إلغاء هذا الطلب؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('لا'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('نعم'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  // 1. Call the ReturnOrder API with PDF upload
                  if (uploadedPdfPath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('يرجى رفع إيصال الدفع أولاً')),
                    );
                    return;
                  }
                  final uri = Uri.parse('http://man.runasp.net/api/ReturnOrder/CreateReturnOrder?UserName=${Uri.encodeComponent(widget.customerName)}&StoreName=${Uri.encodeComponent(widget.storeName)}');
                  final request = http.MultipartRequest('POST', uri);
                  request.files.add(
                    await http.MultipartFile.fromPath(
                      'PdfFile',
                      uploadedPdfPath!,
                      contentType: MediaType('application', 'pdf'),
                    ),
                  );
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => const Center(child: CircularProgressIndicator()),
                  );
                  try {
                    final streamedResponse = await request.send();
                    final response = await http.Response.fromStream(streamedResponse);
                    Navigator.of(context).pop(); // remove loading dialog
                    if (response.statusCode == 200) {
                      final data = jsonDecode(response.body);
                      if (data['isSuccess'] == true) {
                        // 2. Only now call widget.onConfirm (cancel order)
                        widget.onConfirm();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(data['message'] ?? 'فشل في إرجاع الطلب')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('فشل في إرجاع الطلب: ${response.statusCode}')),
                      );
                    }
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('خطأ: $e')),
                    );
                  }
                }
              },
              child: const Text('تأكيد الإلغاء'),
            ),
          ],
        ),
      ),
    );
  }
}


