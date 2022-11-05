import 'package:omok/Model/response_parser.dart';
import 'package:http/http.dart' as http;
import 'dart:io';



class WebClient {
  static const defaultServer = 'https://www.cs.utep.edu/cheon/cs3360/project/omok/info/';
  var server;

  WebClient(this.server);

  getInfo() async {
    try {
      var serverUrl = Uri.parse(server);
      var response = await http.get(serverUrl);
      var jsonResponse = ResponseParser.parseInfo(response.body);
      return jsonResponse;
    } catch (error) {
      return null;
    }
  }


  getPID(String pickedStrategy) async {
    var url = 'https://www.cs.utep.edu/cheon/cs3360/project/omok/new/?';
    var strategy = pickedStrategy;
    try {
      var uri = Uri.parse('${url}strategy=$strategy');
      var response = await http.get(uri);
      var jsonResponse = ResponseParser.parseInfo(response.body);
      return jsonResponse;
    } catch (error) {
      return null;
    }
  }


  getAckMove(String pidIn, var xyInput) async {
    var url = 'https://www.cs.utep.edu/cheon/cs3360/project/omok/play/?';
    var pid = pidIn;
    var xy = xyInput;
    try {
      var uri = Uri.parse('${url}pid=$pid&move=$xy');
      var response = await http.get(uri);
      var jsonResponse = ResponseParser.parseInfo(response.body);
      return jsonResponse;
    } catch (error) {
      return null;
    }
  }
}



