import 'package:json_annotation/json_annotation.dart';
import 'com_str.dart';

part 'optimization_weights.g.dart';

@JsonSerializable()
class OptimizationWeights extends ComStr{
  double costRoughness;
  double costOverhang;
  double costSharpness;
  double costGap;
  double costConcavity;
  double costFeasibility;
  double costInterface;
  double costQuantity;

  OptimizationWeights({
    this.costRoughness = 1, 
    this.costOverhang = 1, 
    this.costSharpness = 50,
    this.costGap = 1, 
    this.costConcavity = .0000001,
    this.costFeasibility = 1, 
    this.costInterface = .001,
    this.costQuantity = 500,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "cost_roughness": costRoughness,
      "cost_overhang": costOverhang,
      "cost_sharpness": costSharpness,
      "cost_gap": costGap,
      "cost_concavity": costConcavity,
      "cost_feasibility": costFeasibility,
      "cost_interface": costInterface,
      "cost_quantity": costQuantity,
    };
  }

  factory OptimizationWeights.fromJson(Map<String, dynamic> json) => _$OptimizationWeightsFromJson(json);
  Map<String, dynamic> toJson() => _$OptimizationWeightsToJson(this);

}
