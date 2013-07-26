//Chess Utilities
library reversi;

import "dart:html";
import "dart:async";

part "reversi_util.dart";

class Offset {
  int x, y;

  Offset([this.x = 0, this.y = 0]);

  bool operator==(other) {
    if (other is Offset)
      return x == other.x && y == other.y;
    if (other is List && other.length == 2)
      return x == other[0] && y == other.y;
    return false;
  }
  Offset operator+(Offset offset)
  => new Offset(x + offset.x, y + offset.y);
  Offset swap() => new Offset(y, x);

  bool get isInside => x >= 0 && x <= 7 && y >= 0 && y <= 7;

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

///The visual-able board shown on the screen.
class VisualBoard extends Board {
  final Element _parent;
  final List<List<DivElement>> _cells = new List(8);
  final Dialog _dialog;
  final ScoreBoard _scoreboard;
  int _times = 0;

  VisualBoard(this._parent, this._dialog, this._scoreboard) {
    _initElements();
    _initEvents();
    _dialog.write("Black first");
    _scoreboard.setScore(_board);    
  }
  void _initElements() {
    for (int i = 0; i < 8; i++) {
      _cells[i] = new List(8);
      String ver = i == 0? "boardleft" : "";
      int left = i == 0? 0: ((i-1) * 70 + 71);
      for (int j = 0; j < 8; j++) {
        String horz = j == 0? "boardtop" : "";
        int top = j == 0? 0: ((j-1) * 70 + 71);
        _parent.nodes.add(
          _cells[i][j] = new Element.html('<div class = "ch_child $horz $ver" style = "left : ${left}px; top : ${top}px;"></div>'));
      }
    }
    _placeOne(new Offset(3, 3), BLACK);
    _placeOne(new Offset(4, 4), BLACK);
    _placeOne(new Offset(3, 4), WHITE);
    _placeOne(new Offset(4, 3), WHITE);

    int a = _updateHints(BLACK);
  }
  void _initEvents(){
    _parent.onClick.listen(( MouseEvent evt){
      Offset pos = new Offset(
        (((evt.page.x - _parent.offsetLeft) / 70).toInt()),
          (((evt.page.y - _parent.offsetTop) / 70).toInt())
      );
      print("pos: $pos");
      Color current_color = _times % 2 == 0? BLACK: WHITE;
      Color next_color = _times % 2 == 0? WHITE: BLACK;
      if (canPlace(pos, current_color)){
        placeChess(pos, current_color);
        _times++;
        _dialog.write("${next_color}'s turn");
        int a = _updateHints(next_color);
        _scoreboard.setScore(_board);
        if(_scoreboard._blackscore == 0 || _scoreboard._whitescore == 0 
          || _scoreboard._blackscore + _scoreboard._whitescore == 64)
          _EndGame();
        else if(a == 0){
          a =  _updateHints(current_color);
          if(a == 0){
            _dialog.write('No one can place chess');
            _EndGame();
          }
          else{
            _dialog.write("$next_color cannot place chess. ${current_color}'s turn");
            _times++;
          }
        }
      }
    });
  }
  DivElement _cell(Offset pos)
  => _cells[pos.x][pos.y];

  int _updateHints(Color color) {
    int num_can_set = 0;
    for (int i = 0; i < 8; i++){
      for (int j = 0; j < 8; j++){
        Offset pos = new Offset(i, j);
        if (canPlace(pos, color)){
          _cell(pos).classes.add('can_set');
          num_can_set++;
        }
        else
          _cell(pos).classes.remove('can_set');
      }
    }
    return num_can_set;
  }
  void placeChess(Offset pos, Color color) {
    super.placeChess(pos, color);
    _placeOne(pos, color);
  }

  void _placeOne(Offset pos, Color color) {
    //change the DOM element
    if (this[pos] == null) {
      _cell(pos).nodes.add( new Element.html('<div class="${color == BLACK? "b": "w"}c"></div>'));
      _cell(pos).classes.remove('can_set');
    } else if (color == BLACK){
        DivElement chess = _cell(pos).nodes[0];
        chess.classes.add('bc');
        chess.classes.remove('wc');
    } else {
        DivElement chess = _cell(pos).nodes[0];
        chess.classes.add('wc');
        chess.classes.remove('bc');
    }
    super._placeOne(pos, color);
  }

  void _EndGame(){
    int a = _scoreboard._blackscore - _scoreboard._whitescore;
    if(a > 0)
      _dialog.writeWinner(BLACK);
    else if (a == 0)
      _dialog.write("Duce. Let's play again");
    else
      _dialog.writeWinner(WHITE);
   ButtonElement restart = query('#restart');
   restart.classes.add('restart');
   restart.onClick.listen((MouseEvent evt){
     _dialog._cancelTimers();
     _dialog.write("Please push F5");
     restart.remove();
   });
  }
}
final List<Offset> _allOfs = [
  new Offset(-1, 0), new Offset(-1, 1), new Offset(0, 1),
  new Offset(1, 1),                     new Offset(1, 0),
  new Offset(1, -1), new Offset(0, -1), new Offset(-1, -1)];
final List<List<int>> _scores = [
  [100, -20, 20, 30, 30, 20, -20, 100],
];
