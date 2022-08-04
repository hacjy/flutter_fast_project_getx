class BaseModel {
  bool? success;
  int? code;
  String? msg;
  dynamic data;

  BaseModel({this.success, this.code, this.msg, this.data});

  factory BaseModel.fromJson(Map<String, dynamic> json) {
    return BaseModel(
      success: json['success'] as bool?,
      code: json['code'] as int?,
      msg: json['msg'] as String?,
      data: json['data'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'code': code,
        'msg': msg,
        'data': data,
      };
}
