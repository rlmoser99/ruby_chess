# frozen_string_literal: true

require_relative '../board'

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
    possibilities = find_valid_moves(board.data).compact.flatten(1)
    @moves = possibilities
    # @moves = king_check_possibilities(board, possibilities)
  end

  # DATA WILL BE UPDATED TO SELF!!!
  # Update other pieces moves & captures to be data instead of board
  def current_captures(data, _previous_piece)
    @captures = find_valid_captures(data).compact
  end

  # Checks all board move possibilities if a move would put king in check
  def king_check_possibilities(_board, moves)
    return moves unless moves.size > 1

    # check = MoveValidator.new(self, board, moves)
    # check.run_possibilities
  end

  def update(board)
    current_moves(board)
    current_captures(board.data, board.previous_piece)
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

  def create_moves(board, rank_change, file_change)
    rank = @location[0] + rank_change
    file = @location[1] + file_change
    result = []
    while valid_location?(rank, file)
      break if board[rank][file]

      result << [rank, file]
      rank += rank_change
      file += file_change
    end
    result
  end

  def find_valid_captures(board)
    move_set.inject([]) do |memo, move|
      memo << create_captures(board, move[0], move[1])
    end
  end

  def create_captures(board, rank_change, file_change)
    rank = @location[0] + rank_change
    file = @location[1] + file_change
    while valid_location?(rank, file)
      break if board[rank][file]

      rank += rank_change
      file += file_change
    end
    [rank, file] if opposing_piece?(rank, file, board)
  end

  def valid_location?(rank, file)
    rank.between?(0, 7) && file.between?(0, 7)
  end

  def opposing_piece?(rank, file, board)
    return unless valid_location?(rank, file)

    piece = board[rank][file]
    piece && piece.color != color
  end
end
