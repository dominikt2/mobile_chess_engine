import 'dart:math';
import 'game.dart';
import 'main.dart';
import 'evaluationValues.dart';

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

int miniMax(List<String> board, int depth, int alpha, int beta, bool isMaximizing) {
  if (depth == 0 || isCheckmate(board, true) || isCheckmate(board, false)) {
    return evaluateBoard(board);
  }

  if (isMaximizing) {
    int maxEval = -100000;
    for (int i = 0; i < 64; i++) {
      if (board[i] != ' ' && board[i] == board[i].toUpperCase()) {
        String currentPiece = board[i];
        for (int j = 0; j < 64; j++) {
          int moveResult = validateWhiteMoves(board, i, j, currentPiece);
          if (moveResult != 0) {
            List<String> newBoard = List<String>.from(board);
            temporarWhiteMove(i, j, newBoard, currentPiece);
            int eval = miniMax(newBoard, depth - 1, alpha, beta, false);
            maxEval = max(maxEval, eval);
            alpha = max(alpha, eval);
            if (beta <= alpha) {
              break;
            }
          }
        }
      }
    }
    return maxEval;
  } else {
    int minEval = 100000;
    for (int i = 0; i < 64; i++) {
      if (board[i] != ' ' && board[i] == board[i].toLowerCase()) {
        String currentPiece = board[i];
        for (int j = 0; j < 64; j++) {
          int moveResult = validateBlackMoves(board, i, j, currentPiece);
          if (moveResult != 0) {
            List<String> newBoard = List<String>.from(board);
            temporarBlackMove(i, j, newBoard, currentPiece);
            int eval = miniMax(newBoard, depth - 1, alpha, beta, true);
            minEval = min(minEval, eval);
            beta = min(beta, eval);
            if (beta <= alpha) {
              break;
            }
          }
        }
      }
    }
    return minEval;
  }
}
List<String> makeAImoveWhite(List<String> board, [int depth = 3]) {
  int maxEvaluation = -100000;
  int pieceIndex = 0;
  int moveIndex = 0;
  String piece = ' ';

  for(int i=0; i<64; i++) {
    if(board[i] != ' ' && !isLowercase(board[i])) {
      for(int j=0; j<64; j++) {
        if(validateWhiteMoves(board, i, j, board[i]) != 0) {
          List<String> newBoard = List<String>.from(board);
          temporarWhiteMove(i, j, newBoard, newBoard[i]);
          
          int evaluation = miniMax(newBoard, depth, -100000, 100000, false);
          
          if(evaluation > maxEvaluation) {
            maxEvaluation = evaluation;
            pieceIndex = i;
            moveIndex = j;
            piece = board[i];
          }
        }
      }
    }
  }
  
  print('Max evaluation: $maxEvaluation');
  
  isWhiteTurn = true;
  pickedUpAI = pieceIndex;
  placedAI = moveIndex;
  return makeWhiteMove(pieceIndex, moveIndex, piece);
}

List<String> makeAImoveBlack(List<String> board, [int depth = 3]) {
  int maxEvaluation = 100000;
  int pieceIndex = 0;
  int moveIndex = 0;
  String piece = ' ';

  for(int i=0; i<64; i++) {
    if(board[i] != ' ' && isLowercase(board[i])) {
      for(int j=0; j<64; j++) {
        if(validateBlackMoves(board, i, j, board[i]) != 0) {
          List<String> newBoard = List<String>.from(board);
          temporarBlackMove(i, j, newBoard, newBoard[i]);
          
          int evaluation = miniMax(newBoard, depth, -100000, 100000, true);
          
          if(evaluation < maxEvaluation) {
            maxEvaluation = evaluation;
            pieceIndex = i;
            moveIndex = j;
            piece = board[i];
          }
        }
      }
    }
  }
  
  print('Max evaluation: $maxEvaluation');
  
  isWhiteTurn = false;
  pickedUpAI = pieceIndex;
  placedAI = moveIndex;
  return makeBlackMove(pieceIndex, moveIndex, piece);
}


List<String> makeBlackMove(int pieceIndex, int moveIndex, String piece) {
  int moveResult = validateMove(pieceIndex, moveIndex, piece);
  if (moveResult != 0 && moveResult != 4 && moveResult != 5 && moveResult != 6) {
    board[moveIndex] = piece;
    board[pieceIndex] = ' ';
    if(board[moveIndex] == 'p' && moveIndex >= 56) {
      board[moveIndex] = 'q';
    }
    if (moveResult != 2) {
      clearEnPassant();
    }
    if (piece == 'k') {
      blackCastle[1] = 1;
    } else if (piece == 'r') {
      if (pieceIndex == 0) {
        blackCastle[0] = 1;
      } else if (pieceIndex == 7) {
        blackCastle[2] = 1;
      }
    }
    isWhiteTurn = !isWhiteTurn;
  } else if (moveResult == 4) {
    board[moveIndex] = piece;
    board[pieceIndex] = ' ';
    if (isWhiteTurn) {
      board[moveIndex + 8] = ' ';
    } else {
      board[moveIndex - 8] = ' ';
    }
    clearEnPassant();
    isWhiteTurn = !isWhiteTurn;
  } else if (moveResult == 5 || moveResult == 6) { 
    if (moveResult == 5) {
      blackCastle[1] = 1;
      board[moveIndex] = piece;
      board[moveIndex + 1] = board[moveIndex - 2];
      board[moveIndex - 2] = ' ';
      board[pieceIndex] = ' ';
    } else {
      blackCastle[1] = 1;
      board[moveIndex] = piece;
      board[moveIndex - 1] = board[moveIndex + 1];
      board[moveIndex + 1] = ' ';
      board[pieceIndex] = ' ';
    }
    isWhiteTurn = !isWhiteTurn;
    clearEnPassant();
  } else {
    board[pieceIndex] = piece;
  }
  return board;
}
List<String> makeWhiteMove(int pieceIndex, int moveIndex, String piece) {
  int moveResult = validateMove(pieceIndex, moveIndex, piece);
  if (moveResult != 0 && moveResult != 4 && moveResult != 5 && moveResult != 6) {
    board[moveIndex] = piece;
    board[pieceIndex] = ' ';
    if(board[moveIndex] == 'P' && moveIndex <= 7) {
      board[moveIndex] = 'Q';
    }
    if (moveResult != 2) {
      clearEnPassant();
    }
    if (piece == 'K') {
      whiteCastle[1] = 1;
    } else if (piece == 'R') {
      if (pieceIndex == 56) {
        whiteCastle[0] = 1;
      } else if (pieceIndex == 63) {
        whiteCastle[2] = 1;
      }
    }
    isWhiteTurn = !isWhiteTurn;
  } else if (moveResult == 4) {
    board[moveIndex] = piece;
    board[pieceIndex] = ' ';
    if (isWhiteTurn) {
      board[moveIndex + 8] = ' ';
    } else {
      board[moveIndex - 8] = ' ';
    }
    clearEnPassant();
    isWhiteTurn = !isWhiteTurn;
  } else if (moveResult == 5 || moveResult == 6) { 
    if (moveResult == 5) {
      whiteCastle[1] = 1;
      board[moveIndex] = piece;
      board[moveIndex + 1] = board[moveIndex - 2];
      board[moveIndex - 2] = ' ';
      board[pieceIndex] = ' ';
    } else {
      whiteCastle[1] = 1;
      board[moveIndex] = piece;
      board[moveIndex - 1] = board[moveIndex + 1];
      board[moveIndex + 1] = ' ';
      board[pieceIndex] = ' ';
    }
    isWhiteTurn = !isWhiteTurn;
    clearEnPassant();
  } else {
    board[pieceIndex] = piece;
  }
  return board;
}



void temporarBlackMove(int pieceIndex, int moveIndex, List<String> board, String piece) {
  int result = validateBlackMoves(board, pieceIndex, moveIndex, piece);
  if(result !=0 && result !=4 && result !=5){
    board[moveIndex] = board[pieceIndex];
    board[pieceIndex] = ' ';
    if(board[moveIndex] == 'p' && moveIndex >= 56) {
      board[moveIndex] = 'q';
    }
  }else if(result == 4){
    board[moveIndex] = board[pieceIndex];
    board[pieceIndex] = ' ';
    board[moveIndex-8] = ' ';
  }else if(result == 5){
    board[moveIndex] = piece;
    board[moveIndex+1] = board[moveIndex-2];
    board[moveIndex-2] = ' ';
    board[pieceIndex] = ' ';
  }else if(result == 6){
    board[moveIndex] = piece;
    board[moveIndex-1] = board[moveIndex+1];
    board[moveIndex+1] = ' ';
    board[pieceIndex] = ' ';
  }
}

void temporarWhiteMove(int pieceIndex, int moveIndex, List<String> board, String piece) {
  int result = validateWhiteMoves(board, pieceIndex, moveIndex, piece);
  if(result !=0 && result !=4 && result !=5){
    board[moveIndex] = board[pieceIndex];
    board[pieceIndex] = ' ';
  }else if(result == 4){
    board[moveIndex] = board[pieceIndex];
    board[pieceIndex] = ' ';
    board[moveIndex+8] = ' ';
  }else if(result == 5){
    board[moveIndex] = piece;
    board[moveIndex+1] = board[moveIndex-2];
    board[moveIndex-2] = ' ';
    board[pieceIndex] = ' ';
  }else if(result == 6){
    board[moveIndex] = piece;
    board[moveIndex-1] = board[moveIndex+1];
    board[moveIndex+1] = ' ';
    board[pieceIndex] = ' ';
  }
}
