import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/chatbot/chatbot_bloc.dart';

import 'package:travelogue_mobile/core/repository/home_repository.dart';
import 'package:travelogue_mobile/core/services/chatbot_service.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
    static const routeName = '/chatbot';

  @override
  Widget build(BuildContext context) {

    const openAiKey = '';

    return RepositoryProvider(
      create: (_) => HomeRepository(),
      child: BlocProvider(
        create: (ctx) => ChatbotBloc(
          ChatbotService(
            homeRepository: ctx.read<HomeRepository>(),
            openAiApiKey: openAiKey,
          ),
        ),
        child: const _ChatView(),
      ),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();
  @override State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  void _send() {
    final q = _controller.text.trim();
    if (q.isEmpty) return;
    context.read<ChatbotBloc>().add(ChatSubmitted(q));
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travelogue Chatbot')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatbotBloc, ChatState>(
                builder: (ctx, state) {
                  return ListView.separated(
                    controller: _scroll,
                    padding: const EdgeInsets.all(12),
                    itemCount: state.messages.length + (state.loading ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      if (i == state.messages.length && state.loading) {
                        return const Align(
                          alignment: Alignment.centerLeft,
                          child: _TypingBubble(),
                        );
                      }
                      final m = state.messages[i];
                      final isUser = m.role == 'user';
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          constraints: const BoxConstraints(maxWidth: 520),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Colors.blueAccent.withOpacity(.12)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(m.text),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Hỏi về địa điểm Tây Ninh...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _send,
                    icon: const Icon(Icons.send),
                    label: const Text('Gửi'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();
  @override State<_TypingBubble> createState() => _TypingBubbleState();
}
class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))
        ..repeat();
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return FadeTransition(
          opacity: Tween(begin: .2, end: 1.0)
              .chain(CurveTween(curve: Interval(i * .2, 1)))
              .animate(_c),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.5),
            child: CircleAvatar(radius: 4, backgroundColor: Colors.grey),
          ),
        );
      }),
    );
  }
}
