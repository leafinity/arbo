//Chess Utilities
library reversi;

import "dart:html";
import "dart:async";

part "reversi_util.dart";
part "visualboard.dart";

class Offset {
  int x, y;

  Offset([this.x = 0, this.y = 0]);

  bool operator==(other) {
    if (other is Offset)
      return x == other.x && y == other.y;
    if (other is List && other.length == 2)
      return x == other[0] && y == other[1];
    return false;
  }
  Offset operator+(Offset offset)
  => new Offset(x + offset.x, y + offset.y);
  Offset swap() => new Offset(y, x);

  bool get isInside => x >= 0 && x <= 7 && y >= 0 && y <= 7;

  int get hashCode => x + y;
  String toString() => "($x, $y)";
}

class Color {
  final String color;
  const Color(this.color);
  String toString() => color;
}
const Color BLACK = const Color("Black"),
  WHITE = const Color("White");

class Board {
  List<List<Color>> _board;
  Board() {
    _init();
  }
  Board.from(Board board) {
    _init();
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        _board[i][j] = board._board[i][j];
      }
    }
  }
  void _init() {
    _board = new List(8);
    for(int i = 0; i < 8; i++){
      _board[i] = new List(8);
    }
  }
  int _getScore(Color color) {
    int score = 0;
    return score;
  }
  bool canPlace(Offset pos, Color color) {
    if (this[pos] == null) {
      for (Offset ofs in _allOfs)
        if (_placeLine(pos, ofs, color, checkOnly: true))
          return true;
    }
    return false;
  }
  void placeChess(Offset pos, Color color) {
    assert(this[pos] == null);
    for (Offset ofs in _allOfs)
      _placeLine(pos, ofs, color);
  }
  bool _placeLine(Offset pos, Offset ofs, Color color,
    {bool checkOnly: false}) {
    Offset p = pos + ofs;
    if (p.isInside && (this[p] != color && this[p] != null)) {
      for (p = p + ofs; p.isInside && this[p]!= null; p = p + ofs){
        if(this[p] == color) {
          if(!checkOnly){
            while(pos != p){
              _placeOne(pos, color);
              pos = pos +ofs; 
            }
          }
          return true;
        }
      }
    }
    return false;
  }
  void _placeOne(Offset pos, Color color) {
    this[pos] = color;
  }
  Color operator[](Offset pos) => _board[pos.x][pos.y];
  void operator[]=(Offset pos, Color color) {
    _board[pos.x][pos.y] = color;
  }
}

final List<Offset> _allOfs = [
  new Offset(-1, 0), new Offset(-1, 1), new Offset(0, 1),
  new Offset(1, 1),                     new Offset(1, 0),
  new Offset(1, -1), new Offset(0, -1), new Offset(-1, -1)];
final List<List<int>> _scores = [
  [300, -20, 20, 30, 30, 20, -20,100],
  [-20, -50, 20, 30, 30, 20, -50,-20],
  [ 20,  20, 40, 20, 20, 40,  20, 20],
  [ 30,  30, 20,  0,  0, 20,  30, 30],
  [ 30,  30, 20,  0,  0, 20,  30, 30],
  [ 20,  20, 40, 20, 20, 40,  20, 20],
  [-20, -50, 20, 30, 30, 20, -50,-20],
  [100, -20, 20, 30, 30, 20, -20,300],
];
