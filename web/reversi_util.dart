part of reversi;

class ScoreBoard {
  final DivElement _black, _white;
  int _blackscore, _whitescore;
  ScoreBoard(this._black, this._white);

  void setScore(List<List<Color>> _board) {
    _blackscore = 0;
    _whitescore = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if(_board[i][j] == BLACK)
          _blackscore++;
        else if(_board[i][j] == WHITE)
          _whitescore++;
      }
    }
    _black.text = '$_blackscore';
    _white.text = '$_whitescore';
  }
}

class Dialog {
  Timer _memoTimer, _winTimer;
  final DivElement _memo;
  Dialog(this._memo);

  void write(String text) {
    _cancelTimers();
    _memo.text = "";
    int i = 0;
    _memoTimer = new Timer.periodic(const Duration(milliseconds: 120), (_) {
      _memo.text = "${text.substring(0, i)}_";
      if(++i > text.length)
        _cancelTimers();
    });
  }
  void writeWinner(Color color) {
    String text1 ="""\\(>w<)/\\(>w<)/<br/><br/>&nbsp &nbsp &nbsp${color == BLACK? "Black": "White"}win<br/><br/>\\(>w<)/\\(>w<)/_""";
    String text2 ="""|(>w<)\\/(>w<)|<br/><br/>&nbsp &nbsp &nbsp${color == BLACK? "Black": "White"}win<br/><br/>|(>w<)\\/(>w<)|""";
    int i = 0;
    _winTimer = new Timer.periodic(const Duration(milliseconds: 110),(Timer timer) {
      if(_memoTimer == null){
        _memo.innerHtml = i % 2 == 0 ? text1: text2;
        i++;
        if(i == 100)
          i = 0;
      }
    });
  }
  void _cancelTimers() {
    if (_memoTimer != null) {
      _memoTimer.cancel();
      _memoTimer = null;
    }
    if (_winTimer != null) {
      _winTimer.cancel();
      _winTimer = null;
    }
  }
}
