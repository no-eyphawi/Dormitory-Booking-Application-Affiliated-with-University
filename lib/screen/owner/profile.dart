import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Profileowner(),
    );
  }
}
class Profileowner extends StatelessWidget {
  const Profileowner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  
                  backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzmmPFs5rDiVo_R3ivU_J_-CaQGyvJj-ADNQ&s'),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('สวัสดีค่ะ คุณ ....',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('หอพักบ้านแสนสุข'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/images/บ้านแสนสุข/master (1).jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Column(
              children: [
                MenuItem(
                  icon: Icons.info_outline,
                  text: 'รายละเอียดหอพัก',
                ),
                MenuItem(
                  icon: Icons.account_box_outlined,
                  text: 'รายชื่อผู้เช่า',
                ),
                MenuItem(
                  icon: Icons.settings,
                  text: 'การตั้งค่า',
                ),
                MenuItem(
                  
                  icon: Icons.notifications_none,
                  text: 'แจ้งเตือน',
                  
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const MenuItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}