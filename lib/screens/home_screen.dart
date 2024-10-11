import 'package:account/provider/transaction_provider.dart';
import 'package:account/screens/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Robox"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              SystemNavigator.pop(); // ปิดแอป
            },
          ),
        ],
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/Roboxx.png'),
          radius: 30,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          // เช็คว่ามีรายการอยู่หรือไม่
          if (provider.transactions.isEmpty) {
            return const Center(
              child: Text('ไม่มีรายการ'),
            );
          } else {
            return ListView.builder(
              itemCount: provider.transactions.length,
              itemBuilder: (context, index) {
                final statement = provider.transactions[index];
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(statement.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('dd MMM yyyy hh:mm')
                            .format(statement.date)),
                        Text(
                          'หมวดหมู่: ${statement.category}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    leading: CircleAvatar(
                      backgroundImage: gameImage(statement.name),
                      radius: 30,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // แสดงการยืนยันการลบ
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('ยืนยันการลบ'),
                              content: const Text(
                                  'คุณแน่ใจหรือว่าต้องการลบรายการนี้?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // ปิด dialog
                                  },
                                  child: const Text('ยกเลิก'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    provider.deleteTransaction(statement.keyID);
                                    Navigator.of(context).pop(); // ปิด dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('ลบรายการเรียบร้อยแล้ว')),
                                    );
                                  },
                                  child: const Text('ลบ'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    onTap: () {
                      // เปิดหน้าจอสำหรับแก้ไขรายการ
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EditScreen(statement: statement);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

AssetImage gameImage(String name) {
  switch (name) {
    case 'Frigid Dusk':
      return const AssetImage('assets/images/Frigid Dusk.png');
    case 'midnight zoo':
      return const AssetImage('assets/images/midnightzoo.png');
    case 'Elmira':
      return const AssetImage('assets/images/Elmira.png');
    default:
      return const AssetImage('assets/images/default.png');
  }
}
