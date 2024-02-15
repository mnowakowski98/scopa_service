import 'dart:convert';

import 'package:scopa_service/session.dart';
import 'package:scopa_service/session_manager.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

void main() {
  group('Session manager', () {
    test('sends a session id on session create', () {
      final manager = SessionManager();
      final controller = StreamChannelController<String>();

      manager.addChannel(controller.foreign);

      final command = SessionCreate(playerName: 'Test').toJson();
      command['command'] = 'create';
      controller.local.sink.add(jsonEncode(command));

      controller.local.stream.listen((data) {
        final message = SessionCreateResponse.fromJson(jsonDecode(data));
        expect(message.sessionId, isNotNull);
      });
    });

    test('sends a lobbystate on session join', () async {
      final manager = SessionManager();
      final createController = StreamChannelController<String>();
      final joinController = StreamChannelController<String>();

      manager.addChannel(createController.foreign);
      manager.addChannel(joinController.foreign);

      final createCommand = SessionCreate(playerName: 'Test Create').toJson();
      createCommand['command'] = 'create';
      createController.local.sink.add(jsonEncode(createCommand));

      createController.local.stream.listen((data) {
        final message = SessionCreateResponse.fromJson(jsonDecode(data));
        final joinCommand =
            SessionJoin(sessionId: message.sessionId, playerName: 'Test Join')
                .toJson();
        joinCommand['command'] = 'join';
        joinController.local.sink.add(jsonEncode(joinCommand));
        joinController.local.stream.listen((joinData) {
          final joinMessage =
              SessionJoinResponse.fromJson(jsonDecode(joinData));
          expect(
              joinMessage.players, containsAll(['Test Join', 'Test Create']));
        });
      });
    });
  });
}
