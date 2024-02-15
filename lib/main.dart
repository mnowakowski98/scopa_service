import 'package:scopa_service/session_manager.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final connections = <WebSocketChannel>[];

void main() {
  final manager = SessionManager();

  final handler = webSocketHandler((webSocket) {
    final channel = webSocket as WebSocketChannel;
    manager.addChannel(channel);
  });

  shelf_io.serve(handler, 'localhost', 3000);
}
