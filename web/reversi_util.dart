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
    _memoTimer = new Timer.periodic(const Duration(milliseconds: 90), (_) {
      _memo.text = "${text.substring(0, i)}_";
      if(++i > text.length)
        _cancelTimers(winner: false);
    });
  }
  void writeWinner(Color color) {
    if(_player == HUMAN) {
      String text1 ="""\\(>w<)/\\(>w<)/<br/><br/>&nbsp &nbsp &nbsp${color == BLACK? "Black": "White"} wins<br/><br/>\\(>w<)/\\(>w<)/_""";
      String text2 ="""|(>w<)\\/(>w<)|<br/><br/>&nbsp &nbsp &nbsp${color == BLACK? "Black": "White"} wins<br/><br/>|(>w<)\\/(>w<)|""";
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
    if (_player == COMPUTER) {
      if(color == BLACK) 
        write("QAQ You are so barbaric. Don't be so cruel to me. wu~~~");
      else if(color == WHITE)
        write('HA!HA!HA! I WIN. Go to pratice more');
    }
  }
  void _cancelTimers({bool memo: true, bool winner: true}) {
    if (memo && _memoTimer != null) {
      _memoTimer.cancel();
      _memoTimer = null;
    }
    if (winner && _winTimer != null) {
      _winTimer.cancel();
      _winTimer = null;
    }
  }
}

class ComputerPlayer {
  Offset nextMove(Board board){
    int highest = 0;
    Offset h_pos;
    int times = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Board temp_b = new Board.from(board);
        int score = 0;
        Offset pos = new Offset(i, j);
        if(temp_b.canPlace(pos, WHITE)) {
          if(i + j == 1 || (ab(i, j) == 6 && (i + j == 6) || (i + j == 8)) || i + j == 13)
            score -= 200;
          temp_b.placeChess(pos, WHITE);
          for (int k = 0; k < 8; k++) {
            for (int l = 0; l < 8; l++) {
              int a = 0;
              switch(temp_b._board[k][l]){
                case BLACK:
                  a = _scores[k][l] * -1;
                  break;
                case WHITE:
                  a = _scores[k][l];
              }
              score += a;
            } // l
          } // k
          if (times == 0){
            highest = score;
            h_pos = pos;
            times++;
          }
          else if(score > highest){
            highest = score;
            h_pos = pos;
          }
          score = 0;
        }
      } // j
    } // i
    return h_pos;
  } // function nextMove()
  int _bScoreOrigin, _wScoreOrigin;
  void computerwrite(Dialog _dialog, Color nextcolor, int bScore, int wScore){
    if(_bScoreOrigin == null || _wScoreOrigin == null){
      if(nextcolor == WHITE)
        _dialog.write("Let me think...");
      else if(nextcolor == BLACK)
        _dialog.write("Your turn");
    }
    else if(nextcolor == WHITE) {
      int bDif = bScore - _bScoreOrigin;
      if (bDif > 20)
        _dialog.write("You're a jerk!");
      if (bDif > 15)
        _dialog.write("I hate you QAQ");
      else if (bDif > 10)
        _dialog.write("Barbarian!!!");
      else if (bDif > 4)
        _dialog.write("O_Q Please be gentle");
      else if (bDif > 2)
        _dialog.write("Let me think...");
      else
        _dialog.write("Stop fooling!");
    } else {
      int wDif = wScore - _wScoreOrigin;
      if(wDif > 15)
        _dialog.write("Hahaha~ How could you do?");
      else if (wDif > 8)
        _dialog.write("How talented I am");
      else if (wDif > 5)
        _dialog.write("Haha.");
      else if (wDif > 3)
        _dialog.write("It's your turn :-)");
      else
        _dialog.write("Your turn OAQ");
    }
    _wScoreOrigin = wScore;
    _bScoreOrigin = bScore;
  }
} // class ComputerPlayer

int ab(int a, int b){
  return (a-b) >= 0? (a-b): (b-a);
}

class Alert {
  final DivElement _alt;
  Alert(this._alt);
  int clickTimes = 0;
  int pastSeconds = 0;
  void alertPop(Color keepPlace){
    _alt.classes.add('sbCannotChess_state2');
    if(keepPlace == BLACK && _player == COMPUTER)
      _alt.innerHtml = "QAQ<br>I cannot move.";
    else
      _alt.innerHtml = "Ooops!<br>You cannot move.";
    _alt.onMouseUp.listen(( MouseEvent evt){
      if(clickTimes == 0){
        if(_player == HUMAN)
          _alt.innerHtml = "<br>${keepPlace == BLACK? 'Black': 'White'}'s turn";
        else if(_player == COMPUTER)
          _alt.innerHtml = "<br>${keepPlace == BLACK? 'Your': 'My'} turn";
        clickTimes++;
        pastSeconds = 1;
        return;
      }
      _alt.classes.remove('sbCannotChess_state2');
      clickTimes = 0;
      pastSeconds = 0;
      return;
    });
    Timer _altTimer = new Timer.periodic(const Duration(milliseconds: 3500),(Timer timer) {
      if(pastSeconds == 0){
        if(_player == HUMAN)
          _alt.innerHtml = "<br>${keepPlace == BLACK? 'Black': 'White'}'s turn";
        else if(_player == COMPUTER)
          _alt.innerHtml = "<br>${keepPlace == BLACK? 'Your': 'My'} turn";
        pastSeconds++;
        clickTimes++;
      }
      else if(pastSeconds == 1){
        _alt.classes.remove('sbCannotChess_state2');
        clickTimes = 0;
        pastSeconds = 0;
        timer.cancel();
      }
    });
  }
  
}

