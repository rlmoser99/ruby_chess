# frozen_string_literal: true

# removes any moves/captures that would put their King in check
class MoveValidator
  def initialize(location, board, moves)
    @current_location = location
    @possible_board = board
    @possible_moves = moves
    @current_piece = @possible_board.data[location[0]][location[1]]
  end

  # iterates over the possible moves and keeps the legal ones
  def verify_possible_moves
    @possible_board.data[@current_location[0]][@current_location[1]] = nil
    @possible_moves.select do |move|
      legal_move?(move)
    end
  end

  private

  # creates a copy of board with piece moved to check if king is safe
  def legal_move?(move)
    temp_board = @possible_board
    temp_board.data[move[0]][move[1]] = @current_piece
    safe_move?(temp_board, move)
  end

  # returns true if king is no longer in check or if king is still safe
  def safe_move?(board, move)
    if @possible_board.king_in_check?(@current_piece.color)
      result = move_out_of_check?(board)
    else
      king = find_king_location(move)
      result = safe_king?(king, board)
    end
    board.data[move[0]][move[1]] = nil
    result
  end

  # returns true if king is not in check
  def move_out_of_check?(board)
    !board.king_in_check?(@current_piece.color)
  end

  # returns true if no opposing piece can capture king
  def safe_king?(kings_location, board)
    pieces = board.data.flatten(1).compact
    pieces.none? do |piece|
      next unless piece.color != @current_piece.color

      captures = piece.find_possible_captures(board)
      captures.include?(kings_location)
    end
  end

  # returns location of king, even when current piece is king and has moved
  def find_king_location(move)
    # binding.pry if @current_piece.nil?
    if @current_piece.symbol == " \u265A "
      move
    elsif @current_piece.color == :black
      @possible_board.black_king.location
    else
      @possible_board.white_king.location
    end
  end
end
