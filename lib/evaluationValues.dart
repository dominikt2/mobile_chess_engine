import 'game.dart';


int evaluateBoard(List<String> board) {
  int blackAdvantage = 0;
  int whiteAdvantage = 0;

  if (isCheckmate(board, true)) {
    return -100000; // WYGRANA CZARNYCH
  }
  if (isCheckmate(board, false)) {
    return 100000;  // WYGRANA BIALYCH
  }
  
  for (int i = 0; i < 64; i++) {
    String piece = board[i];
    if (piece == ' ') {
      continue;
    }

    if (piece == 'P') {
      whiteAdvantage += 100 + whitePawnBestPosition[i];
    } else if (piece == 'R') {
      whiteAdvantage += 500 + whiteRookBestPosition[i];
    } else if (piece == 'N') {
      whiteAdvantage += 300 + knightBestPosition[i];
    } else if (piece == 'B') {
      whiteAdvantage += 300 + bishopBestPosition[i];
    } else if (piece == 'Q') {
      whiteAdvantage += 900 + queenBestPosition[i];
    } else if (piece == 'K') {
      if(!isEndGame(board)){
        whiteAdvantage += 1000 + whiteKingBestPosition[i];
      }else{
        whiteAdvantage += 1000 + whiteKingEndgamePosition[i];
      }
    } else if (piece == 'p') {
      blackAdvantage += 100 + blackPawnBestPosition[i];
    } else if (piece == 'r') {
      blackAdvantage += 500 + blackRookBestPosition[i];
    } else if (piece == 'n') {
      blackAdvantage += 300 + knightBestPosition[i];
    } else if (piece == 'b') {
      blackAdvantage += 300 + bishopBestPosition[i];
    } else if (piece == 'q') {
      blackAdvantage += 900 + queenBestPosition[i];
    } else if (piece == 'k') {
      if(!isEndGame(board)){
        blackAdvantage += 1000 + blackKingBestPosition[i];
      }else{
        blackAdvantage += 1000 + blackKingEndgamePosition[i];
      }
    }
  }
  return (whiteAdvantage - blackAdvantage);
}

bool isEndGame(List<String> board) {
  int whiteMinor = 0;
  int blackMinor = 0;
  int whiteMajor = 0;
  int blackMajor = 0;

  final minorPieces = ['N', 'B'];
  final majorPieces = ['R', 'Q'];

  for (String piece in board) {
    if (piece.toUpperCase() == piece) {
      if (minorPieces.contains(piece)) whiteMinor++;
      if (majorPieces.contains(piece)) whiteMajor++;
    } 
    else {
      final upperPiece = piece.toUpperCase();
      if (minorPieces.contains(upperPiece)) blackMinor++;
      if (majorPieces.contains(upperPiece)) blackMajor++;
    }
  }

  bool noMajorPieces = whiteMajor == 0 && blackMajor == 0;
  bool limitedMinorPieces = (whiteMinor + blackMinor) <= 2;
  
  return noMajorPieces || limitedMinorPieces;
}
 List<int> whitePawnBestPosition = [
    50, 50, 50, 50, 50, 50, 50, 50,
    50, 50, 50, 50, 50, 50, 50, 50,
    10, 10, 20, 30, 30, 20, 10, 10,
    5, 5, 10, 25, 25, 10, 5, 5,
    0, 0, 0, 25, 25, 0, 0, 0,
    5, -5, -10, 0, 0, -10, -5, 5,
    5, 10, 10, -20, -20, 10, 10, 5,
    0, 0, 0, 0, 0, 0, 0, 0
  ];

   List<int> blackPawnBestPosition = [
    0, 0, 0, 0, 0, 0, 0, 0,
    5, 10, 10, -20, -20, 10, 10, 5,
    5, -5, -10, 0, 0, -10, -5, 5,
    0, 0, 0, 20, 20, 0, 0, 0,
    5, 5, 10, 25, 25, 10, 5, 5,
    10, 10, 20, 30, 30, 20, 10, 10,
    50, 50, 50, 50, 50, 50, 50, 50,
    50, 50, 50, 50, 50, 50, 50, 50
  ];

   List<int> knightBestPosition = [
    -50, -40, -30, -30, -30, -30, -40, -50,
    -40, -20, 0, 5, 5, 0, -20, -40,
    -30, 5, 15, 20, 20, 15, 5, -30,
    -30, 10, 20, 25, 25, 20, 10, -30,
    -30, 5, 20, 25, 25, 20, 5, -30,
    -30, 10, 15, 20, 20, 15, 10, -30,
    -40, -20, 5, 10, 10, 5, -20, -40,
    -50, -40, -30, -30, -30, -30, -40, -50
  ];

   List<int> bishopBestPosition = [
    -20, -10, -10, -10, -10, -10, -10, -20,
    -10, 0, 0, 5, 5, 0, 0, -10,
    -10, 0, 10, 15, 15, 10, 0, -10,
    -10, 5, 10, 20, 20, 10, 5, -10,
    -10, 0, 15, 20, 20, 15, 0, -10,
    -10, 10, 10, 15, 15, 10, 10, -10,
    -10, 0, 5, 5, 5, 5, 0, -10,
    -20, -10, -10, -10, -10, -10, -10, -20
  ];

   List<int> whiteRookBestPosition = [
    0, 0, 0, 0, 0, 0, 0, 0,
    5, 10, 10, 10, 10, 10, 10, 5,
    -5, 0, 0, 0, 0, 0, 0, -5,
    -5, 0, 0, 0, 0, 0, 0, -5,
    -5, 0, 0, 0, 0, 0, 0, -5,
    -5, 0, 0, 0, 0, 0, 0, -5,
    -5, 0, 0, 0, 0, 0, 0, -5,
    0, 0, 0, 5, 5, 0, 0, 0
  ];

   List<int> blackRookBestPosition = [
    0, 0, 0, 5, 5, 0, 0, 0,
    -5, 0, 0, 0, 0, 0, 0, -5,
    -5, 0, 0, 0, 0, 0, 0, -5,
    -5, 0, 0, 0, 0, 0, 0, -5,
    -5, 0, 0, 0, 0, 0, 0, -5,
    -5, 0, 0, 0, 0, 0, 0, -5,
    5, 10, 10, 10, 10, 10, 10, 5,
    0, 0, 0, 0, 0, 0, 0, 0
  ];

   List<int> queenBestPosition = [
    -20, -10, -10, -5, -5, -10, -10, -20,
    -10, 0, 0, 0, 0, 0, 0, -10,
    -10, 0, 5, 5, 5, 5, 0, -10,
    -5, 0, 5, 5, 5, 5, 0, -5,
    -5, 0, 5, 5, 5, 5, 0, -5,
    -10, 0, 5, 5, 5, 5, 0, -10,
    -10, 0, 0, 0, 0, 0, 0, -10,
    -20, -10, -10, -5, -5, -10, -10, -20
  ];

  List<int> whiteKingBestPosition = [
    -30, -40, -40, -50, -50, -40, -40, -30,
    -30, -40, -40, -50, -50, -40, -40, -30,
    -30, -40, -40, -50, -50, -40, -40, -30,
    -30, -40, -40, -50, -50, -40, -40, -30,
    -20, -30, -30, -40, -40, -30, -30, -20,
    -10, -20, -20, -20, -20, -20, -20, -10,
    20, 20, 0, 0, 0, 0, 20, 20,
    20, 30, 10, 0, 0, 10, 30, 20
  ];

  List<int> whiteKingEndgamePosition = [
    -50, -30, -30, -30, -30, -30, -30, -50,
    -30, -20, -10, -10, -10, -10, -20, -30,
    -30, -10, 20, 30, 30, 20, -10, -30,
    -30, -10, 30, 40, 40, 30, -10, -30,
    -30, -10, 30, 40, 40, 30, -10, -30,
    -30, -10, 20, 30, 30, 20, -10, -30,
    -30, -20, -10, -10, -10, -10, -20, -30,
    -50, -30, -30, -30, -30, -30, -30, -50
  ];


   List<int> blackKingBestPosition = [
    20, 30, 10, 0, 0, 10, 30, 20,
    20, 20, 0, 0, 0, 0, 20, 20,
    -10, -20, -20, -20, -20, -20, -20, -10,
    -20, -30, -30, -40, -40, -30, -30, -20,
    -30, -40, -40, -50, -50, -40, -40, -30,
    -30, -40, -40, -50, -50, -40, -40, -30,
    -30, -40, -40, -50, -50, -40, -40, -30,
    -30, -40, -40, -50, -50, -40, -40, -30
  ];

  List<int> blackKingEndgamePosition = [
    -50, -30, -30, -30, -30, -30, -30, -50,
    -30, -20, -10, -10, -10, -10, -20, -30,
    -30, -10, 20, 30, 30, 20, -10, -30,
    -30, -10, 30, 40, 40, 30, -10, -30,
    -30, -10, 30, 40, 40, 30, -10, -30,
    -30, -10, 20, 30, 30, 20, -10, -30,
    -30, -20, -10, -10, -10, -10, -20, -30,
    -50, -30, -30, -30, -30, -30, -30, -50
];

