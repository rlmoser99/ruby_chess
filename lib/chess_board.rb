# frozen_string_literal: true

# contains logic for chess board
class ChessBoard
  attr_reader :data

  def initialize(data = Array.new(8) { Array.new(8) })
    @data = data
  end

  def to_s
    puts
    puts "\e[36m    a  b  c  d  e  f  g  h \e[0m"
    print_board
    puts "\e[36m    a  b  c  d  e  f  g  h \e[0m"
    puts
  end

  def update_value(row, column, piece)
    @data[row][column] = piece
  end

  def select_piece(row, column)
    @data[row][column]
  end

  def initial_placement
    initial_row(:black, 0)
    initial_pawn_row(:black, 1)
    initial_pawn_row(:white, 6)
    initial_row(:white, 7)
  end

  private

  def initial_pawn_row(color, number)
    8.times { |index| @data[number][index] = Pawn.new(color) }
  end

  def initial_row(color, number)
    @data[number] = [
      Rook.new(color), Knight.new(color), Bishop.new(color),
      Queen.new(color), King.new(color), Bishop.new(color),
      Knight.new(color), Rook.new(color)
    ]
  end

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
