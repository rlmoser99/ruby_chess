# frozen_string_literal: true

require_relative 'game_prompts'
require_relative 'serializer'

# contains script to play a chess game
class Game
  # Declares error message when user enters invalid input
  class InputError < StandardError
    def message
      'Invalid input! Enter column & row, for example: d2'
    end
  end

  # Declares error message when user enters an opponent's piece
  class CoordinatesError < StandardError
    def message
      'Invalid coordinates! Enter column & row of the correct color.'
    end
  end

  # Declares error message when user enters invalid coordinates
  class MoveError < StandardError
    def message
      'Invalid coordinates! Enter a valid column & row to move.'
    end
  end

  # Declares error message when user enters a piece without moves
  class PieceError < StandardError
    def message
      'Invalid piece! This piece does not have any legal moves.'
    end
  end

  include GamePrompts
  include Serializer

  def initialize(number, board = Board.new, current_turn = :white)
    @player_count = number
    @board = board
    @current_turn = current_turn
  end

  def setup_board
    @board.update_mode if @player_count == 1
    @board.initial_placement
  end

  def play
    @board.to_s
    player_turn until @board.game_over? || @player_count.zero?
    final_message
  end

  def player_turn
    puts "#{@current_turn.capitalize}'s turn!"
    if @player_count == 1 && @current_turn == :black
      computer_player_turn
    else
      human_player_turn
    end
    return unless @player_count.positive?

    @board.to_s
    switch_color
  end

  def human_player_turn
    select_piece_coordinates
    return unless @player_count.positive?

    @board.to_s
    move = select_move_coordinates
    @board.update(move)
  end

  def computer_player_turn
    sleep(1.5)
    coordinates = computer_select_random_piece
    @board.update_active_piece(coordinates)
    @board.to_s
    sleep(1.5)
    move = computer_select_random_move
    @board.update(move)
  end

  def select_piece_coordinates
    input = user_select_piece
    return unless @player_count.positive?

    coords = translate_coordinates(input)
    validate_piece_coordinates(coords)
    @board.update_active_piece(coords)
    validate_active_piece
  rescue StandardError => e
    puts e.message
    retry
  end

  def select_move_coordinates
    input = user_select_move
    coords = translate_coordinates(input)
    validate_move(coords)
    coords
  rescue StandardError => e
    puts e.message
    retry
  end

  def user_select_piece
    puts king_check_warning if @board.king_in_check?(@current_turn)
    input = user_input(user_piece_selection)
    validate_piece_input(input)
    resign_game if input.upcase == 'Q'
    save_game if input.upcase == 'S'
    input
  end

  def user_select_move
    puts en_passant_warning if @board.possible_en_passant?
    puts castling_warning if @board.possible_castling?
    input = user_input(user_move_selection)
    validate_move_input(input)
    resign_game if input.upcase == 'Q'
    input
  end

  def switch_color
    @current_turn = @current_turn == :white ? :black : :white
  end

  def computer_select_random_piece
    @board.random_black_piece
  end

  def computer_select_random_move
    @board.random_black_move
  end

  def validate_piece_input(input)
    raise InputError unless input.match?(/^[a-h][1-8]$|^[q]$|^[s]$/i)
  end

  def validate_move_input(input)
    raise InputError unless input.match?(/^[a-h][1-8]$/i)
  end

  def validate_piece_coordinates(coords)
    raise CoordinatesError unless @board.valid_piece?(coords, @current_turn)
  end

  def validate_move(coords)
    raise MoveError unless @board.valid_piece_movement?(coords)
  end

  def validate_active_piece
    raise PieceError unless @board.active_piece_moveable?
  end

  # creates a translator to change chess notation into hash of coordinates
  def translate_coordinates(input)
    translator ||= NotationTranslator.new
    translator.translate_notation(input)
  end

  private

  def user_input(prompt)
    puts prompt
    gets.chomp
  end
end
