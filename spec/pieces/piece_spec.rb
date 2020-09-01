# frozen_string_literal: true

require_relative '../../lib/pieces/piece'

RSpec.describe Piece do
  describe '#update_location' do
    subject(:piece) { described_class.new({ color: :white, location: [1, 2] }) }

    it 'updates location' do
      piece.update_location(3, 4)
      expect(piece.location).to eq([3, 4])
    end
  end
end
