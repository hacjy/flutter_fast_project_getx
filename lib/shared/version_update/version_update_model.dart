class VersionUpdateModel {
  bool? success;
  int? code;
  String? msg;
  List<VersionItem>? data;

  VersionUpdateModel({this.success, this.code, this.msg, this.data});

  VersionUpdateModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <VersionItem>[];
      json['data'].forEach((v) {
        data!.add(new VersionItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VersionItem {
  String? version;
  String? sn;
  int? osType;
  int? updateType;
  String? note;
  String? url;

  VersionItem(
      {this.version,
      this.sn,
      this.osType,
      this.updateType,
      this.note,
      this.url});

  VersionItem.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    sn = json['sn'];
    osType = json['osType'];
    updateType = json['updateType'];
    note = json['note'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['sn'] = this.sn;
    data['osType'] = this.osType;
    data['updateType'] = this.updateType;
    data['note'] = this.note;
    data['url'] = this.url;
    return data;
  }
}
