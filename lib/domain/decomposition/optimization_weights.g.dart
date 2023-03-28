// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'optimization_weights.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptimizationWeights _$OptimizationWeightsFromJson(Map<String, dynamic> json) =>
    OptimizationWeights(
      costRoughness: (json['costRoughness'] as num?)?.toDouble() ?? 1,
      costOverhang: (json['costOverhang'] as num?)?.toDouble() ?? 1,
      costSharpness: (json['costSharpness'] as num?)?.toDouble() ?? 50,
      costGap: (json['costGap'] as num?)?.toDouble() ?? 1,
      costConcavity: (json['costConcavity'] as num?)?.toDouble() ?? .0000001,
      costFeasibility: (json['costFeasibility'] as num?)?.toDouble() ?? 1,
      costInterface: (json['costInterface'] as num?)?.toDouble() ?? .001,
      costQuantity: (json['costQuantity'] as num?)?.toDouble() ?? 500,
    );

Map<String, dynamic> _$OptimizationWeightsToJson(
        OptimizationWeights instance) =>
    <String, dynamic>{
      'costRoughness': instance.costRoughness,
      'costOverhang': instance.costOverhang,
      'costSharpness': instance.costSharpness,
      'costGap': instance.costGap,
      'costConcavity': instance.costConcavity,
      'costFeasibility': instance.costFeasibility,
      'costInterface': instance.costInterface,
      'costQuantity': instance.costQuantity,
    };
