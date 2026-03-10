import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'LoginViewModel.dart';


//import 'home_page.dart'; // Create this for your main security dashboard

class Login extends StatefulWidget {
  @override
  State<Login> createState() => CommonLogin();
}

class  CommonLogin extends State<Login> {
  late LoginViewModel loginFuctions;
  bool _isObscured = true;


  @override
  void initState(){
    loginFuctions = Provider.of<LoginViewModel>(context,listen:false);
super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loginFuctions = context.watch<LoginViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      // loginFuctions._isLoading
      //     ? Center(child: CircularProgressIndicator())
      //     :
      Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, size: 80, color: Colors.blueAccent),
            SizedBox(height: 20),
            Text("Login Portal", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 40),
            TextField(
              controller: loginFuctions.emailController,
              decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              controller: loginFuctions.passwordController,
              obscureText: _isObscured?true:false,
              decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder(),suffixIcon:
              IconButton(icon:Icon(_isObscured ?Icons.visibility_off:Icons.visibility), onPressed: () {
                setState(() {
                  _isObscured = !_isObscured; // Toggle the state
                });
              },),
              ),

            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: loginFuctions.login,
              child: Text("Login"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}