import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofencing/features/home/cubit/home_cubit.dart';
import 'package:geofencing/features/settings/cubit/settings_cubit.dart';
import 'package:geofencing/features/historical_places/presentation/bloc/historical_places_bloc.dart';
import '../../../../core/widgets/confirmation_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocBuilder<HomeCubit, bool>(
              builder: (context, isActive) {
                return Card(
                  child: SwitchListTile(
                    value: isActive,
                    activeColor: Colors.green,
                    title: const Text("Location Monitoring"),
                    subtitle: Text(
                      isActive
                          ? "Running in background"
                          : "Monitoring is turned off",
                    ),
                    onChanged: (value) async {
                      if (!value) {
                        final confirm = await showConfirmationDialog(
                          context,
                          title: "Stop Monitoring?",
                          message:
                              "Geofencing will stop working in the background.",
                          confirmText: "Stop",
                          cancelText: "Cancel",
                          isDestructive: true,
                        );

                        if (confirm == true) {
                          context.read<HomeCubit>().stopMonitoring();
                        }
                      } else {
                        context.read<HomeCubit>().startMonitoring();
                      }
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            BlocBuilder<SettingsCubit, bool>(
              builder: (context, allowCache) {
                return Card(
                  child: SwitchListTile(
                    value: allowCache,
                    activeColor: Colors.green,
                    title: const Text("Allow Offline Storage"),
                    subtitle: const Text("Save data for offline use"),
                    onChanged: (val) async {
                      if (val) {
                        final confirm = await showConfirmationDialog(
                          context,
                          title: "Store data offline?",
                          message:
                              "Data will be saved on this device for offline access.",
                          confirmText: "Confirm",
                          cancelText: "Cancel",
                        );

                        if (confirm == true) {
                          await context.read<SettingsCubit>().toggleCache(true);

                          // 🔥 Immediately refetch to populate cache
                          context.read<HistoricalPlacesBloc>().add(
                            const FetchHistoricalPlacesEvent(true),
                          );
                        }
                      } else {
                        await context.read<SettingsCubit>().toggleCache(false);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
