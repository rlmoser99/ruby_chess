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

  def initialize(board = Board.new)
    @board = board
    @current_turn = :white
    @mode = nil
  end

  # Public Script Method -> No tests needed (test inside methods)
  # Need to test any outgoing command messages & behavior of calling player_turn
  def play
    input = select_game_mode
    update_game_board_mode if input == '1'
    @board.initial_placement
    @board.to_s
    player_turn until @board.game_over?
    final_message
  end

  # Script Method -> Test methods inside
  # Need to test any outgoing command messages ??
  def player_turn
    puts "#{@current_turn.capitalize}'s turn!"
    if @mode == :computer && @current_turn == :black
      computer_player_turn
    else
      human_player_turn
    end
    @board.to_s
    switch_color
  end

  # Script Method -> No tests needed (test inside methods)
  # Need to test any outgoing command messages ??
  def select_piece_coordinates
    puts king_check_warning if @board.check?(@current_turn)
    input = user_input("What piece would you like to move, or \e[36m[Q]\e[0m to Quit?")
    validate_input(input)
    resign_game if input.upcase == 'Q'
    coords = translate_coordinates(input)
    validate_piece_coordinates(coords)
    @board.update_active_piece(coords)
    validate_active_piece
  rescue StandardError => e
    puts e.message
    retry
  end

  # Script Method -> No tests needed (test inside methods)
  # Need to test any outgoing command messages ??
  def select_move_coordinates
    puts en_passant_warning if @board.possible_en_passant?
    puts castling_warning if @board.possible_castling?
    input = user_input('Where would you like to move this piece?')
    validate_input(input)
    resign_game if input.upcase == 'Q'
    coords = translate_coordinates(input)
    validate_move(coords)
    coords
  rescue StandardError => e
    puts e.message
    retry
  end

  private

  def select_game_mode
    prompt = "Press \e[36m[1]\e[0m to play computer or \e[36m[2]\e[0m for a 2-player game."
    user_mode = user_input(prompt)
    return user_mode if user_mode.match?(/^[12]$/)

    puts 'Input error! Enter 1 or 2'
    select_game_mode
  end

  # Tested
  def update_game_board_mode
    @mode = :computer
    @board.update_game_mode
  end

  # Tested
  def human_player_turn
    select_piece_coordinates
    @board.to_s
    move = select_move_coordinates
    @board.update(move)
  end

  # Tested
  def computer_player_turn
    sleep(1.5)
    coordinates = computer_select_random_piece
    @board.update_active_piece(coordinates)
    @board.to_s
    sleep(1.5)
    move = computer_select_random_move
    @board.update(move)
  end

  # Tested
  def computer_select_random_piece
    @board.random_black_piece
  end

  # Tested
  def computer_select_random_move
    @board.random_black_move
  end

  # Tested
  def switch_color
    @current_turn = @current_turn == :white ? :black : :white
  end

  # Tested (private, but used in a public script method)
  def validate_input(input)
    raise InputError unless input.match?(/^[a-h][1-8]$|^[q]$/i)
  end

  # Tested (private, but used in a public script method)
  def validate_piece_coordinates(coords)
    raise CoordinatesError unless @board.valid_piece?(coords, @current_turn)
  end

  # Tested (private, but used in a public script method)
  def validate_move(coords)
    raise MoveError unless @board.valid_piece_movement?(coords)
  end

  # Tested (private, but used in a public script method)
  def validate_active_piece
    raise PieceError unless @board.active_piece_moveable?
  end

  # Tested (private, but used in a public script method)
  def translate_coordinates(input)
    translator ||= NotationTranslator.new
    translator.translate_notation(input)
  end

  def user_input(phrase)
    puts phrase
    gets.chomp
  end

  def en_passant_warning
    <<~HEREDOC
      To capture this pawn en passant, enter the \e[41mcapture coordinates\e[0m.
      \e[36mYour pawn will be moved to the square in front of it!\e[0m
    HEREDOC
  end

  def king_check_warning
    puts "\e[91mWARNING!\e[0m Your king is currently in check!"
  end

  def castling_warning
    puts "\e[91mWARNING!\e[0m If you choose to castle, the rook will move too!"
  end

  def previous_color
    @current_turn == :white ? 'Black' : 'White'
  end

  def resign_game
    puts "#{previous_color} wins because #{@current_turn} resigned!"
    exit(true)
  end

  # Tested
  def final_message
    if @board.check?(@current_turn)
      puts "#{previous_color} wins! The #{@current_turn} king is in checkmate."
    else
      puts "#{previous_color} wins in a stalemate!"
    end
  end
end
