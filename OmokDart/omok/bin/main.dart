import 'package:omok/Controller/controller.dart';
import 'package:omok/Model/response_parser.dart';
import 'package:omok/Model/web_client.dart';
import 'package:http/http.dart' as http;
import 'package:omok/main.dart' as omok;
import 'package:omok/Model/board.dart';
import 'package:omok/Model/info.dart';
import 'dart:convert';
import 'dart:io';

/*Authors: 
* Alan Ochoa
* Johnatan Garcia
* Omok Dart
* Dr.Cheon
* November 4th
*/ 
void main(List<String> args) {
  Controller().start();
}
