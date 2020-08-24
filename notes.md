## Chess Ideas
- Have player choose a piece to move & then display the legal moves for player to input?
- Visually warn player when King is in check

## Main
- create players
- game 'script'

## Player
- name
- color -> decided randomly. White goes first.
- check mate status

## Board
+ 2-D array
+ print board's background black & white
+ rows are called 'ranks' denoted 1 to 8 from bottom to top according to White's perspective.
+ columns are called 'files' denoted a to h from left to right according to White's perspective.
+ The board has a light square at the right-hand corner nearest to each player. Thus, each queen starts on a square of its own color (the white queen on a light square; the black queen on a dark square).

## Game
- Initialize with 2 players & 1 board
- put in players in an array and use .cycle

## Serialization
- Save a game
- Load a saved a game

## Moves
- moved to either an unoccupied square or one occupied by an opponent's piece, which is captured and removed from play. 
- can not skip a turn
- can not make a turn that would put their own king in check,

If the player to move has no legal move, the game is over; the result is either checkmate (a loss for the player with no legal move) if the king is in check, or stalemate (a draw) if the king is not.

## Game Over
- Checkmate - The player whose turn it is to move is in check and has no legal move to escape check.
- Resignation: Either player may resign, conceding the game to the opponent.
- If the player to move has no legal move, the game is over; the result is either checkmate (a loss for the player with no legal move) if the king is in check, or stalemate (a draw) if the king is not.

## All Pieces
- 


## King - 1
- status: in_check?
- status: castling? (can not have moved in the game)
- The king moves one square in any direction. 
- The king also has a special move called castling that involves also moving a rook.

## Queen - 1
- The queen combines the power of a rook and bishop and can move any number of squares along a rank, file, or diagonal, but cannot leap over other pieces.

## Rook - 2
- status: castling? (can not have moved in the game)
- A rook can move any number of squares along a rank or file, but cannot leap over other pieces.

## Bishop - 2
- A bishop can move any number of squares diagonally, but cannot leap over other pieces.

## Knight - 2
- A knight moves to any of the closest squares that are not on the same rank, file, or diagonal. (Thus the move forms an "L"-shape)
- The knight is the only piece that can leap over other pieces.

## Pawn - 8
- Status: en_passant?
- Can move 2 squares only if they are on 2nd or 7th rank (row).
- En Passant "In Passing" Capturing (the only time that the piece that captures, does not end up on the square of the piece it captures). This can only happen **one** time, if a pawn moves from 2nd-4th rank or 7th-5th rank and is next to an opposing pawn.
- A pawn can move forward to the unoccupied square immediately in front of it on the same file, or on its first move it can advance two squares along the same file, provided both squares are unoccupied (black dots in the diagram); or the pawn can capture an opponent's piece on a square diagonally in front of it on an adjacent file, by moving to that square (black "x"s). A pawn has two special moves: the en passant capture and promotion.


## Castling
Once in every game, each king can make a special move, known as castling. Castling consists of moving the king two squares along the first rank toward a rook (that is on the player's first rank) and then placing the rook on the last square that the king just crossed. Castling is permissible if the following conditions are met:
- Neither the king nor the rook has previously moved during the game.
- There are no pieces between the king and the rook.
- The king cannot be in check, nor can the king pass through any square that is under attack by an enemy piece, or move to a square that would result in check. (Note that castling is permitted if the rook is under attack, or if the rook crosses an attacked square.)

## Promotion
When a pawn advances to the eighth rank, as a part of the move it is promoted and must be exchanged for the player's choice of queen, rook, bishop, or knight of the same color. There is no restriction on the piece promoted to, so it is possible to have more pieces of the same type than at the start of the game.

## Check
When a king is under immediate attack by one or two of the opponent's pieces, it is said to be in check. A move in response to a check is legal only if it results in a position where the king is no longer in check. This can involve capturing the checking piece; interposing a piece between the checking piece and the king (which is possible only if the attacking piece is a queen, rook, or bishop and there is a square between it and the king); or moving the king to a square where it is not under attack. Castling is not a permissible response to a check.

The object of the game is to checkmate the opponent; this occurs when the opponent's king is in check, and there is no legal way to remove it from attack. It is never legal for a player to make a move that puts or leaves the player's own king in check. In casual games it is common to announce "check" when putting the opponent's king in check, but this is not required by the rules of chess and is not usually done in tournaments.