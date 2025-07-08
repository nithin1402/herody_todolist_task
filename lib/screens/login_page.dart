import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth_provider.dart';
import 'home_page.dart';
import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  @override
  void initState() {
    super.initState();
    getValue();
  }

  void getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic login=prefs.getStringList("LOGIN");
    if(login!=null){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xff023333),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60))),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("Back!", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 11),
                    Text("Continue your adventure.", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
            Container(
              height: 500,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    SizedBox(height: 21),
                    TextField(
                      controller: passController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.visibility, color: Color(0xff023333)),
                        hintText: "Password",
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () async {
                          String email = emailController.text.trim();
                          String pass = passController.text.trim();

                          try {
                            await Provider.of<AUTHProvider>(context, listen: false)
                                .login(email, pass);

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setStringList("LOGIN", [email,pass]);

                            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                          } on FirebaseAuthException catch (e) {
                            String message = e.code == 'user-not-found'
                                ? 'No user found for that email.'
                                : e.code == 'wrong-password'
                                ? 'Wrong password provided.'
                                : 'Login failed: ${e.message}';

                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(message)));
                          }
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString("UID", FirebaseAuth.instance.currentUser!.uid);
                        },
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xff023333),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text("Log In", style: TextStyle(color: Colors.white, fontSize: 18)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 21),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an Account? "),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                          },
                          child: Text(
                            " Sign Up",
                            style: TextStyle(color: Color(0xff023333), fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
