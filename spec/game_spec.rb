# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/chess_board'
require_relative '../lib/notation_translator'
require_relative '../lib/pieces/rook'

RSpec.describe Game do
  # subject(:game) { described_class.new }

  describe '#validate_coordinates' do
    subject(:game_validate) { described_class.new(board_validate) }
    let(:board_validate) { instance_double(ChessBoard) }
    let(:rook) { instance_double(Rook) }
    let(:test) { double('object') }

    before do
      # WANT THIS RECEIVE [0][0] AND TO RETURN AN OBJECT
      allow(board_validate).to receive(:data).and_return('3')
    end

    it 'does not raise an error' do
      expect { game_validate.validate_coordinates({ row: 0, column: 0 }) }.not_to raise_error
    end

    it 'returns coordinates' do
      coordinates = { row: 0, column: 0 }
      result = game_validate.validate_coordinates(coordinates)
      expect(result).to eq(coordinates)
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
