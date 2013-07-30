part of reversi;

  int _player;
  int COMPUTER = 0, HUMAN = 1; 

///The visual-able board shown on the screen.
class VisualBoard extends Board {
  final Element _parent;
  final List<List<DivElement>> _cells = new List(8);
  final Dialog _dialog;
  final ScoreBoard _scoreboard;
  final Alert _alert;
  ComputerPlayer _computer = new ComputerPlayer();
  int _times = 0; 
  bool _computing = false;

  VisualBoard(this._parent, this._dialog, this._scoreboard, this._alert) {
    _initElements();
    _choosePlayer();
    _initEvents();
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
      if (pos.x < 0) pos.x = 0;
      else if (pos.x > 7) pos.x = 7;
      if (pos.y < 0) pos.y = 0;
      else if (pos.y > 7) pos.y = 7;
      new Future((){
        if (_player == HUMAN)
          _clickInH2Human(pos);
        else
          _clickInH2Computer(pos);
      });
    });
  }
  DivElement _cell(Offset pos)
  => _cells[pos.x][pos.y];

  void _clickInH2Human(Offset pos) {
    Color currentColor = _times % 2 == 0? BLACK: WHITE;
    if (canPlace(pos, currentColor)){
      placeChess(pos, currentColor);
      Color nextColor = _updateScore(currentColor);
      if (nextColor == currentColor){
        _alert.alertPop(currentColor);
        _dialog.write('${currentColor == BLACK? "White":"Black"} cannot place chess. ${currentColor}\'s turn');
      } else if (nextColor == null){
        if(!_isFinished())
          _dialog.write('No one can place chess');
        _endGame();
        return;
      } else {
        _times++;
        _dialog.write("${nextColor}'s turn");
      }
    }
  }

  void _clickInH2Computer(Offset pos) {
    if (!_computing && canPlace(pos, BLACK)){
      placeChess(pos, BLACK);
      Color nextColor = _updateScore(BLACK);
      if (nextColor == WHITE){
        _computing = true;
        _computer.computerwrite(_dialog, WHITE, _scoreboard._blackscore, _scoreboard._whitescore);
        new Timer(const Duration(milliseconds: 2500), _computerPlace);
      }
      else if(nextColor == null){
        _endGame();
        return;
      }
      else if (nextColor == BLACK){
        _dialog.write("wu~ wu~ I cannot Place chess ;A;");
        _alert.alertPop(BLACK);
      }
    }//if (canPlace(pos, BLACK))
  }
  void _computerPlace(){
    placeChess(_computer.nextMove(this), WHITE);
    Color nextColor = _updateScore(WHITE);
    if (nextColor != WHITE) {
      _computing = false;
      if (nextColor == null){
        _endGame();        
        return;
      }
      _computer.computerwrite(_dialog, BLACK, _scoreboard._blackscore, _scoreboard._whitescore);
      return;
    }
    _alert.alertPop(WHITE);
    _dialog.write("Haha~ It's my turn again B-)");
    new Timer(const Duration(milliseconds: 2500), _computerPlace);
  }

  Color _updateScore(Color currentColor) { //cpt : white
    _scoreboard.setScore(_board);
    if (_isFinished())
      return null;

    Color anotherColor = currentColor == BLACK? WHITE: BLACK; //cpt : black
    int cnt = _updateHints(anotherColor); //cpt : black
    if(cnt == 0){
      if (_player == HUMAN)
        cnt = _updateHints(currentColor); 
      else
        cnt = _updateHints(currentColor, checkOnly: true); //cpt : white
      if (cnt == 0)
          return null;
      else
        return currentColor; //cpt : white
    } else { //cnt != 0 at bigin
      return anotherColor; //cpt : black
    }
  }

  bool _isFinished(){
    return _scoreboard._blackscore == 0 || _scoreboard._whitescore == 0 
      || _scoreboard._blackscore + _scoreboard._whitescore == 64;
  }

  int _updateHints(Color color, {bool checkOnly: false}) {
    int num_can_set = 0;
    for (int i = 0; i < 8; i++){
      for (int j = 0; j < 8; j++){
        Offset pos = new Offset(i, j);
        if (canPlace(pos, color)){
          if(!checkOnly)
            _cell(pos).classes.add('can_set');
          num_can_set++;
        }
        else{
          if(!checkOnly)
            _cell(pos).classes.remove('can_set');
        }
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
  void _choosePlayer(){
    DivElement p1 = query('#oneplayer');
    DivElement p2 = query('#twoplayer');
    p1.onClick.listen(( MouseEvent evt){
      _player = COMPUTER;
      p1.classes.add('disappear');
      p2.classes.add('disappear');
      DivElement dis = query('#bigShield');
      dis.classes.add('disappear');
      dis = query('.playerchoice');
      dis.classes.add('disappear');
      dis = query('.playerchoice1');
      dis.classes.add('disappear');
      dis = query('.playerchoice2');
      dis.classes.add('disappear');
      _dialog.write('You go first');
    });
    p2.onClick.listen(( MouseEvent evt){
      _player = HUMAN;
      p1.classes.add('disappear');
      p2.classes.add('disappear');
      DivElement dis = query('#bigShield');
      dis.classes.add('disappear');
      dis = query('.playerchoice');
      dis.classes.add('disappear');
      dis = query('.playerchoice1');
      dis.classes.add('disappear');
      dis = query('.playerchoice2');
      dis.classes.add('disappear');
      _dialog.write('Black first');
    });
  }

  void _endGame(){
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
      window.location.reload();
    });
  }
}