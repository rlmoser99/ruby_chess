# frozen_string_literal: true

require_relative 'piece'

# logic for each chess piece
class Rook < Piece
  attr_reader :color, :symbol

  def initialize(args)
    super(args)
    @location = args[:location]
    @symbol = " \u265C "
  end

  def current_moves(board)
    rank_moves(board[@location[0]]) + file_moves(board)
  end

  def current_captures(board)
    # rank = @location[0]
    # file = @location[1]
    rank_captures(board[@location[0]])
  end

  private

  def rank_moves(rank)
    index = @location[1]
    empty_ranks = row_increase(index + 1, rank) + row_decrease(index - 1, rank)
    [@location[0]].product(empty_ranks)
  end

  def file_moves(board)
    rank = @location[0]
    file = @location[1]
    row = board.transpose[file]
    empty_files = row_increase(rank + 1, row) + row_decrease(rank - 1, row)
    empty_files.product([file])
  end

  def row_increase(index, row)
    empty_increase = []
    until row[index] || index > 7
      empty_increase << index
      index += 1
    end
    empty_increase
  end

  def row_decrease(index, row)
    empty_decrease = []
    until row[index] || index.negative?
      empty_decrease << index
      index -= 1
    end
    empty_decrease
  end

  def rank_captures(rank)
    index = @location[1]
    captures = []
    increase = capture_increase(index + 1, rank)
    decrease = capture_decrease(index - 1, rank)
    captures << increase if increase
    captures << decrease if decrease
    [@location[0]].product(captures)
  end

  def capture_increase(index, row)
    return index if opposing_piece?(index, row)
    return nil unless opposing_piece?(index, row) || index < 8

    capture_increase(index + 1, row)
  end

  def capture_decrease(index, row)
    return index if opposing_piece?(index, row)
    return nil unless opposing_piece?(index, row) || index >= 0

    capture_decrease(index - 1, row)
  end

  def opposing_piece?(index, row)
    row[index] && row[index].color != color
  end
end
