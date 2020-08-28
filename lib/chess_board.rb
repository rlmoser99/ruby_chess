# frozen_string_literal: true

# contains logic for chess board
class ChessBoard
  attr_reader :data

  def initialize(data = Array.new(8) { Array.new(8) })
    @data = data
    @possible_moves = []
  end

  # Only Puts Method -> No tests needed
  def to_s
    puts
    puts "\e[36m    a  b  c  d  e  f  g  h \e[0m"
    print_board
    puts "\e[36m    a  b  c  d  e  f  g  h \e[0m"
    puts
  end

  # Script Method -> No tests needed (test inside methods)
  def update(original, final, piece)
    update_final_coordinates(final, piece)
    update_original_coordinates(original)
  end

  # Completed Tests
  def update_final_coordinates(final, piece)
    @data[final[:row]][final[:column]] = piece
  end

  # Completed Tests
  def update_original_coordinates(original)
    @data[original[:row]][original[:column]] = nil
  end

  # Completed Tests
  def initial_placement
    # initial_row(:black, 0)
    initial_pawn_row(:black, 1)
    initial_pawn_row(:white, 6)
    # initial_row(:white, 7)
  end

  private

  def initial_pawn_row(color, number)
    8.times { |index| @data[number][index] = Pawn.new({ color: color, location: [[number][index]] }) }
  end

  # def initial_row(color, number)
  #   @data[number] = [
  #     Rook.new(color), Knight.new(color), Bishop.new(color),
  #     Queen.new(color), King.new(color), Bishop.new(color),
  #     Knight.new(color), Rook.new(color)
  #   ]
  # end

  def print_board
    @data.each_with_index do |row, index|
      print "\e[36m #{8 - index} \e[0m"
      print_row(row, index)
      print "\e[36m #{8 - index} \e[0m"
      puts
    end
  end

  def print_row(row, row_index)
    row.each_with_index do |square, index|
      background_color = select_background(row_index, index)
      print_square(square, background_color)
    end
  end

  # 102 = Green, 47 = Light Gray, and 100 = Dark Gray
  def select_background(row_index, column_index)
    index_total = row_index + column_index
    # @possible_moves = [[3, 3], [2, 1]]
    if @possible_moves.any?([row_index, column_index])
      102
    elsif index_total.even?
      47
    else
      100
    end
  end

  # 97 = White and 30 = Black
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
