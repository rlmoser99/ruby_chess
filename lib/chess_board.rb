# frozen_string_literal: true

# contains logic for chess board
class ChessBoard
  # def initialize(board = initial_placement)
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def to_s
    puts
    puts "\e[36m    a  b  c  d  e  f  g  h \e[0m"
    print_board
    puts "\e[36m    a  b  c  d  e  f  g  h \e[0m"
    puts
  end

  def update_value(row, column, piece)
    @board[row][column] = piece
  end

  private

  # def initial_placement
  #   [
  #     %w[br bn bb bq bk bb bn br],
  #     %w[bp bp bp bp bp bp bp bp],
  #     %w[-- -- -- -- -- -- -- --],
  #     %w[-- -- -- -- -- -- -- --],
  #     %w[-- -- -- -- -- -- -- --],
  #     %w[-- -- -- -- -- -- -- --],
  #     %w[wp wp wp wp wp wp wp wp],
  #     %w[wr wn wb wq wk wb wn wr]
  #   ]
  # end

  def print_board
    @board.each_with_index do |row, index|
      print "\e[36m #{8 - index} \e[0m"
      print_row(row, index)
      print "\e[36m #{8 - index} \e[0m"
      puts
    end
  end

  def print_row(row, row_index)
    row.each_with_index do |square, index|
      index_total = row_index + index
      background_color = index_total.even? ? 47 : 100
      print_square(square, background_color)
    end
  end

  def print_square(square, background)
    if square
      text_color = square.color == :white ? 97 : 30
      color_square(text_color, background, square.symbol)
    else
      color_square(30, background, '   ')
    end
  end

  def color_square(font, background, string)
    print "\e[#{font};#{background}m#{string}\e[0m"
  end
end
