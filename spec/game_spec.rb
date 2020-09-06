# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/notation_translator'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/pawn'

RSpec.describe Game do
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
  # subject(:game) { described_class.new }

  describe '#validate_input' do
    subject(:game_input) { described_class.new }

    context 'when input is valid' do
      it 'does not raise an error' do
        expect { game_input.validate_input('c7') }.not_to raise_error
      end
    end

    context 'when input is not valid' do
      it 'raises an error' do
        expect { game_input.validate_input('7c') }.to raise_error(Game::InputError)
      end
      it 'raises an error' do
        expect { game_input.validate_input('77') }.to raise_error(Game::InputError)
      end
      it 'raises an error' do
        expect { game_input.validate_input('cc') }.to raise_error(Game::InputError)
      end
    end
  end

  describe '#translate_coordinates' do
    subject(:game_translate) { described_class.new }

    it 'sends command message to NotationTranslator' do
      user_input = 'd2'
      expect_any_instance_of(NotationTranslator).to receive(:translate_notation).with(user_input)
      game_translate.translate_coordinates(user_input)
    end
  end
end
