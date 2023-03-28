import 'package:vector_math/vector_math.dart';

class PrinterDimensions {
  PrinterDimensions({required Vector3 boundingBox}) : _boundingBox = boundingBox {
    if (boundingBox.isNaN) {
      throw const FormatException("bbx size cannot be null");
    }
    _boundingBox = boundingBox;
  }

  Vector3 _boundingBox;
  
  set boundingBox (Vector3 bbx) {
    if (bbx.isNaN) {
      throw const FormatException("bbx size cannot be null");
    }
    _boundingBox = bbx;
  }

  Vector3 get boundingBox {
    return _boundingBox;
  }

  List<String> toCommandStringList() {
    return ["--printer_dimensions", "${_boundingBox.x.toString()},${_boundingBox.y.toString()},${_boundingBox.z.toString()}"];
  }

  Map<String, dynamic> toJson() {
    return {
      "printerDimensionType": "boundingbox",
      "printerBbxXDim": _boundingBox.x,
      "printerBbxYDim": _boundingBox.y,
      "printerBbxZDim": _boundingBox.z,
    };
  }


  factory PrinterDimensions.fromJson(Map<String, dynamic> json) {
    // costRoughness: (json['costRoughness'] as num?)?.toDouble() ?? 1,
    return PrinterDimensions(
      boundingBox: Vector3(
        (json["printerBbxXDim"] as num).toDouble(),
        (json["printerBbxYDim"] as num).toDouble(),
        (json["printerBbxZDim"] as num).toDouble(),
      )
    );
  }
}