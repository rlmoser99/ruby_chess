# frozen_string_literal: true

# Manipulates Board's data array into chess board.
module Displayable
  # 36 = Cyan Text (94 light blue looks good too)
  def print_chess_game
    system 'clear'
    puts
    puts "\e[36m    a  b  c  d  e  f  g  h \e[0m"
    print_board
    puts "\e[36m    a  b  c  d  e  f  g  h \e[0m"
    puts
  end

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
      print_square(row_index, index, square, background_color)
    end
  end

  # Background Color ->
  # 47 = Light Gray (even)
  # 100 = Dark Gray (odd)
  # 46 = Cyan (active piece to move) (44 blue looks good too)
  # 101 = Light Red (capture background)
  def select_background(row_index, column_index)
    index_total = row_index + column_index
    if @active_piece && @active_piece.location == [row_index, column_index]
      46
    elsif capture_background?(row_index, column_index)
      101
    elsif index_total.even?
      47
    else
      100
    end
  end

  def capture_background?(row, column)
    @valid_captures&.any?([row, column]) && @data[row][column]
  end

  # Font Color ->
  # 97 = White (chess pieces)
  # 30 = Black (chess pieces)
  # 91 = Light Red (possible moves)
  def print_square(row_index, column_index, square, background)
    if square
      text_color = square.color == :white ? 97 : 30
      color_square(text_color, background, square.symbol)
    elsif @valid_moves&.any?([row_index, column_index])
      color_square(91, background, " \u25CF ")
    else
      color_square(30, background, '   ')
    end
  end

  def color_square(font, background, string)
    print "\e[#{font};#{background}m#{string}\e[0m"
  end
end
