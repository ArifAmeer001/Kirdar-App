import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Auth/SignupScreen.dart';
import 'package:login_app/Utils/utils.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:login_app/Screens/forgetPasswordScreen.dart';
import 'package:login_app/Screens/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passenable = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  void login(){
    _auth.signInWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()
    ).then((value){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen()));
    })
    .onError((error, stackTrace){
      Utils().toastMessage(error.toString());
    });
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
                //Image(image: AssetImage("assets/pngegg (1) 1.png")),
                SizedBox(height: 60),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: GradientText(
                        'LOGIN',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgetPasswordScreen()));
                            },
                            child: Text(
                              'Forgot Password ?',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if(_formkey.currentState!.validate()){
                                login();
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
                    Text("don't have an account ?",style: GoogleFonts.poppins(fontSize: 16,color: Colors.white),),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                    }, child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold),))
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













// import 'package:flutter/material.dart';
// import 'package:login_app/Widgets/roundButtons.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//
//   final emailControler = TextEditingController();
//   final passwordControler = TextEditingController();
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     emailControler.dispose();
//     passwordControler.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Center( child : Text('tile for login')),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller: emailControler,
//               decoration: InputDecoration(
//                 hintText: 'Email',
//                 helperText: 'abc@gmail.com'
//               ),
//             ),
//             RoundButton(title: 'Log In',
//                 onTap: (){}
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
