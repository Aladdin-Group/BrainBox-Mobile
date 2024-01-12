class EssentialModel {
  int? id;
  int? bookId;
  int? unitId;
  String? word;
  String? translationEn;
  String? translationRu;

  EssentialModel(
      {this.id,
        this.bookId,
        this.unitId,
        this.word,
        this.translationEn,
        this.translationRu});

  EssentialModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookId = json['bookId'];
    unitId = json['unitId'];
    word = json['word'];
    translationEn = json['translation_en'];
    translationRu = json['translation_ru'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bookId'] = bookId;
    data['unitId'] = unitId;
    data['word'] = word;
    data['translation_en'] = translationEn;
    data['translation_ru'] = translationRu;
    return data;
  }

  static List<EssentialModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((json) => EssentialModel.fromJson(json)).toList();
  }
}
