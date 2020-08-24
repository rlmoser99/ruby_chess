# frozen_string_literal: true

# contains logic for chess board
class ChessBoard
  def initialize(board = initial_placement)
    @board = board
  end

  def to_s
    puts
    puts "\e[36m    a  b  c  d  e  f  g  h \e[0m"
    print_board
    puts "\e[36m    a  b  c  d  e  f  g  h \e[0m"
    puts
  end

  private

  def initial_placement
    [
      %w[br bn bb bq bk bb bn br],
      %w[bp bp bp bp bp bp bp bp],
      %w[-- -- -- -- -- -- -- --],
      %w[-- -- -- -- -- -- -- --],
      %w[-- -- -- -- -- -- -- --],
      %w[-- -- -- -- -- -- -- --],
      %w[wp wp wp wp wp wp wp wp],
      %w[wr wn wb wq wk wb wn wr]
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
      background = index_total.even? ? 47 : 100
      print_square(square, background)
    end
  end

  def print_square(square, background)
    text = square.match?(/^w/) ? 97 : 30
    piece = chess_piece(square[-1])
    color_square(text, background, piece)
  end

  def color_square(text, background, string)
    print "\e[#{text};#{background}m#{string}\e[0m"
  end

  def chess_piece(letter)
    {
      'k' => " \u265A ",
      'q' => " \u265B ",
      'r' => " \u265C ",
      'b' => " \u265D ",
      'n' => " \u265E ",
      'p' => " \u265F ",
      '-' => '   '
    }[letter]
  end
end
