import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:stream_channel/stream_channel.dart';

part 'session.g.dart';

@JsonSerializable()
class SessionJoinResponse {
  SessionJoinResponse({required this.players});

  final Iterable<String> players;

  factory SessionJoinResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionJoinResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SessionJoinResponseToJson(this);
}

class Session {
  Session(this.key);

  final String key;

  final _players = <StreamChannel, String>{};
  Iterable<String> get players => _players.values;

  void addPlayer(StreamChannel channel, String name) {
    _players[channel] = name;

    final response =
        jsonEncode(SessionJoinResponse(players: _players.values).toJson());

    for (final playerChannel in _players.keys) {
      playerChannel.sink.add(response);
    }
  }

  bool hasChannel(StreamChannel channel) => _players[channel] != null;

  void execute(String command, Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  bool operator ==(Object other) => other is Session && key == other.key;

  @override
  int get hashCode => key.hashCode;
}
