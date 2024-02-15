import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:scopa_service/session.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:uuid/uuid.dart';

part 'session_manager.g.dart';

@JsonSerializable()
class SessionCreate {
  SessionCreate({
    required this.playerName,
  });

  final String playerName;

  factory SessionCreate.fromJson(Map<String, dynamic> json) =>
      _$SessionCreateFromJson(json);
  Map<String, dynamic> toJson() => _$SessionCreateToJson(this);
}

@JsonSerializable()
class SessionCreateResponse {
  SessionCreateResponse({required this.sessionId});

  final String sessionId;

  factory SessionCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionCreateResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SessionCreateResponseToJson(this);
}

@JsonSerializable()
class SessionJoin {
  SessionJoin({
    required this.playerName,
    required this.sessionId,
  });

  final String playerName;
  final String sessionId;

  factory SessionJoin.fromJson(Map<String, dynamic> json) =>
      _$SessionJoinFromJson(json);
  Map<String, dynamic> toJson() => _$SessionJoinToJson(this);
}

class SessionManager {
  final _floatingChannels = <StreamChannel>[];
  final _sessions = <String, Session>{};

  bool _checkFloating(StreamChannel channel, bool shouldFloat) {
    final isFloating = _floatingChannels.contains(channel);
    if (shouldFloat == true && isFloating == false) {
      channel.sink.add(
          json.encode({'error': 'Command can not be used while in a session'}));
      return false;
    }

    if (shouldFloat == false && isFloating == true) {
      channel.sink.add(json
          .encode({'error': 'Command can not be used while not in a session'}));
      return false;
    }

    return true;
  }

  void addChannel(StreamChannel channel) {
    _floatingChannels.add(channel);
    channel.stream.listen((data) {
      final message = json.decode(data as String) as Map<String, dynamic>;
      final command = message['command'] as String?;
      if (command == null) return;

      switch (command) {
        case 'create':
          if (_checkFloating(channel, true)) break;

          final createCommand = SessionCreate.fromJson(message);

          final sessionId = Uuid().v4();
          final session = Session(sessionId);

          final response =
              json.encode(SessionCreateResponse(sessionId: sessionId).toJson());
          channel.sink.add(response);

          session.addPlayer(channel, createCommand.playerName);
          _sessions[sessionId] = (Session(sessionId));
          _floatingChannels.remove(channel);
          break;

        case 'join':
          if (_checkFloating(channel, true)) break;

          final joinCommand = SessionJoin.fromJson(message);

          final session = _sessions[joinCommand.sessionId];
          if (session == null) break;

          session.addPlayer(channel, joinCommand.playerName);
          _floatingChannels.remove(channel);
          break;

        default:
          if (_checkFloating(channel, false)) break;

          final session = _sessions.values
              .where((session) => session.hasChannel(channel))
              .firstOrNull;

          if (session != null) {
            session.execute(command, message);
          }
          break;
      }
    });
  }
}
