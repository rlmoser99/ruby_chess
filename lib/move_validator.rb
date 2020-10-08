# frozen_string_literal: true

# contains logic for chess board
class MoveValidator
  def initialize(piece, board, moves)
    @current_piece = piece
    @possible_board = board.clone
    @possible_moves = moves
  end

  def run_possibilities
    location = @current_piece.location
    # During each iteration, king_location can not be a piece's capture
    king_location = determine_king_location
    @possible_moves.select do |move|
      @possible_board.data[location[0]][location[1]] = nil
      @possible_board.data[move[0]][move[1]] = @current_piece
      move.include?(5)
    end
  end

  private

  def determine_king_location
    if @current_piece.color == :black
      @possible_board.black_king.location
    else
      @possible_board.white_king.location
    end
  end

  # def run_board
  #   @possible_board.data.each do |row|
  #     row.each do |square|
  #     end
  #   end
  # end
end
