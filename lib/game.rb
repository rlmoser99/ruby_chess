# frozen_string_literal: true

require_relative 'game_prompts'

# contains script to play a chess game
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
      'Invalid coordinates! Enter column & row of the correct color.'
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
      'Invalid piece! This piece does not have any legal moves.'
    end
  end

  include GamePrompts

  def initialize(board = Board.new)
    @board = board
    @current_turn = :white
  end

  # script to play an entire game of chess
  def play
    input = select_game_mode
    @board.update_mode if input == '1'
    @board.initial_placement
    @board.to_s
    player_turn until @board.game_over?
    final_message
  end

  private

  # script for computer/human turn, display board & switches @current_turn color
  def player_turn
    puts "#{@current_turn.capitalize}'s turn!"
    if @board.mode == :computer && @current_turn == :black
      computer_player_turn
    else
      human_player_turn
    end
    @board.to_s
    switch_color
  end

  # script for human turn to choose a piece and then a legal move/capture
  def human_player_turn
    select_piece_coordinates
    @board.to_s
    move = select_move_coordinates
    @board.update(move)
  end

  # script for computer to select random piece and then a random move/capture
  def computer_player_turn
    sleep(1.5)
    coordinates = computer_select_random_piece
    @board.update_active_piece(coordinates)
    @board.to_s
    sleep(1.5)
    move = computer_select_random_move
    @board.update(move)
  end

  # script for user to input coordinates, then selected piece will be validated
  def select_piece_coordinates
    input = user_select_piece
    coords = translate_coordinates(input)
    validate_piece_coordinates(coords)
    @board.update_active_piece(coords)
    validate_active_piece
  rescue StandardError => e
    puts e.message
    retry
  end

  # script for user to input coordinates, then selected move will be validated
  def select_move_coordinates
    input = user_select_move
    coords = translate_coordinates(input)
    validate_move(coords)
    coords
  rescue StandardError => e
    puts e.message
    retry
  end

  # script for user to input piece to move, or quit the game
  def user_select_piece
    puts king_check_warning if @board.king_in_check?(@current_turn)
    input = user_input(user_piece_selection)
    validate_input(input)
    resign_game if input.upcase == 'Q'
    input
  end

  # script for user to input move, or quit the game
  def user_select_move
    puts en_passant_warning if @board.possible_en_passant?
    puts castling_warning if @board.possible_castling?
    input = user_input(user_move_selection)
    validate_input(input)
    resign_game if input.upcase == 'Q'
    input
  end

  # script for user to input game mode, repeats for invalid input
  def select_game_mode
    user_mode = user_input(game_mode_choices)
    return user_mode if user_mode.match?(/^[12]$/)

    puts 'Input error! Enter 1-digit (1 or 2).'
    select_game_mode
  end

  # alternates between :black and :white for #player_turn
  def switch_color
    @current_turn = @current_turn == :white ? :black : :white
  end

  # returns a random black piece for :computer mode
  def computer_select_random_piece
    @board.random_black_piece
  end

  # returns a random black move for :computer mode
  def computer_select_random_move
    @board.random_black_move
  end

  # raises an error if input is not valid
  def validate_input(input)
    raise InputError unless input.match?(/^[a-h][1-8]$|^[q]$/i)
  end

  # raises an error if coordinates is not a valid piece
  def validate_piece_coordinates(coords)
    raise CoordinatesError unless @board.valid_piece?(coords, @current_turn)
  end

  # raises an error if coordinates is not a valid move/capture
  def validate_move(coords)
    raise MoveError unless @board.valid_piece_movement?(coords)
  end

  # raises an error if piece selected does not have legal moves/captures
  def validate_active_piece
    raise PieceError unless @board.active_piece_moveable?
  end

  # creates a translator to change chess notation into hash of coordinates
  def translate_coordinates(input)
    translator ||= NotationTranslator.new
    translator.translate_notation(input)
  end

  # outputs a prompt and returns the user's input
  def user_input(prompt)
    puts prompt
    gets.chomp
  end
end
