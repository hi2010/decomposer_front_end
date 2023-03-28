// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decompositionprofile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptimizationSettings _$OptimizationSettingsFromJson(
        Map<String, dynamic> json) =>
    OptimizationSettings(
      nPopulation: json['nPopulation'] as int? ?? 40,
      nGenerations: json['nGenerations'] as int? ?? 200,
    );

Map<String, dynamic> _$OptimizationSettingsToJson(
        OptimizationSettings instance) =>
    <String, dynamic>{
      'nPopulation': instance.nPopulation,
      'nGenerations': instance.nGenerations,
    };
