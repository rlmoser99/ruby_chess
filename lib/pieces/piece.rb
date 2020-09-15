# frozen_string_literal: true

# logic for each chess piece
class Piece
  attr_reader :location, :color

  def initialize(args)
    @color = args[:color]
    @location = args[:location]
    @moves = []
    @moved = false
  end

  # Tested
  def update_location(row, column)
    @location = [row, column]
    @moved = true
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
