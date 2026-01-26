import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofencing/features/chat/domain/usecases/chat_usecase.dart';
import '../../domain/entities/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;

  ChatBloc(this.sendMessageUseCase) : super(const ChatState()) {
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    // Make a mutable copy of current messages
    final updatedMessages = List<ChatMessage>.from(state.messages);

    // 1️⃣ Add user message instantly
    final userMessage = ChatMessage(text: event.message, isUser: true);

    updatedMessages.add(userMessage);

    emit(state.copyWith(messages: updatedMessages, isLoading: true));

    try {
      // 2️⃣ Get AI response
      final aiMessage = await sendMessageUseCase(event.message);

      // 3️⃣ Add AI message to SAME list
      updatedMessages.add(aiMessage);

      emit(state.copyWith(messages: updatedMessages, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
