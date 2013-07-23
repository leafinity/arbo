import 'dart:html';

void main() {
	createboard();
}

void createboard() {
	DivElement cb = query("#chessboard");
	for (int i = 0; i < 8; i++) {
	  String horz = i == 0? "boardtop" : "";
	  int top = i * 70;
	  for (int j = 0; j < 8; j++) {
	  	String ver = j == 0? "boardleft" : "";
	  	int left = j * 70;
	  	if ((i == 4 && j ==4) || (i == 5 && j == 5))
	  	  cb.nodes.add(new Element.html('<div id = "ch_child $horz $ver" style = "left : ${left}px; top : ${top}px;"><div id = "bc"></div></div>'));

	  	if ((i == 4 && j ==5) || (i == 5 && j == 4))
	  	  cb.nodes.add(new Element.html('<div id = "ch_child" style = "left : ${left}px; top : ${top}px;"><div id = "wc"></div></div>'));
	  	else
	  	  cb.nodes.add(new Element.html('<div id = "ch_child $horz $ver" style = "left : ${left}px; top : ${top}px;"></div>'));

	  }
	}
}
