# frozen_string_literal: true

# checks possible_moves to determine if it would put King in check
class MoveValidator
  def initialize(location, board, moves)
    @current_location = location
    @possible_board = board
    @possible_moves = moves
    @current_piece = @possible_board.data[location[0]][location[1]]
  end

  def verify_possible_moves
    @possible_board.data[@current_location[0]][@current_location[1]] = nil
    @possible_moves.select do |move|
      @possible_board.data[move[0]][move[1]] = @current_piece
      result = opponent_capture_king?
      @possible_board.data[move[0]][move[1]] = nil
      result
    end
  end

  private

  def opponent_capture_king?
    @possible_board.data.none? do |row|
      row.any? do |square|
        next unless square && square.color != @current_piece.color

        captures = square.format_valid_captures(@possible_board)
        captures.include?(king_location)
      end
    end
  end

  def king_location
    if @current_piece.color == :black
      @possible_board.black_king.location
    else
      @possible_board.white_king.location
    end
  end
end
