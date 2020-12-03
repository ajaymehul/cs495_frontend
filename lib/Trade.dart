class Trade {
  String uid;
  String startTime;
  String endTime;
  String assignedTo;
  String oid;
  String startTime2;
  String endTime2;
  String assignedTo2;
  String sId;
  int iV;

  Trade(
      {this.uid,
        this.startTime,
        this.endTime,
        this.assignedTo,
        this.oid,
        this.startTime2,
        this.endTime2,
        this.assignedTo2,
        this.sId,
        this.iV});

  Trade.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    assignedTo = json['assignedTo'];
    oid = json['oid'];
    startTime2 = json['startTime2'];
    endTime2 = json['endTime2'];
    assignedTo2 = json['assignedTo2'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['assignedTo'] = this.assignedTo;
    data['oid'] = this.oid;
    data['startTime2'] = this.startTime2;
    data['endTime2'] = this.endTime2;
    data['assignedTo2'] = this.assignedTo2;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}