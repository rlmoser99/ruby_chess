# frozen_string_literal: true

require_relative '../../lib/movement/en_passant_movement'
require_relative '../../lib/movement/basic_movement'
require_relative '../../lib/board'
require_relative '../../lib/pieces/pawn'

RSpec.describe EnPassantMovement do
  describe '#update_location' do
    subject(:movement) { described_class.new }
    let(:board) { instance_double(Board) }
    let(:white_pawn) { instance_double(Pawn, location: [3, 1], rank_direction: -1) }
    let(:black_pawn) { instance_double(Pawn, location: [3, 2]) }
    let(:data) do
      [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, white_pawn, black_pawn, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    end

    before do
      allow(board).to receive(:data).and_return(data)
      allow(board).to receive(:active_piece).and_return(white_pawn)
      allow(board).to receive(:delete_observer)
      allow(white_pawn).to receive(:update_location).with(2, 2)
    end

    it 'removes observer from captured pawn' do
      expect(board).to receive(:delete_observer).with(black_pawn)
      coordinates = { row: 3, column: 2 }
      movement.update_pieces(board, coordinates)
    end

    it 'updates altered coordinates with pawn' do
      coordinates = { row: 3, column: 2 }
      movement.update_pieces(board, coordinates)
      expect(movement.board.data[2][2]).to eq(white_pawn)
    end

    it 'removes pawn from original location' do
      coordinates = { row: 3, column: 2 }
      movement.update_pieces(board, coordinates)
      expect(movement.board.data[3][1]).to be nil
    end

    it 'removes captured pawn from captured location' do
      coordinates = { row: 3, column: 2 }
      movement.update_pieces(board, coordinates)
      expect(movement.board.data[3][2]).to be nil
    end

    it 'sends #update_location (with altered coords) to pawn' do
      expect(white_pawn).to receive(:update_location).with(2, 2)
      coordinates = { row: 3, column: 2 }
      movement.update_pieces(board, coordinates)
    end
  end
end
