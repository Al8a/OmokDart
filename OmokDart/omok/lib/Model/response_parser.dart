import 'package:http/http.dart';
import 'package:omok/Model/info.dart';
import 'dart:convert';
import 'dart:io';

class ResponseParser {
  ResponseParser();


  static parseInfo(String data) {
    return jsonDecode(data);
  }


  dynamic parseUrl(userInput) {
      var url = Uri.parse(userInput);
      return url;
  }


  int parseToInt(userInput) {
    var selection = 0;
    try {
      selection = int.parse(userInput);
    } on FormatException {
      stdout.write('Format Exception when parsing to integer');
    }
    return selection;
  }

  dynamic parseGamePid(response) {
    var game = json.decode(response);
    var gameStatus = game['pid'];
    var serverResponse;

    if (gameStatus) {
      serverResponse = game['pid'];
    } else {
      serverResponse = game['reason'];
    }
    return serverResponse;
  }


  dynamic parseGameInput(response){
    stdout.writeln(response);
    var play = json.decode(response);
    var serverResponse = play['response'];
    var ackMove = play['ack_move'];
    var move = play['move'];

    return {'player': ackMove, 'computer':move};
  }

  static bool checkIfGameOver(bool ackMoveDraw, bool moveDraw, bool ackMoveWin, bool moveWin) {
    if (ackMoveDraw == true || moveDraw == true) {return true;}
    else if (ackMoveWin == true || moveWin == true) {return true;}
    else {return false;}
  }
}
