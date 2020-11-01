# frozen_string_literal: true

require_relative '../lib/notation_translator'

RSpec.describe NotationTranslator do
  subject(:translator) { described_class.new }

  describe '#translate_position' do
    context 'when user input is a8' do
      it 'returns row:0 column:0' do
        user_input = 'a8'
        result = translator.translate_notation(user_input)
        expect(result).to eq({ row: 0, column: 0 })
      end
    end

    context 'when user input is b7' do
      it 'returns row:1 column:1' do
        user_input = 'b7'
        result = translator.translate_notation(user_input)
        expect(result).to eq({ row: 1, column: 1 })
      end
    end

    context 'when user input is c6' do
      it 'returns row:2 column:2' do
        user_input = 'c6'
        result = translator.translate_notation(user_input)
        expect(result).to eq({ row: 2, column: 2 })
      end
    end

    context 'when user input is d5' do
      it 'returns row:3 column:3' do
        user_input = 'd5'
        result = translator.translate_notation(user_input)
        expect(result).to eq({ row: 3, column: 3 })
      end
    end

    context 'when user input is e4' do
      it 'returns row:4 column:4' do
        user_input = 'e4'
        result = translator.translate_notation(user_input)
        expect(result).to eq({ row: 4, column: 4 })
      end
    end

    context 'when user input is f3' do
      it 'returns row:5 column:5' do
        user_input = 'f3'
        result = translator.translate_notation(user_input)
        expect(result).to eq({ row: 5, column: 5 })
      end
    end

    context 'when user input is g2' do
      it 'returns row:6 column:6' do
        user_input = 'g2'
        result = translator.translate_notation(user_input)
        expect(result).to eq({ row: 6, column: 6 })
      end
    end

    context 'when user input is h1' do
      it 'returns row:7 column:7' do
        user_input = 'h1'
        result = translator.translate_notation(user_input)
        expect(result).to eq({ row: 7, column: 7 })
      end
    end
  end
end
