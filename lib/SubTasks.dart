class SubTasks {
  String stDesc;
  bool completed;

  SubTasks({this.stDesc, this.completed});

  SubTasks.fromJson(Map<String, dynamic> json) {
    stDesc = json['st_desc'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['st_desc'] = this.stDesc;
    data['completed'] = this.completed;
    return data;
  }
}