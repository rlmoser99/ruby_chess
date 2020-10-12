# frozen_string_literal: true

require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'

RSpec.describe Piece do
  describe '#update_location' do
    subject(:piece) { described_class.new(board, { color: :white, location: [1, 2] }) }
    let(:board) { instance_double(Board) }

    before do
      allow(board).to receive(:add_observer)
    end

    it 'updates location' do
      piece.update_location(3, 4)
      expect(piece.location).to eq([3, 4])
    end
  end
end
