class Schedule {
  String sId;
  String startTime;
  String endTime;
  String assignedTo;

  Schedule({this.sId, this.startTime, this.endTime, this.assignedTo});

  Schedule.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    assignedTo = json['assignedTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['assignedTo'] = this.assignedTo;
    return data;
  }
}