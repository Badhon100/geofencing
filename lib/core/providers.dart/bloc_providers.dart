import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofencing/features/historical_places/presentation/bloc/historical_places_bloc.dart';
import 'package:geofencing/features/home/cubit/home_cubit.dart';
import 'package:geofencing/features/settings/cubit/settings_cubit.dart';
import 'package:get_it/get_it.dart';

class BlocProviders {
  static final sl = GetIt.instance;

  static final providers = <BlocProvider>[
    BlocProvider<HomeCubit>(create: (context) => sl<HomeCubit>()),
    BlocProvider<SettingsCubit>(create: (context) => sl<SettingsCubit>()),
    BlocProvider<HistoricalPlacesBloc>(create: (context) => sl<HistoricalPlacesBloc>()),
  ];
}
