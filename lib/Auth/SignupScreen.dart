import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Auth/loginScreen.dart';
import 'package:login_app/Auth/roleSelectionScreen.dart';
import 'package:login_app/Utils/utils.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool passenable = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  // void signup() async {
  //   try {
  //     // Create the user with email and password
  //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );
  //
  //     // Save the user's name in Firestore
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userCredential.user!.uid)
  //         .set({
  //       'name': nameController.text.trim(),  // Save the user's name
  //     },  SetOptions(merge: true));
  //
  //     // Navigate to RoleSelectionScreen, passing the created user
  //     // Navigator.pushReplacement(
  //     //   context,
  //     //   MaterialPageRoute(
  //     //     builder: (context) => RoleSelectionScreen(userCredential.user),
  //     //   ),
  //     // );
  //
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => RoleSelectionScreen(
  //           user: userCredential.user,
  //           name: nameController.text.trim(),
  //         ),
  //       ),
  //     );
  //
  //   } catch (error) {
  //     // Show error message in case of an exception
  //     Utils().toastMessage(error.toString());
  //   }
  // }

  void signup() async {
    try {
      print("Name entered: ${nameController.text.trim()}"); // Debugging
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': nameController.text.trim(),
      }, SetOptions(merge: true));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RoleSelectionScreen(
            user: userCredential.user,
            name: nameController.text.trim(),
          ),
        ),
      );
    } catch (error) {
      Utils().toastMessage(error.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1B1919),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(height: 60),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: GradientText(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                        colors: [
                          Color(0xFF133D3E),
                          Color(0xFF1C5153),
                          Color(0xFF133D3E),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 65,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                            hoverColor: Colors.white,
                            focusColor: Colors.white,
                            labelText: "Email",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                          ),
                          controller: emailController,
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 65,
                        child: TextFormField(
                          obscureText: passenable,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                            hoverColor: Colors.white,
                            focusColor: Colors.white,
                            labelText: "Password",
                            prefixIcon: const Icon(
                              Icons.password_rounded,
                              color: Colors.grey,
                            ),
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  passenable = !passenable;
                                });
                              },
                              icon: Icon(passenable
                                  ? Icons.remove_red_eye
                                  : Icons.remove_red_eye_outlined),
                            ),
                          ),
                          controller: passwordController,
                          style: const TextStyle(color: Color(0xff185A80)),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please, enter your password';
                            }
                            return null;
                          },
                        ),
                      ),

                      //Name
                      const SizedBox(height: 20,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 65,
                        child: TextFormField(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                            hoverColor: Colors.white,
                            focusColor: Colors.white,
                            labelText: "Name",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                          ),
                          controller: nameController,
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),
                      //Name end


                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if(_formkey.currentState!.validate()){
                                signup();
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color(0xFF133D3E),
                                    Color(0xFF1C5153),
                                    Color(0xFF1C5153),
                                    Color(0xFF133D3E),
                                    // Color(0xff8A5403),
                                    // Color(0xffFDC703),
                                    // Color(0xffFDC703),
                                    // Color(0xff8A5403),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "GET STARTED",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(
                  height: 180,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account",style: GoogleFonts.poppins(fontSize: 16,color: Colors.white),),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    }, child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold),))
                  ],
                )
              ],
            ),
          ),


        ),
      ),
    );
  }
}
