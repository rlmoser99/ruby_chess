# frozen_string_literal: true

require_relative '../board'
require_relative '../move_validator'

# logic for each chess piece
class Piece
  attr_reader :color, :location, :symbol, :moves, :captures, :moved

  def initialize(board, args)
    board.add_observer(self)
    @color = args[:color]
    @location = args[:location]
    @symbol = nil
    @moves = []
    @captures = []
    @moved = false
  end

  # Tested
  def update_location(row, column)
    @location = [row, column]
    @moved = true
  end

  # No need to test (script method)
  def current_moves(board)
    possible_moves = find_possible_moves(board)
    @moves = remove_illegal_moves(board, possible_moves)
  end

  # No need to test (script method)
  def current_captures(board)
    possible_captures = find_possible_captures(board)
    @captures = remove_illegal_moves(board, possible_captures)
  end

  # Tested in individual pieces
  def find_possible_moves(board)
    moves = move_set.inject([]) do |memo, move|
      memo << create_moves(board.data, move[0], move[1])
    end
    moves.compact.flatten(1)
  end

  # Tested in individual pieces
  def find_possible_captures(board)
    captures = move_set.inject([]) do |memo, move|
      memo << create_captures(board.data, move[0], move[1])
    end
    captures.compact
  end

  # Tested in MoveValidator
  # Removes any move/capture that puts the king in check
  def remove_illegal_moves(board, moves)
    return moves unless moves.size.positive?

    temp_board = Marshal.load(Marshal.dump(board))
    validator = MoveValidator.new(location, temp_board, moves)
    validator.verify_possible_moves
  end

  # No need to test (script method)
  def update(board)
    current_captures(board)
    current_moves(board)
  end

  private

  def move_set
    raise 'Called abstract method: move_set'
  end

  def create_moves(data, rank_change, file_change)
    rank = @location[0] + rank_change
    file = @location[1] + file_change
    result = []
    while valid_location?(rank, file)
      break if data[rank][file]

      result << [rank, file]
      rank += rank_change
      file += file_change
    end
    result
  end

  def create_captures(data, rank_change, file_change)
    rank = @location[0] + rank_change
    file = @location[1] + file_change
    while valid_location?(rank, file)
      break if data[rank][file]

      rank += rank_change
      file += file_change
    end
    [rank, file] if opposing_piece?(rank, file, data)
  end

  def valid_location?(rank, file)
    rank.between?(0, 7) && file.between?(0, 7)
  end

  def opposing_piece?(rank, file, data)
    return unless valid_location?(rank, file)

    piece = data[rank][file]
    piece && piece.color != color
  end
end
