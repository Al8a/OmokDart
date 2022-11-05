import 'package:omok/Model/response_parser.dart';
import 'package:omok/Model/web_client.dart';
import 'package:omok/Model/board.dart';
import 'package:omok/Model/move.dart';
import 'dart:io';


class ConsoleUI {
  void showMessage(var msg) {
    stdout.writeln(msg);
  }

  promptServer([serverUrl = WebClient.defaultServer]) {
    stdout.write('Enter the server URL [default: $serverUrl]');
    var userUrl = stdin.readLineSync();
    if (userUrl == null || userUrl.isEmpty == true) {
      return serverUrl;
    }
    return userUrl;
  }


  promptStrategy(List<dynamic> strategies) {
    stdout.writeln('Select strategy type: ');
    for (int i = 0; i < strategies.length; i++) {
      var currentStrategy = strategies[i];
      var currentIndex = i + 1;
      stdout.write("$currentIndex. $currentStrategy ");
    }

    int selectedStrategy = 0;
    while (selectedStrategy < 1 || selectedStrategy > strategies.length) {
      try {
        var line = stdin.readLineSync();
        selectedStrategy = int.parse(line ?? '0');
        if (selectedStrategy < 1 || selectedStrategy > strategies.length) {
          stdout.writeln('Invalid Selection. Try again!');
        }
      } on FormatException {
        stdout.writeln('Invalid Selection! Please input a number between [1 - ${strategies.length}]');
      }
    }
    return strategies[selectedStrategy - 1];
  }



  promptMove(Board board) {
    showBoard(board.gameBoard);
    var x;
    var y;

    while (true) {
      stdout.writeln('Enter x & y coordinates [1 - ${board.size}], e.g., 9 12)');
      var line = stdin.readLineSync() ?? "";
      List<String>? parsedInput = line.split(' ');

      if (parsedInput.length != 2) {
        stdout.write('Invalid input try again\n');
      } else {
        try {
          x = int.parse(parsedInput[0]);
          y = int.parse(parsedInput[1]);

          //will be y, x since our array is [rows][cols]
          if (board.isMoveValid(y, x)) {
            break;
          } else {
            stdout.write('Invalid input try again\n');
          }
        } catch (error) {
          stdout.write('Invalid input try again\n');
        }
      }
    }
    return [x, y];
  }


  void showBoard(var gameboard) {
    var indexes = List<int>.generate(gameboard.length, (indexes) => (indexes + 1) % 10).join(' ');
    stdout.writeln("x $indexes");

    var lines = List<String>.filled(gameboard.length + 1, '--').join('');
    stdout.write('y');
    stdout.writeln(lines);

    for (int i = 0; i < gameboard.length; i++) {
      stdout.write('${(i + 1) % 10}|');
      stdout.writeln(gameboard[i].join(" "));
    }
  }



  void playGame(Board board, String pid) async {
    while (true) {
      var responseParser = ResponseParser();

      var coordinates = promptMove(board);
      var server = WebClient(WebClient.defaultServer);
      var combinedCoordinates = '${coordinates[0] - 1},${coordinates[1] - 1}';
      var response = await server.getAckMove(pid, combinedCoordinates);
      var ackMove = response['ack_move'];
      var move = response['move'] ?? {'isWin': false, 'isDraw': false};


      if (ResponseParser.checkIfGameOver(ackMove['isDraw'], move['isDraw'], ackMove['isWin'], move['isWin'])) {
        board.updateBoard(ackMove['y'], ackMove['x'], 'X');

        if (move.length == 5) {
          board.updateBoard(move['y'], move['x'], 'O');
        }

        var row = board.getWinningRow(ackMove['row'], move['row']);
        board.updateWinningRow(row);
        showBoard(board.gameBoard);
        stdout.writeln("the game has ended");
        break;
      } else {

        board.updateBoard(ackMove['y'], ackMove['x'], 'X');
        board.updateBoard(move['y'], move['x'], 'O');
      }
    }
  }
}


/*
JSON STRING FORMAT
{"response": true,
   "ack_move": {
     "x": 4,
     "y": 5,
     "isWin": false,   // winning move?
     "isDraw": false,  // draw?
     "row": []
    },                 // winning row if isWin is true

    "move": {
      "x": 4,
      "y": 6,
      "isWin": false,
      "isDraw": false,
      "row": []
     }
 }
 */