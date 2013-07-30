import 'dart:html';
import 'dart:async';

import "reversi.dart";

const int WHITE = 0, BLACK = 1;
const int UP = 0, UP_RIGHT = 1, RIGHT = 2, DOWN_RIGHT = 3;
const int DOWN = 4, DOWN_LEFT = 5, LEFT = 6, UP_LEFT = 7;
//Board chessboard;

void main() {
  VisualBoard vb = new VisualBoard (query('#chessboard'),
    new Dialog(query('#memo')),
    new ScoreBoard(query('#score_b'), query('#score_w')),
    new Alert(query('#alert')));
}
//	cb = query(".chessboard");            V
//	memo = query("#memo");                V
//	writeMemo("Black first");             V
//	black_score = query(".score_b");      V
//	white_score = query(".score_w");      V
//  chessboard = new Board;               V
//	initScore();                          V
//	DivElement canset =	cb.nodes[20];
//	canset.classes.add('can_set');
//	canset = cb.nodes[29];
//	canset.classes.add('can_set');
//	canset = cb.nodes[34];
//	canset.classes.add('can_set');
//	canset = cb.nodes[43];
//	canset.classes.add('can_set');	      V
//	cb.onClick.listen((MouseEvent evt) {
//		int x = ((evt.page.x - cb.offsetLeft) / 70).toInt();
//		int y = ((evt.page.y - cb.offsetTop) / 70).toInt();
//		print("x: $x");
//		print("y: $y");
//		clicked = cb.nodes[y * 8 + x];
//		int current_color;
//		times % 2 == 0? current_color = BLACK: current_color = WHITE;
//		if (x >= 0 && x <= 7 && y >= 0 && y <= 7 && canChess(current_color, x, y)){
//			setChess(x, y, current_color);
//			times++;
//		}
//	});
//}
//void initScore(){
//	black_score.text = ("2");
//	white_score.text = ("2");
//}
//
//void setChess(int x, int y, int color){
//	chessboard[x][y] = color;;
//	for(int i = 0; i < 8; i++){
//		if(x == 0 && (i == 0 || i == 1 || i == 7))
//			continue;
//		if(y == 0 && (i == 5 || i == 6 || i == 7))
//			continue;
//		if(x == 7 && (i == 3 || i == 4 || i == 5))
//			continue;
//		if(y == 7 && (i == 1 || i == 2 || i == 3))
//			continue;
//		reverse(i, x, y, color);
//	}
//	int num_can_set = 0;
//	int num_unset = 0;
//  blackscore = 0;
//  whitescore = 0;
//	DivElement can_set;
//	for (int i = 0; i < 8; i++) {
//		for (int j = 0; j < 8; j++){
//			if(chessboard[i][j] == null){	  				
//				num_unset++;
//				if(canChess(color == BLACK? WHITE: BLACK, i, j)){
//					can_set = cb.nodes[j * 8 + i];
//					can_set.classes.add('can_set');
//					num_can_set++;
//				}
//				else{
//					can_set = cb.nodes[j * 8 + i];
//					can_set.classes.remove('can_set');
//				}
//			}
//			else if(chessboard[i][j] == WHITE)
//				whitescore++;
//			else if(chessboard[i][j] == BLACK)
//				blackscore++;
//		}
//	}
//	black_score.text = ("$blackscore");
//	white_score.text = ("$whitescore");	
//	if(num_unset == 0)
//    endGame();
//  else if(num_can_set == 0) {
//		num_can_set = 0;
//		for (int i = 0; i < 8; i++) {
//			for (int j = 0; j < 8; j++){
//				if(chessboard[i][j] == null){	  				
//					num_unset++;
//					if(canChess(color == BLACK? BLACK: WHITE, i, j)){
//						can_set = cb.nodes[j * 8 + i];
//						can_set.classes.add('can_set');
//						num_can_set++;
//					}
//					else{
//						can_set = cb.nodes[j * 8 + i];
//						can_set.classes.remove('can_set');
//					}
//				}
//			}
//		}
//		if(num_can_set == 0) {
//			writeMemo("No one can set chess.");
//      endGame();
//		} else{
//			writeMemo("${color == BLACK? 'White': 'Black'} cannot set any chess.\n${color == BLACK? 'Black': 'White'}'s turn");
//			if(blackscore == 0 || whitescore == 0)
//        endGame();
//      times++;
//		}
//	} else{
//		writeMemo("${color == BLACK? 'White': 'Black'}'s turn");
//	}	
//}
//
//int blackscore, whitescore;
//
//void endGame(){
//    ButtonElement restart = query('.win');
//    restart.classes.add('restart');
//    if (blackscore > whitescore) winMemo(BLACK);
//    else if (blackscore == WHITE) writeMemo("Duce. Let's play again");
//    else winMemo(WHITE);    
//    restart.onClick.listen((MouseEvent evt){
//      winTimer.cancel();
//      restart.remove();
//      writeMemo("Please push F5");
//    });
//
//}
//void reverse(int direction, int x, int y, int color){
//	if(direction == UP){
//		int i = x-1;
//		if(chessboard[i][y] == null || chessboard[i][y] == color)
//			return;
//		for(i = i-1; i >= 0; i--){
//			if(chessboard[i][y] == null)
//				return;
//			if(chessboard[i][y] == color){
//				for(x = x-1; x > i; x--){
//					reverse_chess(color, x, y);
//					chessboard[x][y] = color;
//				}
//				return;			
//			}
//		}
//	}
//	else if(direction == UP_RIGHT){
//		int i = x-1;
//		int j = y+1;
//		if(chessboard[i][j] == null || chessboard[i][j] == color)
//			return;
//		i = i-1;
//		j = j+1;
//		for(; i >= 0 && j < 8 ; i--, j++){
//			if(chessboard[i][j] == null)
//				return;
//			if(chessboard[i][j] == color){
//				x = x-1;
//				y = y+1;
//				for(;x > i && y < j; x--, y++){
//					reverse_chess(color, x, y);
//					chessboard[x][y] = color;
//				}
//				return;			
//			}
//		}
//	}
//	else if(direction == RIGHT){
//		int j = y+1;
//		if(chessboard[x][j] == null || chessboard[x][j] == color)
//			return;
//		for(j = j+1; j < 8; j++){
//			if(chessboard[x][j] == null)
//				return;
//			if(chessboard[x][j] == color){
//				for(y = y+1; y < j; y++) {
//					reverse_chess(color, x, y);
//					chessboard[x][y] = color;
//				}
//				return;			
//			}
//		}
//	}
//	else if(direction == DOWN_RIGHT){
//		int i = x+1, j = y+1;
//		if(chessboard[i][j] == null || chessboard[i][j] == color)
//			return;
//		i = i+1;
//		j = j+1;
//		for(; i < 8 && j < 8; i++, j++){
//			if(chessboard[i][j] == null)
//				return;
//			if(chessboard[i][j] == color){
//				x = x+1;
//				y = y+1;
//				for(; x < i && y < j; x++, y++){
//					reverse_chess(color, x, y);
//					chessboard[x][y] = color;
//				}
//				return;			
//			}
//		}
//	}
//	else if(direction == DOWN){
//		int i = x+1;
//		if(chessboard[i][y] == null || chessboard[i][y] == color)
//			return;
//		for(i = i+1; i < 8; i++){
//			if(chessboard[i][y] == null)
//				return;
//			if(chessboard[i][y] == color){
//				for(x = x+1; x < i; x++){
//					reverse_chess(color, x, y);
//					chessboard[x][y] = color;
//				}	
//				return;			
//			}
//		}
//	}
//	else if(direction == DOWN_LEFT){
//		int i = x+1, j = y-1;
//		if(chessboard[i][j] == null || chessboard[i][j] == color)
//			return;
//		i = i+1;
//		j = j-1;
//		for(; i < 8 && j >= 0; i++, j--){
//			if(chessboard[i][j] == null)
//				return;
//			if(chessboard[i][j] == color){
//				x = x+1;
//				y = y-1;
//				for(; x < i && y > j; x++, y--){
//					reverse_chess(color, x, y);
//					chessboard[x][y] = color;
//				}
//				return;				
//			}
//		}
//	}	
//	else if(direction == LEFT){
//		int j = y-1;
//		if(chessboard[x][j] == null || chessboard[x][j] == color)
//			return;
//		for(j = j-1; j >= 0; j--){
//			if(chessboard[x][j] == null)
//				return;
//			if(chessboard[x][j] == color){
//				for(y = y-1; y > j; y--){
//					reverse_chess(color, x, y);
//					chessboard[x][y] = color;
//				}
//				return;				
//			}
//		}
//	}
//	else if(direction == UP_LEFT){
//		int i = x-1;
//		int j = y-1;
//		if(chessboard[i][j] == null || chessboard[i][j] == color)
//			return;
//		i = i-1;
//		j= j-1;
//		for(; i >= 0 && j>=0; i--, j--){
//			if(chessboard[i][j] == null)
//				return;
//			if(chessboard[i][j] == color){
//			  x = x-1;
//			  y = y-1;
//			  for( ;x > i && y > j; x--, y--){
//					reverse_chess(color, x, y);
//					chessboard[x][y] = color;
//				}
//				return;				
//			}
//		}
//	}
//}
//
//void reverse_chess(int to_color, int x, int y){
//	DivElement to_reverse = cb.nodes[y * 8 + x].nodes[0];
//	if(to_color == WHITE){
//		to_reverse.classes.add('wc');
//		to_reverse.classes.remove('bc');
//	}
//	if(to_color == BLACK){
//		to_reverse.classes.add('bc');
//		to_reverse.classes.remove('wc');
//	}
//	
//}
//
//bool canChess(int color, final int x, final int y){
//	int i, j;
//	if(chessboard[x][y] != null)
//		return false;
//	if(x >= 2){
//		i = x-1;
//		if(chessboard[i][y] == null || chessboard[i][y] == color)
//			;
//		else{
//			for(i = i-1; i >= 0; i--){
//				if(chessboard[i][y] == null)
//					break;
//				if(chessboard[i][y] == color)
//					return true;	
//			}
//		}
//	}
//	if(x >= 2 && y <= 5){
//		i = x-1;
//		j = y+1;
//		if(chessboard[i][j] == null || chessboard[i][j] == color)
//			;
//		else{
//			i = i-1;
//			j = j+1;
//			for(; i >= 0 && j < 8 ; i--, j++){
//				if(chessboard[i][j] == null)
//					break;
//				if(chessboard[i][j] == color)
//					return true;			
//			}
//		}
//	}
//	if(y <= 5){
//		j = y+1;
//		if(chessboard[x][j] == null || chessboard[x][j] == color)
//			;
//		else{
//			for(j = j+1; j < 8; j++){
//				if(chessboard[x][j] == null)
//					break;
//				if(chessboard[x][j] == color)
//					return true;			
//			}
//		}
//	}
//	if(y <= 5 && x <= 5){
//		i = x+1;
//		j = y+1;
//		if(chessboard[i][j] == null || chessboard[i][j] == color)
//			;
//		else{
//			i = i+1;
//			j = j+1;
//			for(; i < 8 && j < 8; i++, j++){
//				if(chessboard[i][j] == null)
//					break;
//				if(chessboard[i][j] == color)
//					return true;			
//			}
//		}
//	}
//	if(x <= 5){
//		i = x+1;
//		if(chessboard[i][y] == null || chessboard[i][y] == color)
//			;
//		else{
//			for(i = i+1; i < 8; i++){
//			if(chessboard[i][y] == null)
//				break;
//			if(chessboard[i][y] == color)
//				return true;
//			}
//		}
//	}
//	if(x <= 5 && y >= 2){
//		i = x+1;
//		j = y-1;
//		if(chessboard[i][j] == null || chessboard[i][j] == color)
//			;
//		else{
//			i = i+1;
//			j = j-1;
//			for(; i < 8 && j >= 0; i++, j--){
//				if(chessboard[i][j] == null)
//					break;
//				if(chessboard[i][j] == color)
//					return true;
//			}
//		}
//	}
//	if(y >= 2){
//		j = y-1;
//		if(chessboard[x][j] == null || chessboard[x][j] == color)
//			;
//		else{
//			for(j = j-1; j >= 0; j--){
//				if(chessboard[x][j] == null)
//					break;
//				if(chessboard[x][j] == color)
//					return true;
//			}
//		}
//	}
//	if(x>=2 && y >= 2){
//		i = x-1;
//		j = y-1;
//		if(chessboard[i][j] == null || chessboard[i][j] == color)
//			;
//		else{
//			i = i-1;
//			j= j-1;
//			for(; i >= 0 && j>=0; i--, j--){
//				if(chessboard[i][j] == null)
//					break;
//				if(chessboard[i][j] == color)
//					return true;
//			}
//		}
//	}
//	return false;	
//}
//
//void writeMemo(String text) {
//  cancelMemo();
//	memo.text = "";
//	int i = 0;
//	memoTimer = new Timer.periodic(new Duration(milliseconds: 120), (_) {
//		memo.text = "${text.substring(0, i)}_";
//		if(++i > text.length)
//		  cancelMemo();
//	});
//}
//void cancelMemo() {
//  if (memoTimer != null) {
//    memoTimer.cancel();
//    memoTimer = null;
//  }
//}
//Timer memoTimer;
//Timer winTimer;
//
//void winMemo(int color) {
//	String text1 ="""\\(>w<)/\\(>w<)/<br/><br/>&nbsp &nbsp &nbsp${color == BLACK? "Black": "White"}win<br/><br/>\\(>w<)/\\(>w<)/_""";
//	String text2 ="""|(>w<)\\/(>w<)|<br/><br/>&nbsp &nbsp &nbsp${color == BLACK? "Black": "White"}win<br/><br/>|(>w<)\\/(>w<)|""";
//	int i = 0;
//	winTimer = new Timer.periodic(new Duration(milliseconds: 110),(Timer timer) {
//		if(memoTimer == null){
//		  memo.innerHtml = i % 2 == 0 ? text1: text2;
//			i++;
//			if(i == 100)
//				i = 0;
//		}
//	});
//}