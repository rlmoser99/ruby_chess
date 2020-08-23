# frozen_string_literal: true

# contains logic for chess board
class ChessBoard
  def initialize
    @board = Array.new(8) { Array.new(8, '') }
  end

  def to_s
    @board.each_with_index do |row, index|
      print_row(row, index)
      puts
    end
  end

  private

  def print_row(row, row_index)
    row.each_with_index do |_square, index|
      if (row_index + index).even?
        print "\e[40m  \e[0m"
      else
        print "\e[107m  \e[0m"
      end
    end
  end
end
