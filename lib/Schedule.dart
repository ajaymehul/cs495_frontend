class Schedule {
  Id iId;
  String startTime;
  String endTime;
  String assignedTo;
  String color;

  Schedule(
      {this.iId, this.startTime, this.endTime, this.assignedTo, this.color});

  Schedule.fromJson(Map<String, dynamic> json) {
    iId = json['_id'] != null ? new Id.fromJson(json['_id']) : null;
    startTime = json['startTime'];
    endTime = json['endTime'];
    assignedTo = json['assignedTo'];
    //color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.iId != null) {
      data['_id'] = this.iId.toJson();
    }
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['assignedTo'] = this.assignedTo;
    data['color'] = this.color;
    return data;
  }
}

class Id {
  String oid;

  Id({this.oid});

  Id.fromJson(Map<String, dynamic> json) {
    oid = json['$oid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$oid'] = this.oid;
    return data;
  }
}

// class StartTime {
//   DateTime date;
//
//   StartTime({this.date});
//
//   StartTime.fromJson(Map<String, dynamic> json) {
//     date = json['$date'] != null ? new DateTime.fromJson(json['$date']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.date != null) {
//       data['$date'] = this.date.toJson();
//     }
//     return data;
//   }
// }
//
// class DateTime  {
//   DateTime numberLong;
//
//   DateTime({this.numberLong});
//
//   DateTime.fromJson(Map<String, dynamic> json) {
//     numberLong = json['$numberLong'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['$numberLong'] = this.numberLong;
//     return data;
//   }
// }