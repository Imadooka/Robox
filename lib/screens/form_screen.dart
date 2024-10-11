import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/models/transactions.dart';
import 'package:account/provider/transaction_provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ratingController = TextEditingController();
  final ageController = TextEditingController();
  final developerController = TextEditingController();
  final imageUrlController = TextEditingController();
  String? selectedCategory; // ตัวแปรสำหรับเก็บหมวดหมู่ที่เลือก

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มข้อมูล'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ชื่อเกม',
                  ),
                  controller: nameController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อเกม';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'หมวดหมู่',
                  ),
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  items: <String>[
                    'Action',
                    'Adventure',
                    'Puzzle',
                    'Racing',
                    'Sports',
                    'Strategy'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกหมวดหมู่';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'แนวทางสำหรับอายุ',
                  ),
                  controller: ageController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกแนวทางสำหรับอายุ';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'นักพัฒนา',
                  ),
                  controller: developerController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกนักพัฒนา';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'เรตติ้ง',
                  ),
                  controller: ratingController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกเรตติ้ง';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: const Text('บันทึก'),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      var statement = Transactions(
                        keyID: null,
                        name: nameController.text,
                        category: selectedCategory ?? '',
                        rating: ratingController.text,
                        age: ageController.text,
                        developer: developerController.text,
                        imageUrl: imageUrlController.text,
                        date: DateTime.now(),
                      );

                      var provider = Provider.of<TransactionProvider>(context,
                          listen: false);
                      provider.addTransaction(statement);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('บันทึกข้อมูลเรียบร้อยแล้ว')),
                      );

                      // Clear the form fields
                      nameController.clear();
                      ratingController.clear();
                      ageController.clear();
                      developerController.clear();
                      imageUrlController.clear();
                      setState(() {
                        selectedCategory = null;
                      });

                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
