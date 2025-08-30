import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/services/chatbot_service.dart';


class ChatMessage {
  final String role; 
  final String text;
  ChatMessage(this.role, this.text);
}

abstract class ChatEvent extends Equatable { const ChatEvent(); }
class ChatSubmitted extends ChatEvent {
  final String question;
  const ChatSubmitted(this.question);
  @override List<Object?> get props => [question];
}
class ChatReset extends ChatEvent { @override List<Object?> get props => []; }

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool loading;
  final String? error;
  const ChatState({this.messages = const [], this.loading = false, this.error});

  ChatState copyWith({List<ChatMessage>? messages, bool? loading, String? error}) =>
      ChatState(messages: messages ?? this.messages, loading: loading ?? this.loading, error: error);
  @override List<Object?> get props => [messages, loading, error ?? ''];
}

class ChatbotBloc extends Bloc<ChatEvent, ChatState> {
  final ChatbotService service;
  ChatbotBloc(this.service) : super(const ChatState()) {
    on<ChatReset>((_, emit) => emit(const ChatState()));
    on<ChatSubmitted>(_onSubmit);
  }

  Future<void> _onSubmit(ChatSubmitted e, Emitter<ChatState> emit) async {
    final q = e.question.trim();
    if (q.isEmpty || state.loading) return;

    final msgs = [...state.messages, ChatMessage('user', q)];
    emit(state.copyWith(messages: msgs, loading: true, error: null));

    try {
      final ans = await service.ask(q);
      final next = [...msgs, ChatMessage('assistant', ans)];
      emit(state.copyWith(messages: next, loading: false));
    } catch (err) {
      emit(state.copyWith(loading: false, error: 'Lỗi: $err'));
    }
  }
}
