import 'package:json_annotation/json_annotation.dart';
import 'com_str.dart';

part 'optimization_settings.g.dart';

@JsonSerializable()
class OptimizationSettings extends ComStr{
  OptimizationSettings({
    this.nPopulation = 40,
    this.nGenerations = 200,
  });
  // 20 (c++default)
  int nPopulation;
  // 1k (c++default)
  int nGenerations;

  @override
  Map<String, dynamic> toMap(){
    return {
      "n_population": nPopulation,
      "n_generations": nGenerations,
    };
  }

  factory OptimizationSettings.fromJson(Map<String, dynamic> json) => _$OptimizationSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$OptimizationSettingsToJson(this);

}