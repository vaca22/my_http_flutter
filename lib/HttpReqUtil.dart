
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_http_flutter/common/Global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HttpReqUtil {
  Dio dio   = Dio();




  Future<Response> getData(String url) async {
    return await dio.get(url);
  }

  Future<Response> postForm(String url, Map<String, Object> params) async {
    var option = Options(
        method: "POST", contentType: "application/x-www-form-urlencoded");
    return await dio.post(url, data: params, options: option);
  }

  Future<Response> postJson(String url, Map<String, Object> params) async {
    var option = Options(method: "POST", contentType: "application/json");
    return await dio.post(url, data: params, options: option);
  }

  Future getImage() async {
    Directory? ss=await getExternalStorageDirectory();
    if(ss!=null){
      Global.path=ss.path;
      print(ss.path);
    }

    var status = await Permission.camera.status;
    if (status.isDenied) {

    }else{

    }


    if (await Permission.location.isRestricted) {

    }else{
      final ImagePicker _picker = ImagePicker();

      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);


      if(photo!=null){
        Response response=await uploadFile(photo.path,photo.name);
        print(response.data.toString());
      }
    }



  }
  /**
   * 上传文件
   * 注：file是服务端接受的字段字段，如果接受字段不是这个需要修改
   */
  Future<Response> uploadFile(String filePath, String fileName) async {
    var postData = FormData.fromMap(
        {"uploadFile": await MultipartFile.fromFile(filePath, filename: fileName)});//file是服务端接受的字段字段，如果接受字段不是这个需要修改
    var option = Options(method: "POST", contentType: "multipart/form-data");//上传文件的content-type 表单
    Dio dio   = Dio();
    return await dio.post(
      "http://139.9.206.3:3001/upload",
      data: postData,
      options: option,
      onSendProgress: (int sent, int total) {
        print("上传进度：" +
           (sent / total * 100)
                .toStringAsFixed(2) +
            "%");
      },
    );
  }



  /**
   * 下载文件 mtSWhsShPNoqwEpNaIQfpbSO6HRapG1O.jpg
   */
  Future<Response> downloadFile(String resUrl, String savePath) async {
    //还好我之前写过服务端代码，不然我根本没有相对路劲的概念
    return await dio.download(resUrl, savePath,
        onReceiveProgress: (int loaded, int total) {
          print("下载进度：" +
           (loaded / total * 100)
                  .toStringAsFixed(2) +
              "%"); //取精度，如：56.45%
        });
  }

  Future<Response> downloadFile2( ) async {
    //还好我之前写过服务端代码，不然我根本没有相对路劲的概念
    Directory? ss=await getExternalStorageDirectory();
    if(ss!=null){
      Global.path=ss.path;
      print(ss.path);
    }
    Dio dio   = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['name'] = 'mtSWhsShPNoqwEpNaIQfpbSO6HRapG1O.jpg';
    return await dio.download("http://139.9.206.3:3001/download", Global.path+"/fuck.jpg",
        onReceiveProgress: (int loaded, int total) {
          print("下载进度：" +
              (loaded / total * 100)
                  .toStringAsFixed(2) +
              "%"); //取精度，如：56.45%
        });
  }
}

