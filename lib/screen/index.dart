import 'package:dorm_app/screen/login.dart';
import 'package:dorm_app/screen/register.dart';
import 'package:dorm_app/screen/role.dart';
import 'package:flutter/material.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AccommoEase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }));
                  }, 
                  icon: Icon(Icons.login),
                  label: Text('เช้าสู่ระบบ',style: TextStyle(fontSize: 20)
                  ,),),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return role_sceen();
                    }));
                  }, 
                  icon: Icon(Icons.login),
                  label: Text('สร้างบัญชี',style: TextStyle(fontSize: 20)
                  ,),),
              )
            ],
          ),
        ),),
    );
  }
}