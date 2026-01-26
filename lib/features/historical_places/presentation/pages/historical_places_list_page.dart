import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofencing/core/di/injection_container.dart';
import 'package:geofencing/features/historical_places/presentation/bloc/historical_places_bloc.dart';
import 'package:geofencing/features/historical_places/presentation/pages/historical_places_details_page.dart'
    show HistoricalPlacesDetailPage;
import 'package:geofencing/features/settings/cubit/settings_cubit.dart';

class HistoricalPlacesListPage extends StatelessWidget {
  const HistoricalPlacesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final allowCache = context.read<SettingsCubit>().state;

    return BlocProvider(
      create: (_) =>
          Dependency.sl<HistoricalPlacesBloc>()
            ..add(FetchHistoricalPlacesEvent(allowCache)),
      child: Scaffold(
        body: BlocBuilder<HistoricalPlacesBloc, HistoricalPlacesState>(
          builder: (context, state) {
            if (state is HistoricalPlacesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HistoricalPlacesLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HistoricalPlacesBloc>().add(
                    FetchHistoricalPlacesEvent(allowCache),
                  );
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.historicalPlaces.length,
                  itemBuilder: (context, index) {
                    final historicalPlaces = state.historicalPlaces[index];

                    return ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: historicalPlaces.imageUrl,
                        width: 100,
                        fit: BoxFit.cover,
                        placeholder: (c, _) => const SizedBox(
                          width: 100,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (c, _, __) =>
                            const Icon(Icons.broken_image),
                      ),
                      title: Text(
                        historicalPlaces.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        historicalPlaces.body,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HistoricalPlacesDetailPage(
                              historicalPlaces: historicalPlaces,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }

            if (state is HistoricalPlacesError) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HistoricalPlacesBloc>().add(
                    FetchHistoricalPlacesEvent(allowCache),
                  );
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(child: Text(state.message)),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
