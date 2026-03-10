import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_for_genfura/Utils/AppConstant.dart';



import 'Utils/CustomNavigation.dart';
import 'common_module/Login.dart';
import 'common_module/LoginViewModel.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}
void main() async{

  // 1. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // 2. Initialize Firebase
  await Firebase.initializeApp();
  runApp(const VisitorApp());
}

class VisitorApp extends StatelessWidget {
  const VisitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getAllProviders(),
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        title: 'Visitor App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        // This points to the page you are moving your logic to
        home:Login(),
      ),
    );
  }
}
  getAllProviders() {

      return [
      ChangeNotifierProvider(create: (_) => LoginViewModel()),
];

}

