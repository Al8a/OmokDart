import 'package:omok/Model/response_parser.dart';
import 'dart:io';


class Board {
  final int size;
  var _gameBoard;


  get gameBoard => _gameBoard;


  set gameBoard(gameBoard) {
    _gameBoard = gameBoard;
  }


  Board(this.size, this._gameBoard);

  ///generates a array of size filled with '.'
  static Board generateBoard(size) {
    var board = List.generate(size, (i) => List.filled(size, '.', growable: false), growable: false);
    return Board(size,board);
  }

  /// make sure that the postion given is a valid
  bool isMoveValid(var xCoordinate, var yCoordinate) {
    if ((xCoordinate < 1 || xCoordinate > size) || (yCoordinate < 1 || yCoordinate > size)) {
      return false;
    }

    if (gameBoard[xCoordinate - 1][yCoordinate - 1] != ".") {
      stdout.writeln("position is not empty");
      return false;
    }
    return true;
  }

  /// methods is responsible for placing the stone with the symbol
  void updateBoard(var xCoordinate, var yCoordinate, String symbol) {
    gameBoard[xCoordinate][yCoordinate] = symbol;
  }

  /*Highlights the winning row in UI */
  void updateWinningRow(List<dynamic> row) {
    for (int i = 0; i < row.length; i += 2) {
      updateBoard(row[i + 1], row[i], '*');
    }
  }

  ///Gets row
  List<dynamic> getWinningRow(var ackMove, var move) {
    if (ackMove.length == 10) {
      return ackMove;
    } else if (move.length == 10) {
      return move;
    }
    return [];
  }
}
