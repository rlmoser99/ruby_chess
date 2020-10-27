# frozen_string_literal: true

# removes any moves/captures that would put their King in check
class MoveValidator
  def initialize(location, board, moves)
    @current_location = location
    @possible_board = board
    @possible_moves = moves
    @current_piece = @possible_board.data[location[0]][location[1]]
    @king_location = nil
  end

  # iterates over the possible moves and keeps the legal ones
  def verify_possible_moves
    @king_location = find_king_location
    @possible_board.data[@current_location[0]][@current_location[1]] = nil
    @possible_moves.select do |move|
      legal_move?(move)
    end
  end

  private

  # UPDATE THIS COMMENT!!!
  # creates a copy of board with piece moved to check if king is safe
  def legal_move?(move)
    captured_piece = @possible_board.data[move[0]][move[1]]
    update_possible_board(move)
    king = @king_location || move
    result = safe_king?(king)
    @possible_board.data[move[0]][move[1]] = captured_piece
    result
  end

  # CREATE A COMMENT!!! DIFFERENT METHOD NAME???
  def update_possible_board(move)
    @possible_board.data[move[0]][move[1]] = @current_piece
    @current_piece.update_location(move[0], move[1])
  end

  # returns true if no opposing piece can capture king
  def safe_king?(kings_location)
    pieces = @possible_board.data.flatten(1).compact
    pieces.none? do |piece|
      next unless piece.color != @current_piece.color

      captures = piece.find_possible_captures(@possible_board)
      captures.include?(kings_location)
    end
  end

  # returns location of king unless the piece is a king
  def find_king_location
    return if @current_piece.symbol == " \u265A "

    if @current_piece.color == :black
      @possible_board.black_king.location
    else
      @possible_board.white_king.location
    end
  end
end
