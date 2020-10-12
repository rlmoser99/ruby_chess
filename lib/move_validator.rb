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
    king_location = find_king_location
    temp_board = @possible_board
    temp_board.data[@current_location[0]][@current_location[1]] = nil
    @possible_moves.select do |move|
      verifed_move?(temp_board, move, king_location)
    end
  end

  def verifed_move?(board, move, king_location)
    board.data[move[0]][move[1]] = @current_piece
    result = opponent_capture_king?(board, king_location)
    board.data[move[0]][move[1]] = nil
    result
  end

  private

  def find_king_location
    if @current_piece.color == :black
      @possible_board.black_king.location
    else
      @possible_board.white_king.location
    end
  end

  def opponent_capture_king?(board, location)
    board.data.none? do |row|
      row.any? do |square|
        next unless square && square.color != @current_piece.color

        captures = square.format_valid_captures(board)
        captures.include?(location)
      end
    end
  end
end
