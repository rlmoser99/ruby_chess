# frozen_string_literal: true

# contains logic for chess board
class ChessBoard
  attr_reader :data

  def initialize(data = Array.new(8) { Array.new(8) })
    @data = data
    @possible_moves = []
    @piece_to_move = []
  end

  # Only Puts Method -> No tests needed
  def to_s
    system 'clear'
    puts
    puts "\e[35m    a  b  c  d  e  f  g  h \e[0m"
    print_board
    puts "\e[35m    a  b  c  d  e  f  g  h \e[0m"
    puts
  end

  def update_possible_moves(current_coords, piece_moves)
    @possible_moves = piece_moves
    @piece_to_move = current_coords
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
    initial_row(:black, 0)
    initial_pawn_row(:black, 1)
    initial_pawn_row(:white, 6)
    initial_row(:white, 7)
  end

  private

  def initial_pawn_row(color, number)
    8.times do |index|
      @data[number][index] = Pawn.new({ color: color, location: [number, index] })
    end
  end

  def initial_row(color, number)
    @data[number] = [
      Rook.new({ color: color, location: [number, 0] }),
      Knight.new({ color: color, location: [number, 1] }),
      Bishop.new({ color: color, location: [number, 2] }),
      Queen.new({ color: color, location: [number, 3] }),
      King.new({ color: color, location: [number, 4] }),
      Bishop.new({ color: color, location: [number, 5] }),
      Knight.new({ color: color, location: [number, 6] }),
      Rook.new({ color: color, location: [number, 7] })
    ]
  end

  def print_board
    @data.each_with_index do |row, index|
      print "\e[35m #{8 - index} \e[0m"
      print_row(row, index)
      print "\e[35m #{8 - index} \e[0m"
      puts
    end
  end

  def print_row(row, row_index)
    row.each_with_index do |square, index|
      background_color = select_background(row_index, index)
      print_square(square, background_color)
    end
  end

  # 46 = Cyan, 45 = Magenta, 47 = Light Gray, 100 = Dark Gray
  # def select_background(row_index, column_index)
  #   index_total = row_index + column_index
  #   if @possible_moves.any?([row_index, column_index])
  #     46
  #   elsif @piece_to_move == [row_index, column_index]
  #     45
  #   elsif index_total.even?
  #     47
  #   else
  #     100
  #   end
  # end

  def select_background(row_index, column_index)
    index_total = row_index + column_index
    if @piece_to_move == [row_index, column_index]
      45
    elsif index_total.even?
      even_background(row_index, column_index)
    else
      odd_background(row_index, column_index)
    end
  end

  # 107-white, 47-light gray
  def even_background(row_index, column_index)
    if @possible_moves.any?([row_index, column_index])
      46
    else
      47
    end
  end

  def odd_background(row_index, column_index)
    if @possible_moves.any?([row_index, column_index])
      44
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
