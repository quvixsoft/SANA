import 'package:flutter/material.dart';
import 'package:sana/models/models.dart';

class Chat extends StatefulWidget {
  static const String routePath = '/chat';
  static const String routeName = 'chat';

  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> messages = [
    ChatMessage(
      id: "1",
      role: "model",
      text:
          "Hola. Soy Sana, tu asistente clínico. Para comenzar, ¿podrías describir brevemente qué síntoma principal te molesta hoy?",
      timestamp: DateTime.now().toString(),
    ),
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(
          id: DateTime.now().toString(),
          role: "user",
          text: text,
          timestamp: DateTime.now().toString(),
        ),
      );
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      // Prepare history for API
      final history = messages.map((m) {
        return 'AQUI VA ALGO';
      }).toList();

      // final responseText = await _geminiService.generateChatResponse(history);
      final responseText = 'responseText';
      setState(() {
        messages.add(
          ChatMessage(
            id: DateTime.now().toString(),
            role: "model",
            text: responseText,
            timestamp: DateTime.now().toString(),
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
        messages.add(
          ChatMessage(
            id: DateTime.now().toString(),
            role: "model",
            text:
                "Lo siento, hubo un error al procesar tu consulta. Por favor intenta de nuevo.",
            timestamp: DateTime.now().toString(),
          ),
        );
      });
      print('Chat Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Messages
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == messages.length) {
                return const Padding(
                  padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              final msg = messages[index];
              final isUser = msg.role == 'user';

              return Align(
                alignment: isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFF1E82D9) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 0),
                      bottomRight: Radius.circular(isUser ? 0 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : const Color(0xFF122640),
                      height: 1.4,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Show "Generate Report" option after 5 messages
        if (messages.length >= 5)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.blue[50],
            child: Row(
              children: [
                const Icon(Icons.analytics, color: Color(0xFF1E82D9)),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Sana tiene suficientes datos para un reporte preliminar.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF122640),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => null,
                  child: const Text(
                    "VER REPORTE",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),

        // Input
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _handleSend(),
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu síntoma o respuesta...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _handleSend,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E82D9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
