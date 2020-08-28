# frozen_string_literal: true

# contains logic for chess board
class Game
  # Declares error message when user enters invalid input
  class InputError < StandardError
    def message
      'Invalid input! Enter column & row, for example: d2'
    end
  end

  # Declares error message when user enters invalid move
  class MoveError < StandardError
    def message
      'Invalid input! Enter column & row that has a chess piece.'
    end
  end

  def initialize(board = ChessBoard.new)
    @board = board
  end

  # Public Script Method -> Test methods inside
  def play
    @board.initial_placement
    @board.to_s
    player_turn
    @board.to_s
  end

  # Script Method -> Test methods inside
  # Test Outgoing Command Message
  def player_turn
    piece_coords = select_piece_coordinates
    piece = @board.data[piece_coords[:row]][piece_coords[:column]]
    new_coords = select_move_coordinates
    @board.update(piece_coords, new_coords, piece)
  end

  # Script Method -> Test methods inside
  def select_piece_coordinates
    puts 'What piece would you like to move?'
    input = gets.chomp
    validate_input(input)
    validate_coordinates(translate_coordinates(input))
  rescue StandardError => e
    puts e.message
    retry
  end

  # Script Method -> Test methods inside
  def select_move_coordinates
    puts 'Where would you like to move it?'
    input = gets.chomp
    validate_input(input)
    translate_coordinates(input)
  rescue StandardError => e
    puts e.message
    retry
  end

  def validate_input(input)
    raise InputError unless input.match?(/^[a-h][1-8]$/)
  end

  def validate_coordinates(coords)
    raise MoveError unless @board.data[coords[:row]][coords[:column]]

    coords
  end

  def translate_coordinates(input)
    translator ||= NotationTranslator.new
    translator.translate_notation(input)
  end
end
