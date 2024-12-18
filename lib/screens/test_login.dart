// import 'package:flutter/material.dart';
// import 'package:ecoscan/screens/homepage_screen.dart';
// import 'package:ecoscan/screens/register_screen.dart';
// import 'package:ecoscan/backend-client/login_authentication.dart';
// import 'package:ecoscan/backend-client/get_local_user.dart';

// class TestLoginScreen extends StatefulWidget {
//   @override
//   TestLoginScreenState createState() => TestLoginScreenState();
// }

// class TestLoginScreenState extends State<TestLoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String _email = '';
//   String _password = '';

//   @override
//   void initState() {
//     super.initState();
//     checkLocalUser();
//   }

//   Future<void> checkLocalUser() async {
//     final user = await getLocalUser();
//     if (user.email.isNotEmpty && mounted) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => HomePageScreen()),
//       );
//     }
//   }

//   void _submit() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       // Show loading
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return Center(child: CircularProgressIndicator());
//         },
//       );

//       try {
//         final loginResponse = await loginUser(_email, _password);
//         Navigator.of(context).pop();

//         if (loginResponse.success) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => HomePageScreen()),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(loginResponse.error ?? 'Login failed.')),
//           );
//         }
//       } catch (e) {
//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text('Network error. Please check your connection.')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/background.jpg',
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Login Form
//           Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Logo
//                   Image.asset(
//                     'assets/images/logo.png',
//                     height: 100,
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Selamat Datang di Ecoscan',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 32),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 24),
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.95),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           // Email Field
//                           TextFormField(
//                             decoration: InputDecoration(
//                               labelText: 'Email',
//                               prefixIcon:
//                                   Icon(Icons.email, color: Colors.green),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             keyboardType: TextInputType.emailAddress,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Masukkan email Anda';
//                               }
//                               if (!value.contains('@')) {
//                                 return 'Masukkan email yang valid';
//                               }
//                               return null;
//                             },
//                             onSaved: (value) => _email = value!,
//                           ),
//                           SizedBox(height: 16),
//                           // Password Field
//                           TextFormField(
//                             decoration: InputDecoration(
//                               labelText: 'Password',
//                               prefixIcon: Icon(Icons.lock, color: Colors.green),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             obscureText: true,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Masukkan password Anda';
//                               }
//                               return null;
//                             },
//                             onSaved: (value) => _password = value!,
//                           ),
//                           SizedBox(height: 24),
//                           // Login Button
//                           ElevatedButton(
//                             onPressed: _submit,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green[700],
//                               minimumSize: Size(double.infinity, 50),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: Text(
//                               'Login',
//                               style:
//                                   TextStyle(fontSize: 18, color: Colors.white),
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text('Belum punya akun? '),
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => RegisterScreen()),
//                                   );
//                                 },
//                                 child: Text(
//                                   'Daftar Sekarang',
//                                   style: TextStyle(
//                                     color: Colors.green[700],
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
