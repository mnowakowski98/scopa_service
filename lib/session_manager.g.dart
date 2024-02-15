// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionCreate _$SessionCreateFromJson(Map<String, dynamic> json) =>
    SessionCreate(
      playerName: json['playerName'] as String,
    );

Map<String, dynamic> _$SessionCreateToJson(SessionCreate instance) =>
    <String, dynamic>{
      'playerName': instance.playerName,
    };

SessionCreateResponse _$SessionCreateResponseFromJson(
        Map<String, dynamic> json) =>
    SessionCreateResponse(
      sessionId: json['sessionId'] as String,
    );

Map<String, dynamic> _$SessionCreateResponseToJson(
        SessionCreateResponse instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
    };

SessionJoin _$SessionJoinFromJson(Map<String, dynamic> json) => SessionJoin(
      playerName: json['playerName'] as String,
      sessionId: json['sessionId'] as String,
    );

Map<String, dynamic> _$SessionJoinToJson(SessionJoin instance) =>
    <String, dynamic>{
      'playerName': instance.playerName,
      'sessionId': instance.sessionId,
    };
