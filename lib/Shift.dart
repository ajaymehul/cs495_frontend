class Shift {
  String startTime;
  String endTime;
  String user;

  Shift({this.startTime, this.endTime, this.user});

  Shift.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['user'] = this.user;
    return data;
  }
}