import 'package:account/models/transactions.dart';
import 'package:account/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  final Transactions statement;

  const EditScreen({super.key, required this.statement});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ratingController = TextEditingController();
  final ageController = TextEditingController();
  final developerController = TextEditingController();
  final imageUrlController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set the initial values from the statement
    nameController.text = widget.statement.name;
    ratingController.text = widget.statement.rating;
    ageController.text = widget.statement.age;
    developerController.text = widget.statement.developer;
    imageUrlController.text = widget.statement.imageUrl;
    categoryController.text = widget.statement.category; // Set initial category
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูล'),
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
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'หมวดหมู่',
                  ),
                  value: categoryController.text.isNotEmpty
                      ? categoryController.text
                      : null, // set the initial value if exists
                  onChanged: (String? newValue) {
                    setState(() {
                      categoryController.text = newValue!;
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
                  child: const Text('แก้ไขข้อมูล'),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      // สร้างข้อมูลที่ได้รับการแก้ไขแล้ว
                      var statement = Transactions(
                        keyID: widget.statement.keyID,
                        name: nameController.text,
                        category: categoryController.text,
                        rating: ratingController.text,
                        age: ageController.text,
                        developer: developerController.text,
                        imageUrl: imageUrlController.text,
                        date: DateTime.now(),
                      );

                      // อัปเดตข้อมูลใน provider
                      var provider = Provider.of<TransactionProvider>(context,
                          listen: false);
                      provider.updateTransaction(statement);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('ข้อมูลได้ถูกแก้ไขเรียบร้อยแล้ว')),
                      );

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
