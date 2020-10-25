# frozen_string_literal: true

# creates visual chess board from board's data array.
module Displayable
  # outputs the chess board with letter and number coordinates
  # 36 = cyan colored text
  def print_chess_board
    system 'clear'
    puts
    puts "\e[36m    a  b  c  d  e  f  g  h \e[0m"
    print_board
    puts "\e[36m    a  b  c  d  e  f  g  h \e[0m"
    puts
  end

  # interates through each row of board and adds number coordinates
  # 36 = cyan colored text
  def print_board
    @data.each_with_index do |row, index|
      print "\e[36m #{8 - index} \e[0m"
      print_row(row, index)
      print "\e[36m #{8 - index} \e[0m"
      puts
    end
  end

  # creates each row to be printed with different background_color
  def print_row(row, row_index)
    row.each_with_index do |square, index|
      background_color = select_background(row_index, index)
      print_square(row_index, index, square, background_color)
    end
  end

  # returns color of background based on specific conditions
  # 47 = light gray background (even)
  # 100 = dark gray background (odd)
  # 46 = cyan  background (active piece to move)
  # 101 = light red background (captures)
  def select_background(row_index, column_index)
    index_total = row_index + column_index
    if @active_piece&.location == [row_index, column_index]
      46
    elsif capture_background?(row_index, column_index)
      101
    elsif index_total.even?
      47
    else
      100
    end
  end

  # returns true if row/column is a active piece's capture location
  def capture_background?(row, column)
    @active_piece&.captures&.any?([row, column]) && @data[row][column]
  end

  # determines the font colors each square based on specific conditions
  # 97 = white font color (chess pieces)
  # 30 = black font color (chess pieces)
  # 91 = light red font color (possible moves circle \u25CF)
  def print_square(row_index, column_index, square, background)
    if square
      text_color = square.color == :white ? 97 : 30
      color_square(text_color, background, square.symbol)
    elsif @active_piece&.moves&.any?([row_index, column_index])
      color_square(91, background, " \u25CF ")
    else
      color_square(30, background, '   ')
    end
  end

  # prints the final square with specified font, background, and string (symbol)
  def color_square(font, background, string)
    print "\e[#{font};#{background}m#{string}\e[0m"
  end
end
