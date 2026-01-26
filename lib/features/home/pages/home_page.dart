import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofencing/features/historical_places/presentation/pages/historical_places_list_page.dart';
import 'package:geofencing/features/home/cubit/home_cubit.dart';
import 'package:geofencing/features/settings/pages/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Historical Places",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          actions: [IconButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingsPage(),
              ),
            );
          }, icon: Icon(Icons.settings))],
        ),
        body: BlocBuilder<HomeCubit, bool>(
          builder: (context, isActive) {
            // return Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Icon(
            //         isActive ? Icons.location_on : Icons.location_off,
            //         size: 60,
            //       ),
            //       const SizedBox(height: 20),
            //       Text(
            //         isActive
            //             ? 'Monitoring is active in background'
            //             : 'Monitoring stopped',
            //         textAlign: TextAlign.center,
            //       ),
            //       const SizedBox(height: 30),
            //       if (isActive)
            //         ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.red,
            //           ),
            //           onPressed: () {
            //             context.read<HomeCubit>().stopMonitoring();
            //           },
            //           child: const Text('Close Monitoring'),
            //         ),
            //       if (!isActive)
            //         ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.green,
            //           ),
            //           onPressed: () {
            //             context.read<HomeCubit>().startMonitoring();
            //           },
            //           child: const Text('Start Monitoring'),
            //         ),
            //       ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.green,
            //         ),
            //         onPressed: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (_) => const HistoricalPlacesListPage(),
            //             ),
            //           );
            //         },
            //         child: const Text('Historical Places'),
            //       ),
            //     ],
            //   ),
            // );
            return HistoricalPlacesListPage();
          },
        ),
      ),
    );
  }
}
