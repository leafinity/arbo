import 'dart:html';
import 'dart:async';

import "reversi.dart";

const int WHITE = 0, BLACK = 1;
const int UP = 0, UP_RIGHT = 1, RIGHT = 2, DOWN_RIGHT = 3;
const int DOWN = 4, DOWN_LEFT = 5, LEFT = 6, UP_LEFT = 7;
//Board chessboard;

void main() {
  VisualBoard vb = new VisualBoard (querySelector('#chessboard'),
    new Dialog(querySelector('#memo')),
    new ScoreBoard(querySelector('#score_b'), querySelector('#score_w')),
    new Alert(querySelector('#alert')));
}