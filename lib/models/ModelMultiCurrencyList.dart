class ModelMultiCurrencyList {
  ModelMultiCurrencyList({
    this.status,
    this.message,
    this.data,
  });
  bool? status;
  String? message;
  List<Data>? data;

  ModelMultiCurrencyList.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data!.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.code,
    required this.title,
    required this.isSelected,
  });
  late final String code;
  late final String title;
  late final bool isSelected;

  Data.fromJson(Map<String, dynamic> json){
    code = json['code'];
    title = json['title'];
    isSelected = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['title'] = title;
    _data['is_selected'] = isSelected;
    return _data;
  }
}