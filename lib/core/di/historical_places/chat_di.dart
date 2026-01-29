/// CHAT FEATURE

import 'package:geofencing/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:geofencing/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:geofencing/features/chat/domain/repositories/chat_repository.dart';
import 'package:geofencing/features/chat/domain/usecases/chat_usecase.dart';
import 'package:geofencing/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:get_it/get_it.dart';

class ChatDi {
  static void init(GetIt sl) {
     // Data Sources
    sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(),
    );

    sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));

    sl.registerLazySingleton(() => SendMessageUseCase(sl()));

    sl.registerFactory(() => ChatBloc(sl()));

  }
}



