// import 'package:flutter/material.dart';
// import 'package:pos_app/data/network/network_service.dart';

// class NetworkStatusWidget extends StatelessWidget {
//   const NetworkStatusWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<bool>(
//       stream: NetworkService().connectionStatus,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final isConnected = snapshot.data!;
//           return AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             height: isConnected ? 0 : 40,
//             color: isConnected ? Colors.green : Colors.red,
//             child: Center(
//               child: Text(
//                 isConnected ? '' : 'No Internet Connection',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           );
//         }
//         return const SizedBox.shrink();
//       },
//     );
//   }
// }
