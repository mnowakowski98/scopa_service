// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionJoinResponse _$SessionJoinResponseFromJson(Map<String, dynamic> json) =>
    SessionJoinResponse(
      players: (json['players'] as List<dynamic>).map((e) => e as String),
    );

Map<String, dynamic> _$SessionJoinResponseToJson(
        SessionJoinResponse instance) =>
    <String, dynamic>{
      'players': instance.players.toList(),
    };
