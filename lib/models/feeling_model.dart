class FeelingModel {
  String id;
  String sentindo;
  String data;

  FeelingModel({
    required this.id,
    required this.sentindo,
    required this.data,
  });

  FeelingModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        sentindo = map["sentindo"],
        data = map["data"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "sentindo": sentindo, // Corrigido de "name" para "sentindo"
      "data": data, // Corrigido de "treino" para "data"
    };
  }
}
