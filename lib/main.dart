import 'package:chess_web/trebfish.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import 'dart:math';


void main() {
  runApp(const MyApp());
}

Map<int, int> positionsByDepth = {};
int totalPositions = 0;

String piece = '';
int pieceIndex = -1;
int moveIndex = -1;
List<int> highlightedSquares = []; 
String player = 'w'; 
int switchCount = 0;
String playerfroAI = 'w';

bool drop = false;
bool castledWhite = false;
bool castledBlack = false;

int pickedUpAI = -1;
int placedAI = -1;
double pickedUpX = -1;
double pickedUpY = -1;
double placedX = -1;
double placedY = -1;

int aiSearchDepth = 1;

var boardInitial = List<String>.from([
    'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r',
  'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
  ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
  ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
  ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
  ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
  'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
  'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R',
]);



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double x = 0.0;
  double y = 0.0;


  static const double minBoardSize = 450.0;
  static const double maxBoardSize = 700.0;


  void _pickUpPiece(int index) {
    setState(() {
      x = (index % 8).toDouble();
      y = (index ~/ 8).toDouble();
      pickedUpX = x;
      pickedUpY = y;
      
      piece = board[index];
      pieceIndex = index;
      board[index] = ' ';

      if(drop == false){
        board[index] = piece;
      }
      drop = false;
     updateHighlightedSquares(index, piece);
    });
  }
  
void switchPlayer() {
  setState(() {
    switchCount++;
    if (player == 'w') {
      player = 'b';
    } else {
      player = 'w';
    }
    if(switchCount < 1){
      playerfroAI = player;
    }else if(switchCount == 1 && playerfroAI == 'w'){
      playerfroAI = 'b';
    }
  });
  
  if(switchCount < 2 && player == 'b'){
    Future.delayed(const Duration(milliseconds: 750), () {
      setState(() {
        board = makeAImoveWhite(board, aiSearchDepth);
      });
    });
  }
}

int detectPlayer(int row, int col) {
  if (player == 'w') {
    return row * 8 + col; 
  } else {
    return (7 - row) * 8 + (7 - col);
  }
}
void _dropPiece(int index) {
      
  setState(() {
    x = (index % 8).toDouble();
    y = (index ~/ 8).toDouble();
    moveIndex = index;
    placedX = x;
    placedY = y;

    if (pieceIndex != moveIndex) {
      if(makeMove(pieceIndex, moveIndex, piece) != false){
        drop = false;
        highlightedSquares.clear();
        pickedUpAI = -1;
        placedAI = -1;
        aIMove();
        if(isCheckmate(board, isWhiteTurn)){
          print('Checkmate!');
        }
      } else {
        board[pieceIndex] = piece;
        highlightedSquares.clear();

        pickedUpX = -1;
        pickedUpY = -1;
        placedX = -1;
        placedY = -1;
      }
    } else {
      board[index] = piece;
      drop = false;
      highlightedSquares.clear();

      pickedUpX = -1;
      pickedUpY = -1;
      placedX = -1;
      placedY = -1;
    }
  });
}
void aIMove(){
    Future.delayed(const Duration(milliseconds: 750), () {
    setState(() {
      if (pieceIndex != moveIndex) {
        if(player == 'w'){
          board = makeAImoveBlack(board, aiSearchDepth);
        }else{
          board = makeAImoveWhite(board, aiSearchDepth);
        }
        placedX = -1;
        placedY = -1;
        pickedUpX = -1;
        pickedUpY = -1;
        if(isCheckmate(board, isWhiteTurn)){
          print('Checkmate!');
        }
      }
    });
  });
}

  void updateHighlightedSquares(int selectedIndex, String piece) {
    highlightedSquares.clear();

    for (int i = 0; i < 64; i++) {
      if (validateMove(selectedIndex, i, piece) != 0) {
        highlightedSquares.add(i);
      }
    }
  }
Color squareColor(int index) {
  int row = index ~/ 8;
  int col = index % 8;
  bool isLightSquare = (row + col) % 2 == 0;

  if (highlightedSquares.contains(index)) {
    return isLightSquare ? Colors.greenAccent[200]! : Colors.greenAccent[700]!;
  }

  int whiteKingIndex = getKingIndex("K", board);
  int blackKingIndex = getKingIndex("k", board);

  if (isKingChecked(whiteKingIndex, board, isWhiteTurn) && index == whiteKingIndex) {
    return isLightSquare ? const Color.fromARGB(255, 255, 21, 0) : const Color.fromARGB(255, 255, 0, 0);
  }

  if (isKingChecked(blackKingIndex, board, isWhiteTurn) && index == blackKingIndex) {
     return isLightSquare ? const Color.fromARGB(255, 255, 21, 0) : const Color.fromARGB(255, 255, 0, 0);
  }

  if ((row == pickedUpY && col == pickedUpX) || (row == placedY && col == placedX)) {
    return isLightSquare
        ? const Color.fromARGB(255, 189, 222, 255)
        : const Color.fromARGB(255, 137, 170, 227);
  } else if (pickedUpAI == index || placedAI == index) {
    return isLightSquare
        ? const Color.fromARGB(255, 189, 222, 255)
        : const Color.fromARGB(255, 137, 170, 227);
  }

  return isLightSquare ? const Color(0xFFEEEED2) : const Color(0xFF769656);
}

int getKingIndex(String king, List<String> board) {
  for (int i = 0; i < 64; i++) {
    if (board[i] == king) {
      return i;
    }
  }
  return -1;
}

  String getPieceImageName(String piece) {
    if (piece == ' ') return ' '; 
    if (piece != piece.toLowerCase()) return piece; 
    return 'b$piece'; 
  }

@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar:  AppBar(
        title: Text('SACHY'),
      ),
      backgroundColor: const Color.fromARGB(255, 202, 193, 193),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'AI Search Depth: $aiSearchDepth',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [1, 2, 3, 4, 5].map((depth) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                aiSearchDepth = depth;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: aiSearchDepth == depth 
                                  ? Colors.blue 
                                  : Colors.grey,
                            ),
                            child: Text(depth.toString()),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          board = List<String>.from(boardInitial);
                          switchCount = 0;
                          resetGame();
                          if (player == 'b') {
                          Future.delayed(const Duration(milliseconds: 750), () {
                            setState(() {
                              board = makeAImoveWhite(board, aiSearchDepth);
                            });
                              
                            });
                        }
                        });
                      },
                      child: const Text('RESET GAME'), 
                    ),
                  ],
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final boardSize = Size(
                    constraints.maxWidth * 0.7,
                    constraints.maxWidth * 0.7,
                  );

                  final adjustedSize = Size(
                    boardSize.width.clamp(minBoardSize, maxBoardSize),
                    boardSize.height.clamp(minBoardSize, maxBoardSize),
                  );
                  return SizedBox(
                    width: adjustedSize.width,
                    height: adjustedSize.height,
                    child: Stack(
                      children: [
                        GridView.builder(
                          itemCount: 64,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8,
                            childAspectRatio: 1.0,
                          ),
                          itemBuilder: (context, index) {
                            int row = index ~/ 8;
                            int col = index % 8;
                            index = detectPlayer(row, col);
                            return DragTarget<String>(
                              onWillAcceptWithDetails: (data) => true,
                              onAcceptWithDetails: (data) => _dropPiece(index),
                              builder: (context, candidateData, rejectedData) {
                                return Container(
                                  color: squareColor(index),
                                  child: board[index] != ' '
                                      ? Draggable<String>(
                                          data: '$index',
                                          onDragStarted: () => _pickUpPiece(index),
                                          feedback: SizedBox(
                                            width: adjustedSize.width / 8,
                                            height: adjustedSize.height / 8,
                                            child: Image.asset(                                   
                                              'assets/${getPieceImageName(board[index])}.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          childWhenDragging: const SizedBox.shrink(),
                                          child: Image.asset(
                                            'assets/${getPieceImageName(board[index])}.png',
                                            width: adjustedSize.width / 8,
                                            height: adjustedSize.height / 8,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Current Player: ${player == 'w' ? 'White' : 'Black'}',
                    ),
                    ElevatedButton(
                      onPressed: switchPlayer,
                      child: const Text('Switch Player'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
