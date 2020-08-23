# frozen_string_literal: true

# contains logic for chess board
class ChessBoard
  SOLID_KING = "\u265A"
  SOLID_QUEEN = "\u265B"
  SOLID_ROOK = "\u265C"
  SOLID_BISHOP = "\u265D"
  SOLID_KNIGHT = "\u265E"
  SOLID_PAWN = "\u265F"
  OUTLINE_KING = "\u2654"
  OUTLINE_QUEEN = "\u2655"
  OUTLINE_ROOK = "\u2656"
  OUTLINE_BISHOP = "\u2657"
  OUTLINE_KNIGHT = "\u2658"
  OUTLINE_PAWN = "\u2659"

  def initialize
    @board = Array.new(8) { Array.new(8, ' ') }
  end

  def to_s
    @board.each_with_index do |row, index|
      print_row(row, index)
      puts
    end
  end

  def starting_positions
    @board[0][0] = SOLID_KING
    @board[0][1] = SOLID_QUEEN
    @board[0][2] = SOLID_ROOK
    @board[0][3] = SOLID_BISHOP
    @board[0][4] = SOLID_KNIGHT
    @board[0][5] = SOLID_PAWN
    @board[1][0] = OUTLINE_KING
    @board[1][1] = OUTLINE_QUEEN
    @board[1][2] = OUTLINE_ROOK
    @board[1][3] = OUTLINE_BISHOP
    @board[1][4] = OUTLINE_KNIGHT
    @board[1][5] = OUTLINE_PAWN
  end

  private

  def print_row(row, row_index)
    row.each_with_index do |square, index|
      if (row_index + index).even?
        print "\e[47m #{square} \e[0m"
      else
        print "\e[100m #{square} \e[0m"
      end
    end
  end
end
