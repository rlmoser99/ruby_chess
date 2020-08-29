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
  class EmptySquareError < StandardError
    def message
      'Invalid input! Enter column & row that has a chess piece.'
    end
  end

  # Declares error message when user enters invalid move
  class MoveError < StandardError
    def message
      'Invalid input! Enter a valid (green) column & row'
    end
  end

  def initialize(board = ChessBoard.new)
    @board = board
  end

  # Public Script Method -> No tests needed (test inside methods)
  def play
    @board.initial_placement
    @board.to_s
    player_turn
    @board.to_s
  end

  # Script Method -> Test methods inside
  # Need to test outgoing command message
  def player_turn
    piece_coords = select_piece_coordinates
    piece = @board.data[piece_coords[:row]][piece_coords[:column]]
    piece.update_moves
    @board.update_possible_moves([piece_coords[:row], piece_coords[:column]], piece.moves)
    @board.to_s
    @board.update_possible_moves([], [])
    new_coords = select_move_coordinates(piece)
    # Need to update that piece's new location.
    @board.update(piece_coords, new_coords, piece)
  end

  # Script Method -> No tests needed (test inside methods)
  def select_piece_coordinates
    puts 'What piece would you like to move?'
    input = gets.chomp
    validate_input(input)
    validate_coordinates(translate_coordinates(input))
  rescue StandardError => e
    puts e.message
    retry
  end

  # Script Method -> No tests needed (test inside methods)
  def select_move_coordinates(piece)
    puts 'Where would you like to move it?'
    input = gets.chomp
    validate_input(input)
    validate_move(piece, translate_coordinates(input))
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
    raise EmptySquareError unless @board.data[coords[:row]][coords[:column]]

    coords
  end

  def validate_move(piece, coords)
    raise MoveError unless piece.moves.any?([coords[:row], coords[:column]])

    coords
  end

  # Completed Tests
  def translate_coordinates(input)
    translator ||= NotationTranslator.new
    translator.translate_notation(input)
  end
end
