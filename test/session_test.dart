import 'dart:convert';

import 'package:scopa_service/session.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

void main() {
  test('broadcasts the player list on new player join', () {
    final session = Session('test');
    final firstController = StreamChannelController<String>();
    final secondController = StreamChannelController<String>();

    session.addPlayer(firstController.foreign, 'first');
    session.addPlayer(secondController.foreign, 'second');

    var isFirstMessage = true;
    firstController.local.stream.listen((data) {
      if (isFirstMessage == true) {
        isFirstMessage = false;
        return;
      }

      final response = SessionJoinResponse.fromJson(jsonDecode(data));
      expect(response.players, containsAll(session.players));
    });

    secondController.local.stream.listen((data) {
      final response = SessionJoinResponse.fromJson(jsonDecode(data));
      expect(response.players, containsAll(session.players));
    });
  });
}
