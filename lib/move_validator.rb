# frozen_string_literal: true

# contains logic for chess board
class MoveValidator
  def initialize(piece, board, moves)
    @current_piece = piece
    @possible_board = board.clone
    @possible_moves = moves
  end

  def verify_possible_moves
    location = @current_piece.location
    king_location = find_king_location
    @possible_moves.select do |move|
      @possible_board.data[location[0]][location[1]] = nil
      @possible_board.data[move[0]][move[1]] = @current_piece
      opponent_captures?(king_location)
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

  def opponent_captures?(location)
    @possible_board.data.none? do |row|
      row.any? do |square|
        next unless square && square.color != @current_piece.color

        square.captures.include?(location)
      end
    end
  end
end
