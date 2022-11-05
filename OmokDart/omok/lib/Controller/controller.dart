import 'package:omok/Model/web_client.dart';
import 'package:omok/View/console_ui.dart';
import 'package:omok/Model/player.dart';
import 'package:omok/Model/board.dart';
import 'package:omok/Model/info.dart';
import 'dart:io';


class Controller {
  Future<void> start() async {
    var ui = ConsoleUI();
    ui.showMessage('Welcome to Omok Game!');

    var server = ui.promptServer();
    ui.showMessage('Connecting to the server: [$server]');

    var net = WebClient(server);
    var decodedResponse = await net.getInfo();

    if (decodedResponse == null) {
      ui.showMessage('Unable to connect\nExiting...');
      return;
    }

    Info gameInfo = Info(decodedResponse['size'], decodedResponse['strategies']);
    var board = Board.generateBoard(gameInfo.size);

    ui.showMessage("Please Select a strategy");
    var strategySelected = ui.promptStrategy(gameInfo.strategies);
    ui.showMessage("Creating new game with $strategySelected as selected the strategy...");
    var pid = await net.getPID(strategySelected);
    ui.showMessage('NEW GAME ID: [${pid['pid']}]');
    ui.playGame(board, pid['pid']);

  }
}
