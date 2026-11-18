// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['location_check', 'require_screen_online', 'ai_enabled', 'languages', 'poll_interval_seconds'],
    disallowNullValues: const [
      'location_check',
      'require_screen_online',
      'ai_enabled',
      'languages',
      'poll_interval_seconds',
    ],
  );
  return Config(
    locationCheck: Config._read_locationCheck(json['location_check']),
    requireScreenOnline: json['require_screen_online'] as bool,
    aiEnabled: json['ai_enabled'] as bool,
    languages: Config._read_languages(json['languages']),
    pollIntervalSeconds: Config._read_pollIntervalSeconds(json['poll_interval_seconds']),
    additionalProperties: Config._extras(json, 'additionalProperties') == null
        ? const {}
        : Config._readExtras(Config._extras(json, 'additionalProperties')),
  );
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
  'location_check': ?Config._write_locationCheck(instance.locationCheck),
  'require_screen_online': instance.requireScreenOnline,
  'ai_enabled': instance.aiEnabled,
  'languages': ?Config._write_languages(instance.languages),
  'poll_interval_seconds': ?Config._write_pollIntervalSeconds(instance.pollIntervalSeconds),
};
