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
  class CoordinatesError < StandardError
    def message
      'Invalid coordinates! Enter column & row that has a chess piece.'
    end
  end

  # Declares error message when user enters invalid move
  class MoveError < StandardError
    def message
      'Invalid coordinates! Enter a valid column & row to move.'
    end
  end

  # Declares error message when user enters invalid move
  class PieceError < StandardError
    def message
      'Invalid piece! This piece can not move. Please enter a different column & row.'
    end
  end

  def initialize(board = Board.new)
    @board = board
  end

  # Public Script Method -> No tests needed (test inside methods)
  # Need to test outgoing command message
  def play
    @board.initial_placement
    @board.to_s
    # 8.times { player_turn }
    player_turn
  end

  # Script Method -> Test methods inside
  # Need to test outgoing command message
  def player_turn
    @board.display_valid_moves(select_piece_coordinates)
    @board.update(select_move_coordinates)
    @board.to_s
  end

  # Script Method -> No tests needed (test inside methods)
  def select_piece_coordinates
    puts 'What piece would you like to move?'
    input = gets.chomp
    validate_input(input)
    coords = translate_coordinates(input)
    validate_coordinates(coords)
    validiate_piece(coords)
    coords
  rescue StandardError => e
    puts e.message
    retry
  end

  # Script Method -> No tests needed (test inside methods)
  def select_move_coordinates
    puts 'Where would you like to move it?'
    input = gets.chomp
    validate_input(input)
    coords = translate_coordinates(input)
    # Need to validate move in the piece
    validate_move(coords)
    coords
  rescue StandardError => e
    puts e.message
    retry
  end

  # Completed Tests
  def validate_input(input)
    raise InputError unless input.match?(/^[a-h][1-8]$/)
  end

  # Completed Tests
  def validate_coordinates(coords)
    raise CoordinatesError unless @board.data[coords[:row]][coords[:column]]
  end

  # Completed Tests
  def validate_move(coords)
    unless @board.active_piece.moves.any?([coords[:row], coords[:column]])
      raise MoveError
    end
  end

  # Completed Tests
  def translate_coordinates(input)
    translator ||= NotationTranslator.new
    translator.translate_notation(input)
  end

  def validiate_piece(coords)
    piece = @board.data[coords[:row]][coords[:column]]
    raise PieceError unless piece.valid_moves?(@board.data)
  end
end
