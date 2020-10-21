# frozen_string_literal: true

require_relative '../../lib/movement/castling_movement'
require_relative '../../lib/movement/basic_movement'
require_relative '../../lib/board'
require_relative '../../lib/pieces/piece'

RSpec.describe CastlingMovement do
  describe '#update_location' do
    subject(:movement) { described_class.new }
    let(:board) { instance_double(Board) }
    let(:black_king) { instance_double(Piece, location: [0, 4]) }
    let(:black_rook) { instance_double(Piece, location: [0, 7]) }
    let(:data) do
      [
        [nil, nil, nil, nil, black_king, nil, nil, black_rook],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    end
    before do
      allow(board).to receive(:data).and_return(data)
      allow(board).to receive(:active_piece).and_return(black_king)
      allow(black_king).to receive(:update_location).with(0, 6)
      allow(black_rook).to receive(:update_location).with(0, 5)
      allow(movement).to receive(:find_castling_rook).and_return(black_rook)
    end

    it 'updates new coordinates with king' do
      coordinates = { row: 0, column: 6 }
      movement.update_pieces(board, coordinates)
      expect(movement.board.data[0][6]).to eq(black_king)
    end

    it 'removes king from original location' do
      coordinates = { row: 0, column: 6 }
      movement.update_pieces(board, coordinates)
      expect(movement.board.data[0][4]).to be nil
    end

    it 'sends #update_location (with coords) to king' do
      expect(black_king).to receive(:update_location).with(0, 6)
      coordinates = { row: 0, column: 6 }
      movement.update_pieces(board, coordinates)
    end

    it 'removes rook from original location' do
      coordinates = { row: 0, column: 6 }
      movement.update_pieces(board, coordinates)
      expect(movement.board.data[0][7]).to be nil
    end

    it 'updates castling coordinates with rook' do
      coordinates = { row: 0, column: 6 }
      movement.update_pieces(board, coordinates)
      expect(movement.board.data[0][5]).to eq(black_rook)
    end

    it 'sends #update_location (with castling coords) to rook' do
      expect(black_rook).to receive(:update_location).with(0, 5)
      coordinates = { row: 0, column: 6 }
      movement.update_pieces(board, coordinates)
    end
  end

  describe '#find_castling_rook' do
    subject(:movement) { described_class.new }
    let(:board) { instance_double(Board) }
    let(:black_king) { instance_double(Piece, location: [0, 4]) }
    let(:black_rook) { instance_double(Piece, location: [0, 7]) }
    let(:data) do
      [
        [nil, nil, nil, nil, black_king, nil, nil, black_rook],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    end

    it 'returns king-side rook' do
      allow(board).to receive(:data).and_return(data)
      movement.instance_variable_set(:@board, board)
      movement.instance_variable_set(:@row, 0)
      movement.instance_variable_set(:@column, 6)
      result = movement.send(:find_castling_rook)
      expect(result).to eq(black_rook)
    end
  end
end
