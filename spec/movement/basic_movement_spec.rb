# frozen_string_literal: true

require_relative '../../lib/movement/basic_movement'
require_relative '../../lib/board'
require_relative '../../lib/pieces/piece'

RSpec.describe BasicMovement do
  describe '#update_location' do
    subject(:movement) { described_class.new }
    let(:board) { instance_double(Board) }
    let(:piece) { instance_double(Piece, location: [6, 3]) }
    let(:data) do
      [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, piece, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    end

    before do
      allow(board).to receive(:data).and_return(data)
      allow(board).to receive(:active_piece).and_return(piece)
      allow(piece).to receive(:update_location).with(5, 3)
    end

    it 'updates new coordinates with piece' do
      coordinates = { row: 5, column: 3 }
      movement.update_pieces(board, coordinates)
      expect(movement.board.data[5][3]).to eq(piece)
    end

    it 'removes piece from original location' do
      coordinates = { row: 5, column: 3 }
      movement.update_pieces(board, coordinates)
      expect(movement.board.data[6][3]).to be nil
    end

    it 'sends #update_location (with coords) to piece' do
      expect(piece).to receive(:update_location).with(5, 3)
      coordinates = { row: 5, column: 3 }
      movement.update_pieces(board, coordinates)
    end
  end
end
