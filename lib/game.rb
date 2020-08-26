# frozen_string_literal: true

# contains logic for chess board
class Game
  class InputError < StandardError
    def message
      'Invalid Input!'
    end
  end

  def initialize(board = ChessBoard.new)
    @board = board
  end

  def play
    @board.initial_placement
    @board.to_s
    player_turn
  end

  def player_turn
    piece = player_notation('What piece would you like to move?')
    notation = player_notation('Where would you like to move it?')
    # @board.update_data(piece, notation)
    # @board.to_s
  end

  def player_notation(instructions)
    puts instructions
    input = gets.chomp
    validate_input(input)
  rescue StandardError => e
    puts e.message
    retry
  end

  def validate_input(input)
    raise InputError unless input.match?(/^[a-h][1-8]$/)
  end
end
