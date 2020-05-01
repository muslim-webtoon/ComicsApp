import 'package:pkcomics/public.dart';

class BaseApi {
  static Request _http = Request();
  static Future<dynamic> updateUser(String uid, String email, String photoUrl,
      String userName, String phone) async {
    String _url = '/Users';
    var _data = {
      "phone": phone,
      "email": email,
      "photoUrl": photoUrl,
      "userName": userName,
      "uid": uid
    };
    return await _http.request(_url, method: "POST", data: _data);
  }
  static Future<dynamic> getAllList(
      {int page = 1, int pageSize = 20}) async {
    String _url = 'comics/comics';
    var r = await _http.request(_url);
    return r;
  }
  /*
  static Future<UserListDetail> getUserListDetailItem(
      int listid, String mediaType, int mediaid) async {
    UserListDetail model;
    String _url = '/UserListDetails/$listid/$mediaType/$mediaid';
    var r = await _http.request(_url);
    if (r != null) model = UserListDetail.fromJson(r);
    return model;
  }

  static Future<UserListDetailModel> getUserListDetailItems(int listid,
      {int page = 1, int pageSize = 20}) async {
    UserListDetailModel model;
    String _url = '/UserListDetails/List/$listid?page=$page&pageSize=$pageSize';
    var r = await _http.request(_url);
    if (r != null) model = UserListDetailModel(r);
    return model;
  }
  */

  
}