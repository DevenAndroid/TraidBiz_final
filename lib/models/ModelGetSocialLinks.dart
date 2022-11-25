class ModelGetSocialLinksResponse {
  ModelGetSocialLinksResponse({
    this.data,
  });
  List<Data>? data;

  ModelGetSocialLinksResponse.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data!.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.tittle,
    required this.link,
  });
  late final String tittle;
  late final String link;

  Data.fromJson(Map<String, dynamic> json){
    tittle = json['tittle'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['tittle'] = tittle;
    _data['link'] = link;
    return _data;
  }
}