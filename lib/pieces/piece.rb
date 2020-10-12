# frozen_string_literal: true

require_relative '../board'
require_relative '../move_validator'

# logic for each chess piece
class Piece
  attr_reader :location, :color, :symbol, :moves, :captures

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

  def current_moves(board)
    possibilities = format_valid_moves(board)
    @moves = remove_king_check_moves(board, possibilities)
  end

  def current_captures(board)
    possibilities = format_valid_captures(board)
    @captures = remove_king_check_moves(board, possibilities)
  end

  def format_valid_moves(board)
    find_valid_moves(board.data).compact.flatten(1)
  end

  def format_valid_captures(board)
    find_valid_captures(board.data).compact
  end

  # Checks a move if it would put the king in check
  def remove_king_check_moves(board, moves)
    return moves unless moves.size.positive?

    temp_board = Marshal.load(Marshal.dump(board))
    check = MoveValidator.new(@location, temp_board, moves)
    check.verify_possible_moves
  end

  def update(board)
    current_captures(board)
    current_moves(board)
  end

  private

  def move_set
    raise 'Called abstract method: move_set'
  end

  def find_valid_moves(board)
    move_set.inject([]) do |memo, move|
      memo << create_moves(board, move[0], move[1])
    end
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

  def find_valid_captures(data)
    move_set.inject([]) do |memo, move|
      memo << create_captures(data, move[0], move[1])
    end
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
