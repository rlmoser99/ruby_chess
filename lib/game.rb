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
    player_turn
    # Need to switch current player
    # 8.times { player_turn }
  end

  # Script Method -> Test methods inside
  # Need to test outgoing command message
  def player_turn
    select_piece_coordinates
    move = select_move_coordinates
    @board.update(move)
    @board.to_s
  end

  # Script Method -> No tests needed (test inside methods)
  def select_piece_coordinates
    input = user_input('What piece would you like to move?')
    validate_input(input)
    coords = translate_coordinates(input)
    validate_piece_coordinates(coords)
    @board.update_active_piece(coords)
    validate_available_moves
  rescue StandardError => e
    puts e.message
    retry
  end

  # Script Method -> No tests needed (test inside methods)
  def select_move_coordinates
    @board.to_s
    input = user_input('Where would you like to move it?')
    validate_input(input)
    coords = translate_coordinates(input)
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

  def validate_piece_coordinates(coords)
    raise CoordinatesError unless @board.data[coords[:row]][coords[:column]]
  end

  def validate_move(coords)
    unless @board.valid_moves?(coords) || @board.valid_captures?(coords)
      raise MoveError
    end
  end

  # Completed Tests
  def translate_coordinates(input)
    translator ||= NotationTranslator.new
    translator.translate_notation(input)
  end

  def validate_available_moves
    raise PieceError unless @board.available_moves?
  end

  private

  def user_input(phrase)
    puts phrase
    gets.chomp
  end
end
