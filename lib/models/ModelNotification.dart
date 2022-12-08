class ModelNotificationData {
  String? message;
  bool? status;
  Data? data;

  ModelNotificationData({this.message, this.status, this.data});

  ModelNotificationData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? count;
  List<Notifications>? notifications;

  Data({this.count, this.notifications});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (notifications != null) {
      data['notifications'] =
          notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  dynamic date;
  dynamic title;
  dynamic orderId;
  dynamic description;
  dynamic icon;

  Notifications(
      {this.date, this.title, this.orderId, this.description, this.icon});

  Notifications.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    title = json['title'];
    orderId = json['order_id'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['title'] = title;
    data['order_id'] = orderId;
    data['description'] = description;
    data['icon'] = icon;
    return data;
  }
}
