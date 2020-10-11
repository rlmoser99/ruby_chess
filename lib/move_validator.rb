# frozen_string_literal: true

# contains logic for chess board
class MoveValidator
  def initialize(location, board, moves)
    @current_location = location
    @possible_board = board
    @possible_moves = moves
    @current_piece = @possible_board.data[location[0]][location[1]]
  end

  def verify_possible_moves
    location = @current_location
    king_location = find_king_location
    temp_board = @possible_board
    @possible_moves.select do |move|
      temp_board.data[location[0]][location[1]] = nil
      temp_board.data[move[0]][move[1]] = @current_piece
      valid = opponent_captures?(temp_board, king_location)
      temp_board.data[move[0]][move[1]] = nil
      valid
    end
  end

  private

  def find_king_location
    if @current_piece.color == :black
      @possible_board.black_king.location
    else
      @possible_board.white_king.location
    end
  end

  def opponent_captures?(board, location)
    board.data.none? do |row|
      row.any? do |square|
        next unless square && square.color != @current_piece.color

        square.current_captures(board)
        square.captures.include?(location)
      end
    end
  end
end
