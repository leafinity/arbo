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
        _memo.innerHtml = 'You are so barbaric <img src = "../static/cry.gif" alt = "cry"></img>  Play again! Play again!';
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
  Offset nextMove(Board board, int level){
    int levelNext = level - 1;
    int highScore = -10000;
    Offset pos;
    for(int i = 0; i < 8 ; i++){
      for(int j = 0; j < 8 ; j++){
        Board tempBoard = new Board.from(board);
        if (tempBoard.canPlace(new Offset(i, j), WHITE)){
          tempBoard.placeChess(new Offset(i, j), WHITE);
          int score = getHighScore(tempBoard, BLACK, levelNext);
          print("$i,$j = $score");
          if (highScore <= score ){
            highScore = score;
            pos = new Offset(i, j);
          }
        }
      }
    }
    return pos;
  } 
  
  int getHighScore(Board board, Color color, int level){
    if(level == 0 || board.boardFull()){
      return countscore(board);
    }
    int levelNext = level - 1;
    int highScore = -10000;
    for(int i = 0; i < 8 ; i++){
      for(int j = 0; j < 8 ; j++){
        Offset pos = new Offset(i, j);
        Board tempBoard = new Board.from(board);
        if (tempBoard.canPlace(pos, color)){
          tempBoard.placeChess(pos, color);
          Color another = color == BLACK? WHITE: BLACK;
          int score = getHighScore(tempBoard, another, levelNext);
          if(color == BLACK && tempBoard.aboveConer(i, j))
            score += 500;          
          else if(color == WHITE && tempBoard.aboveConer(i, j))
            score -= 500;
          if (score >= highScore){
            highScore = score;
          }
        }
      }//j
    }//i
    return highScore;
  }
  int countscore(Board board){
    int score = 0;
    for(int i = 0; i < 8 ; i++){
      for(int j = 0; j < 8 ; j++){
        int add;
        switch(board._board[i][j]){
          case BLACK:
            add = _scores[i][j] * (-1);
            break;
          case WHITE:
            add = _scores[i][j];
            break;
          default:
            add = 0;
            break;
        }
        score = score + add;
      }
    }
    return score;
  }
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
      else if (_times >= 5)
        _dialog.write("Stop fooling!");
      else
        _dialog.write("It's my turn!");
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
          _alt.innerHtml = "${keepPlace == BLACK? 'Black': 'White'}'s turn";
        else if(_player == COMPUTER)
          _alt.innerHtml = "${keepPlace == BLACK? 'Your': 'My'} turn";
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
final List<List<int>> _scores = [
  [900, -20, 20, 30, 30, 20, -20,900],
  [-20, -50, 20, 30, 30, 20, -50,-20],
  [ 20,  20, 40, 20, 20, 40,  20, 20],
  [ 30,  30, 20, 20, 20, 20,  30, 30],
  [ 30,  30, 20, 20, 20, 20,  30, 30],
  [ 20,  20, 40, 20, 20, 40,  20, 20],
  [-20, -50, 20, 30, 30, 20, -50,-20],
  [900, -20, 20, 30, 30, 20, -20,900],
];
