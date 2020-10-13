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
      move_safe_for_king?(move)
    end
  end

  private

  def move_safe_for_king?(move)
    temp_board = @possible_board
    temp_board.data[move[0]][move[1]] = @current_piece
    location = find_king_location(move)
    result = safe_move?(location, temp_board)
    temp_board.data[move[0]][move[1]] = nil
    result
  end

  def safe_move?(kings_location, board)
    board.data.none? do |row|
      row.any? do |square|
        next unless square && square.color != @current_piece.color

        captures = square.format_valid_captures(board)
        captures.include?(kings_location)
      end
    end
  end

  def find_king_location(move)
    if @current_piece.symbol == " \u265A "
      move
    elsif @current_piece.color == :black
      @possible_board.black_king.location
    else
      @possible_board.white_king.location
    end
  end
end
