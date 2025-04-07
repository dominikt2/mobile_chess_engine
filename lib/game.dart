import 'package:chess_web/main.dart';
import 'package:chess_web/trebfish.dart';
import 'main.dart';

var board = List<String>.from([
  'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r',
  'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
  ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
  ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
  ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
  ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
  'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
  'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R',
]);

var whiteEnPassant = List<int>.filled(2,0);
var blackEnPassant = List<int>.filled(2,0);
var whiteCastle = List<int>.filled(3,0);
var blackCastle = List<int>.filled(3,0);

bool isWhiteTurn = true;

bool isLowercase(String str) {
  return str == str.toLowerCase();
}

// 1, 2, 3 - ruch, 4 - bicie w przelocie, 5 - roszada dluga, 6 - roszada krotka


bool makeMove(int pieceIndex, int moveIndex, String piece){
  int moveResult = validateMove(pieceIndex, moveIndex, piece);
  if(moveResult !=0 && moveResult != 4 && moveResult != 5 && moveResult != 6){    
    board[moveIndex] = piece;
    board[pieceIndex] = ' ';
    if(moveResult !=2){
      clearEnPassant();
    }
    if(piece == 'K'){
      whiteCastle[1] = 1;
    }else if(piece == 'R'){
      if(pieceIndex == 56){
        whiteCastle[0] = 1;
      }else if(pieceIndex == 63){
        whiteCastle[2] = 1;
      }
    }else if(piece == 'k'){
      blackCastle[1] = 1;
    }else if(piece == 'r'){
      if(pieceIndex == 0){
        blackCastle[0] = 1;
      }else if(pieceIndex == 7){
        blackCastle[2] = 1;
      }
    }
    isWhiteTurn = !isWhiteTurn;
    return true;  
  }else if(moveResult == 4){ //en passant pionami
    board[moveIndex] = piece;
    board[pieceIndex] = ' ';
    if(isWhiteTurn){
      board[moveIndex+8] = ' ';
    }else{
      board[moveIndex-8] = ' ';
    }
    clearEnPassant();
    isWhiteTurn = !isWhiteTurn;
    return true; 
  }else if(moveResult == 5 || moveResult == 6){ //roszada dluga
    if(moveResult == 5){
      if(piece == 'K'){
        whiteCastle[1] = 1;
      }else{
        blackCastle[1] = 1;
      }
      board[moveIndex] = piece;
      board[moveIndex+1] = board[moveIndex-2];
      board[moveIndex-2] = ' ';
      board[pieceIndex] = ' ';
    }else{
      if(piece == 'K'){
        whiteCastle[1] = 1;
      }else{
        blackCastle[1] = 1;
      }
      board[moveIndex] = piece;
      board[moveIndex-1] = board[moveIndex+1];
      board[moveIndex+1] = ' ';
      board[pieceIndex] = ' ';
    }
    isWhiteTurn = !isWhiteTurn;
    clearEnPassant();
    return true;  
  }
  else{
    board[pieceIndex] = piece;
    return false;
  }
}

int validateMove(int pieceIndex, int moveIndex, String piece){
  if(pieceIndex == moveIndex){
    return 0;
  }
  if(!isLowercase(piece)){
    if(isWhiteTurn && validateWhiteMoves(board, pieceIndex, moveIndex, piece) != 0){
      return validateWhiteMoves(board,pieceIndex, moveIndex, piece);
    }
  }else{
    if(isWhiteTurn == false && validateBlackMoves(board, pieceIndex, moveIndex, piece) != 0){
      return validateBlackMoves(board, pieceIndex, moveIndex, piece);
    }
  }
  return 0;
}

int validateWhiteMoves(List<String> board, int pieceIndex, int moveIndex, String piece){;
  if(piece == 'P'){
    if(pawnMove(pieceIndex, moveIndex, piece, board) == 4 && canPawnEnPassant(pieceIndex, moveIndex, isWhiteTurn)){
      return pawnMove(pieceIndex, moveIndex, piece, board);
    }else if(pawnMove(pieceIndex, moveIndex, piece, board) != 0 && pawnMove(pieceIndex, moveIndex, piece, board) != 4 && canPieceMove(pieceIndex, moveIndex, piece, board)){
      return pawnMove(pieceIndex, moveIndex, piece, board);
    }
  }else if(piece == 'N' && knightMove(pieceIndex, moveIndex, piece, board) && canPieceMove(pieceIndex, moveIndex, piece, board)){
    return 1;
  }else if(piece == 'B' && diagonalMove(pieceIndex, moveIndex, piece, board) && canPieceMove(pieceIndex, moveIndex, piece, board)){
    return 1;
  }else if(piece == 'R' && (horizontalMove(pieceIndex, moveIndex, piece, board) || verticalMove(pieceIndex, moveIndex, piece, board)) && canPieceMove(pieceIndex, moveIndex, piece, board)){
     return 1;
  }else if(piece == 'Q' && (horizontalMove(pieceIndex, moveIndex, piece, board) || verticalMove(pieceIndex, moveIndex, piece, board) || diagonalMove(pieceIndex, moveIndex, piece, board)) && canPieceMove(pieceIndex, moveIndex, piece, board)){
    return 1;
  }else if(piece == 'K'){
    if(kingMove(pieceIndex, moveIndex, piece, board) != 0 && canPieceMove(pieceIndex, moveIndex, piece, board)){
      return kingMove(pieceIndex, moveIndex, piece, board);
    }
  }
  return 0;
}

int validateBlackMoves(List<String> board, int pieceIndex, int moveIndex, String piece){
  if(piece == 'p'){
    if(pawnMove(pieceIndex, moveIndex, piece, board) == 4 && canPawnEnPassant(pieceIndex, moveIndex, isWhiteTurn)){
      return pawnMove(pieceIndex, moveIndex, piece, board);
    }else if(pawnMove(pieceIndex, moveIndex, piece, board) !=0 && pawnMove(pieceIndex, moveIndex, piece, board) != 4 && canPieceMove(pieceIndex, moveIndex, piece, board)){
      return pawnMove(pieceIndex, moveIndex, piece, board);
    }
  }else if(piece == 'n' && knightMove(pieceIndex, moveIndex, piece, board) && canPieceMove(pieceIndex, moveIndex, piece, board)){
    return 1;
  }else if(piece == 'b' && diagonalMove(pieceIndex, moveIndex, piece, board) && canPieceMove(pieceIndex, moveIndex, piece, board)){
    return 1;
  }else if(piece == 'r' && (horizontalMove(pieceIndex, moveIndex, piece, board) || verticalMove(pieceIndex, moveIndex, piece, board)) && canPieceMove(pieceIndex, moveIndex, piece, board)){
    return 1;
  }else if(piece == 'q' && (horizontalMove(pieceIndex, moveIndex, piece, board) || verticalMove(pieceIndex, moveIndex, piece, board) || diagonalMove(pieceIndex, moveIndex, piece, board)) && canPieceMove(pieceIndex, moveIndex, piece, board)){
    return 1;
  }else if(piece == 'k'){
    if(kingMove(pieceIndex, moveIndex, piece, board) != 0 && canPieceMove(pieceIndex, moveIndex, piece, board)){
      return kingMove(pieceIndex, moveIndex, piece, board);
    }
  }
  return 0;
}




int pawnMove(int pieceIndex, int moveIndex, String piece, List<String> board){
  if(piece == 'P'){ // bialy
    if(moveIndex ~/ 8 == pieceIndex ~/ 8 - 1 && moveIndex % 8 == pieceIndex % 8 && board[moveIndex] == ' '){ //ruch o 1 pole
      return 1;
    }else if((pieceIndex <= 55 && pieceIndex >= 48) && pieceIndex - 16 == moveIndex && board[moveIndex] == ' ' && board[pieceIndex-8] == ' '){ //ruch o 2 pola
      blackEnPassant[0] = 1;
      blackEnPassant[1] = moveIndex;
      return 2;
    }else if((pieceIndex - 9 == moveIndex || pieceIndex - 7 == moveIndex) && moveIndex ~/ 8 == pieceIndex ~/ 8 - 1 && isLowercase(board[moveIndex]) && board[moveIndex] != ' '){ //bicie
      return 3;
    }else if((pieceIndex >= 24 && pieceIndex <= 31) && whiteEnPassant[0] == 1 && whiteEnPassant[1]-8 == moveIndex && (pieceIndex - 1 == whiteEnPassant[1] || pieceIndex + 1 == whiteEnPassant[1])){ // bicie w przelocie
      return 4;
    }
  }else{ // czarny
    if(moveIndex ~/ 8 == pieceIndex ~/ 8 + 1 && moveIndex % 8 == pieceIndex % 8 && board[moveIndex] == ' '){ //ruch o 1 pole
      return 1;
    }else if((pieceIndex <= 15 && pieceIndex >= 8) && pieceIndex + 16 == moveIndex && board[moveIndex] == ' ' && board[pieceIndex+8] == ' '){ //ruch o 2 pola
      whiteEnPassant[0] = 1;
      whiteEnPassant[1] = moveIndex;
      return 2;
    }else if((pieceIndex + 9 == moveIndex || pieceIndex + 7 == moveIndex) && moveIndex ~/ 8 == pieceIndex ~/ 8 + 1 && !isLowercase(board[moveIndex])){ //bicie
      return 3;
}
else if((pieceIndex >= 32 && pieceIndex <= 39) && blackEnPassant[0] == 1 && blackEnPassant[1]+8 == moveIndex && (pieceIndex - 1 == blackEnPassant[1] || pieceIndex + 1 == blackEnPassant[1])){ // bicie w przelocie
      return 4;
    }
  }
  return 0;
}

bool knightMove(int pieceIndex, int moveIndex, String piece, List<String> board) {
  int rowDiff = (pieceIndex ~/ 8 - moveIndex ~/ 8).abs();
  int colDiff = (pieceIndex % 8 - moveIndex % 8).abs();

  if ((rowDiff == 2 && colDiff == 1) || (rowDiff == 1 && colDiff == 2)) {
    if (board[moveIndex] == ' ' || (isLowercase(piece) != isLowercase(board[moveIndex]))) {
      return true;
    }
  }
  return false;
}

bool diagonalMove(int pieceIndex, int moveIndex, String piece, List<String> board) {
  int rowDiff = (pieceIndex ~/ 8 - moveIndex ~/ 8).abs();
  int colDiff = (pieceIndex % 8 - moveIndex % 8).abs();

  if(rowDiff == colDiff){
    int rowDirection = (moveIndex ~/ 8) > (pieceIndex ~/ 8) ? 1 : -1;
    int colDirection = (moveIndex % 8) > (pieceIndex % 8) ? 1 : -1;

    int currentRow = pieceIndex ~/ 8 + rowDirection;
    int currentCol = pieceIndex % 8 + colDirection;

     while (currentRow != moveIndex ~/ 8 || currentCol != moveIndex % 8) {
        int currentIndex = currentRow * 8 + currentCol;
        if (currentIndex < 0 || currentIndex >= 64 || board[currentIndex] != ' ') {
             return false;
        }
      currentRow += rowDirection;
      currentCol += colDirection;
    }
    if(board[moveIndex] == ' ' || (isLowercase(piece) != isLowercase(board[moveIndex]))){
      return true;
    }
  }

  return false;
}

bool horizontalMove(int pieceIndex, int moveIndex, String piece, List<String> board) {
  if (pieceIndex ~/ 8 == moveIndex ~/ 8) {
            if (pieceIndex < moveIndex) {
                for (int i = pieceIndex + 1; i < moveIndex; i++) {
                    if (board[i] != ' ') {
                        return false;
                    }
                }
            } else if (pieceIndex > moveIndex) {
                for (int i = pieceIndex - 1; i > moveIndex; i--) {
                    if (board[i] != ' ') {
                        return false;
                    }
                }
            }
            if (board[moveIndex] == ' ' || isLowercase(piece) != isLowercase(board[moveIndex])) {
                return true;
            }
    }
    return false;
}

bool verticalMove(int pieceIndex, int moveIndex, String piece, List<String> board) {
  if (pieceIndex % 8 == moveIndex % 8) {
    if (pieceIndex < moveIndex) {
        for (int i = pieceIndex + 8; i < moveIndex; i += 8) {
            if (board[i] != ' ') {
                return false;
            }
         }
    } else if (pieceIndex > moveIndex) {
         for (int i = pieceIndex - 8; i > moveIndex; i -= 8) {
            if (board[i] != ' ') {
                return false;
             }
        }
    }
    if (board[moveIndex] == ' ' || isLowercase(piece) != isLowercase(board[moveIndex])) {
         return true;
     }
  }
  return false;
}

int kingMove(int pieceIndex, int moveIndex, String piece, List<String> board){
  if((pieceIndex ~/ 8 - moveIndex ~/ 8).abs() <= 1 && (pieceIndex % 8 - moveIndex % 8).abs() <= 1){
    if(board[moveIndex] == ' ' || (isLowercase(piece) != isLowercase(board[moveIndex]))){
      return 1;
    }
  }else if((whiteCastle[0] == 0 && whiteCastle[1] == 0) && pieceIndex == 60 && moveIndex == 58 && board[59] == ' ' && board[58] == ' ' &&  board[57] == ' ' && board[56] == 'R' && (!isKingChecked(60, board, true) && !isKingChecked(59, board, true) && !isKingChecked(58, board, true))){
      return 5;
  }else if((whiteCastle[1] == 0 && whiteCastle[2] == 0) && pieceIndex == 60 && moveIndex == 62 && board[61] == ' ' && board[62] == ' ' && board[63] == 'R' && (!isKingChecked(60, board, true) && !isKingChecked(61, board, true) && !isKingChecked(62, board, true))){
      return 6;
  }else if((blackCastle[0] == 0 && blackCastle[1] == 0) && pieceIndex == 4 && moveIndex == 2 && board[3] == ' ' && board[2] == ' ' &&  board[1] == ' ' && board[0] == 'r' && (!isKingChecked(4, board, false) && !isKingChecked(3, board, false) && !isKingChecked(2, board, false))){
      return 5;
  }else if((blackCastle[1] == 0 && blackCastle[2] == 0) && pieceIndex == 4 && moveIndex == 6 && board[5] == ' ' && board[6] == ' ' && board[7] == 'r' && (!isKingChecked(4, board, false) && !isKingChecked(5, board, false) && !isKingChecked(6, board, false))){
      return 6;
  }
  return 0;
}

int finKingIndex(String king){
  for(int i=0; i<64; i++){
    if(board[i] == king){
      return i;
    }
  }
  return 0;
}

bool isKingChecked(int king, List<String> tempBoard, bool isWhiteTurn){
  int kingPosition = king;
  if(isWhiteTurn){
    for(int i = 0; i < 64; i++){
      if(tempBoard[i] == 'p' && pawnMove(i, kingPosition, 'p', tempBoard) == 3){
        return true;
      }else if(tempBoard[i] == 'n' && knightMove(i, kingPosition, 'n', tempBoard)){
        return true;
      }else if(tempBoard[i] == 'b' && diagonalMove(i, kingPosition, 'b', tempBoard)){
        return true;
      }else if(tempBoard[i] == 'r' && (horizontalMove(i, kingPosition, 'r', tempBoard) || verticalMove(i, kingPosition, 'r', tempBoard))){
        return true;
      }else if(tempBoard[i] == 'q' && (horizontalMove(i, kingPosition, 'q', tempBoard) || verticalMove(i, kingPosition, 'q', tempBoard) || diagonalMove(i, kingPosition, 'q', tempBoard))){
        return true;
      }else if(tempBoard[i] == 'k' && kingMove(i, kingPosition, 'k', tempBoard) != 0){
        return true;
      }
    }
  }else if(isWhiteTurn == false){
    for(int i=0; i<64; i++){
      if(tempBoard[i] == 'P' && pawnMove(i, kingPosition, 'P', tempBoard) == 3){
        return true;
      }else if(tempBoard[i] == 'N' && knightMove(i, kingPosition, 'N', tempBoard)){
        return true;
      }else if(tempBoard[i] == 'B' && diagonalMove(i, kingPosition, 'B', tempBoard)){
        return true;
      }else if(tempBoard[i] == 'R' && (horizontalMove(i, kingPosition, 'R', tempBoard) || verticalMove(i, kingPosition, 'R', tempBoard))){
        return true;
      }else if(tempBoard[i] == 'Q' && (horizontalMove(i, kingPosition, 'Q', tempBoard) || verticalMove(i, kingPosition, 'Q', tempBoard) || diagonalMove(i, kingPosition, 'Q', tempBoard))){
        return true;
      }else if(tempBoard[i] == 'K' && kingMove(i, kingPosition, 'K', tempBoard) != 0){
        return true;
      }
    }
  }
  return false;
}

bool canPieceMove(int pieceIndex, int moveIndex, String piece, List<String> board){
  var tempBoard = List<String>.from(board);
  tempBoard[moveIndex] = piece;
  tempBoard[pieceIndex] = ' ';

  for(int i=0; i<64; i++){
    if(isWhiteTurn && tempBoard[i] == 'K'){
      if(isKingChecked(i, tempBoard, isWhiteTurn)){
        return false;
      }
    }else if(isWhiteTurn == false && tempBoard[i] == 'k'){
      if(isKingChecked(i, tempBoard, isWhiteTurn)){
        return false;
      }
    }
  }
  return true;
}

bool canPawnEnPassant(int pieceIndex, int moveIndex, bool isWhiteTurn){
  var tempBoard = List<String>.from(board);
  if(tempBoard[pieceIndex] == 'P') {
    tempBoard[moveIndex] = tempBoard[pieceIndex];
    tempBoard[pieceIndex] = ' ';
    tempBoard[moveIndex + 8] = ' ';
    for(int i=0; i<64; i++) {
        if (isWhiteTurn && tempBoard[i] == 'K') {
            int kingPosition = i;
            if (isKingChecked(kingPosition, tempBoard, isWhiteTurn)) {
                return false;
            }
        }
    }
  }else if(tempBoard[pieceIndex] == 'p'){
    tempBoard[moveIndex] = tempBoard[pieceIndex];
    tempBoard[pieceIndex] = ' ';
    tempBoard[moveIndex - 8] = ' ';
    for(int i=0; i<64; i++) {
        if (!isWhiteTurn && tempBoard[i] == 'k') {
            int kingPosition = i;
            if (isKingChecked(kingPosition, tempBoard, isWhiteTurn)) {
                return false;
            }
        }
    }
  }
  return true;
}

bool isCheckmate(List<String> board, bool isWhiteTurn) {

  String kingPiece = isWhiteTurn ? 'K' : 'k';
  int kingIndex = -1;
  
  for (int i = 0; i < 64; i++) {
    if (board[i] == kingPiece) {
      kingIndex = i;
      break;
    }
  }
  

  if (kingIndex == -1) return false;
  
  if(!isKingChecked(kingIndex, board, isWhiteTurn)) {
    return false;
  }
  
  for (int i = 0; i < 64; i++) {
    if (isWhiteTurn && board[i] != ' ' && board[i] == board[i].toUpperCase()) {
      for (int j = 0; j < 64; j++) {
        int moveResult = validateWhiteMoves(board, i, j, board[i]);
        if (moveResult != 0) {

          List<String> tempBoard = List<String>.from(board);
          
          temporarWhiteMove(i, j, tempBoard, board[i]);
          
          bool stillChecked = false;
          for (int k = 0; k < 64; k++) {
            if (tempBoard[k] == 'K') {
              if (isKingChecked(k, tempBoard, true)) {
                stillChecked = true;
                break;
              }
            }
          }
          if (!stillChecked) {
            return false;
          }
        }
      }
    } else if (!isWhiteTurn && board[i] != ' ' && board[i] == board[i].toLowerCase()) {
      for (int j = 0; j < 64; j++) {
        int moveResult = validateBlackMoves(board, i, j, board[i]);
        if (moveResult != 0) {

          List<String> tempBoard = List<String>.from(board);
          
          temporarBlackMove(i, j, tempBoard, board[i]);
          
          bool stillChecked = false;
          for (int k = 0; k < 64; k++) {
            if (tempBoard[k] == 'k') {
              if (isKingChecked(k, tempBoard, false)) {
                stillChecked = true;
                break;
              }
            }
          }
          if (!stillChecked) {
            return false;
          }
        }
      }
    }
  }
  return true;
}

void clearEnPassant(){
  if(isWhiteTurn){
    whiteEnPassant[0] = 0;
    whiteEnPassant[1] = 0;
  }else{
    blackEnPassant[0] = 0;
    blackEnPassant[1] = 0;
  }
}

void resetGame(){
  isWhiteTurn = true;
  board = List<String>.from(boardInitial);
  whiteEnPassant = List<int>.filled(2,0);
  blackEnPassant = List<int>.filled(2,0);
  whiteCastle = List<int>.filled(3,0);
  blackCastle = List<int>.filled(3,0);
  switchCount = 0;
  pickedUpAI = -1;
  placedAI = -1;
  placedX = -1;
  placedY = -1;
  pickedUpX = -1;
  pickedUpY = -1;
}

