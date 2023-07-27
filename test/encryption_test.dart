// import 'package:firedart/firestore/firestore.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// //
// // // Import the functions you need from the SDKs you need
// // import { initializeApp } from "firebase/app";
// // // TODO: Add SDKs for Firebase products that you want to use
// // // https://firebase.google.com/docs/web/setup#available-libraries
// //
// // // Your web app's Firebase configuration
// // const firebaseConfig = {
// //   apiKey: "AIzaSyAq81aGX6F7g28cvNIhOZ33DEZYZ8R1lIA",
// //   authDomain: "test-8aebc.firebaseapp.com",
// //   projectId: "test-8aebc",
// //   storageBucket: "test-8aebc.appspot.com",
// //   messagingSenderId: "278691877745",
// //   appId: "1:278691877745:web:bac1b3c267793895599cd0"
// // };
// //
// // // Initialize Firebase
// // const app = initializeApp(firebaseConfig);
//
// Future<void> main() async {
//   test('stream cache test', () async {
//     const projId = 'test-8aebc';
//     final firestore = Firestore.initialize(projId);
//     var listenerList = <Map<String, dynamic>>[];
//     final testCollection = firestore.collection('test');
//
//     // setup listener
//     testCollection.stream.listen((event) {
//       listenerList = event.map((e) => e.map).toList();
//       print('from listener');
//       print(listenerList.length);
//       print(listenerList);
//     });
//
//     // add data
//     await testCollection.document('1').create({'test1': 'test'});
//     await testCollection.document('2').create({'test2': 'test'});
//     await testCollection.document('3').create({'test3': 'test'});
//
//     print('waiting for propogation');
//     await Future.delayed(const Duration(seconds: 5));
//
//     // should print 3
//
//     // final actualData = await testCollection.get();
//     // print('Actual database state');
//     // print(actualData.length);
//
//     // delete data
//     await testCollection.document('2').delete();
//
//     print('waiting for propogation');
//     // should print 2
//     await Future.delayed(const Duration(seconds: 5));
//
//     await testCollection.document('1').delete();
//     await testCollection.document('2').delete();
//     await testCollection.document('3').delete();
//   });
// }
