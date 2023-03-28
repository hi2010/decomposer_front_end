abstract class ComStr{
  // create a key value map for every relevant param with the correct form -> in this case: lowecase with _ -> variable_name
  Map<String, dynamic> toMap();

  // creates a cmd str lst from the map adding -- to the key -> [--key, value, --key, value, ...]
  List<String> toCommandStringList() {
    var paramMap = toMap();
    List<String> paramLst = [];
    paramMap.forEach((key, value) {
      paramLst.add("--$key");
      paramLst.add("$value");
    });
    return paramLst;
  }
}