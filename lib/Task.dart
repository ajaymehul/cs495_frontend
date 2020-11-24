import 'SubTasks.dart';
class Task {
  String sId;
  String title;
  String description;
  List<SubTasks> subTasks;
  String role;
  String shift;
  String status;
  String assigned;

  Task({this.sId,
    this.title,
    this.description,
    this.subTasks,
    this.role,
    this.shift,
    this.status,
    this.assigned});

  Task.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    if (json['subTasks'] != null) {
      subTasks = new List<SubTasks>();
      json['subTasks'].forEach((v) {
        subTasks.add(new SubTasks.fromJson(v));
      });
    }
    role = json['role'];
    shift = json['shift'];
    status = json['status'];
    assigned = json['assigned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.subTasks != null) {
      data['subTasks'] = this.subTasks.map((v) => v.toJson()).toList();
    }
    data['role'] = this.role;
    data['shift'] = this.shift;
    data['status'] = this.status;
    data['assigned'] = this.assigned;
    return data;
  }
}