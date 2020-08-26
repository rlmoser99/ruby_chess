# frozen_string_literal: true

require_relative '../lib/notation_translator'

RSpec.describe NotationTranslator do
  subject(:translator) { described_class.new }

  describe '#translate_position' do
    it 'returns hash row:0 column:0' do
      user_input = 'a8'
      result = translator.translate_notation(user_input)
      expect(result).to eq({ row: 0, column: 0 })
    end

    it 'returns hash row:0 column:1' do
      user_input = 'b8'
      result = translator.translate_notation(user_input)
      expect(result).to eq({ row: 0, column: 1 })
    end

    it 'returns hash row:1 column:0' do
      user_input = 'a7'
      result = translator.translate_notation(user_input)
      expect(result).to eq({ row: 1, column: 0 })
    end

    it 'returns hash row:1 column:1' do
      user_input = 'b7'
      result = translator.translate_notation(user_input)
      expect(result).to eq({ row: 1, column: 1 })
    end
  end
end
