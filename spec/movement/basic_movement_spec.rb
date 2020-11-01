# frozen_string_literal: true

require_relative '../../lib/movement/basic_movement'
require_relative '../../lib/board'
require_relative '../../lib/pieces/piece'

RSpec.describe BasicMovement do
  describe '#update_pieces' do
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
      coordinates = { row: 5, column: 3 }
      movement.update_pieces(board, coordinates)
    end

    it 'updates the board' do
      expect(movement.board).to eq(board)
    end

    it 'updates the row' do
      expect(movement.row).to eq(5)
    end

    it 'updates the column' do
      expect(movement.column).to eq(3)
    end

    it 'calls #update_basic_moves' do
      expect(movement).to receive(:update_basic_moves)
      coordinates = { row: 5, column: 3 }
      movement.update_pieces(board, coordinates)
    end
  end

  describe '#remove_capture_piece_observer' do
    subject(:movement) { described_class.new(board, 5, 4) }
    let(:board) { instance_double(Board) }
    let(:wpn) { instance_double(Piece, location: [6, 3]) }
    let(:bpn) { instance_double(Piece, location: [5, 4]) }
    let(:data) do
      [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, bpn, nil, nil, nil],
        [nil, nil, nil, wpn, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    end

    it 'removes observer from captured piece' do
      allow(board).to receive(:data).and_return(data)
      allow(board).to receive(:active_piece).and_return(wpn)
      expect(board).to receive(:delete_observer)
      movement.remove_capture_piece_observer
    end
  end

  describe '#update_new_coordinates' do
    subject(:movement) { described_class.new(board, 5, 4) }
    let(:board) { instance_double(Board) }
    let(:wpn) { instance_double(Piece, location: [6, 3]) }
    let(:bpn) { instance_double(Piece, location: [5, 4]) }
    let(:data) do
      [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, bpn, nil, nil, nil],
        [nil, nil, nil, wpn, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    end

    it 'updates value of board coodinates to active piece' do
      allow(board).to receive(:data).and_return(data)
      allow(board).to receive(:active_piece).and_return(wpn)
      movement.update_new_coordinates
      new_location = movement.board.data[5][4]
      expect(new_location).to eq(wpn)
    end
  end

  describe '#remove_original_piece' do
    subject(:movement) { described_class.new(board, 5, 4) }
    let(:board) { instance_double(Board) }
    let(:wpn) { instance_double(Piece, location: [6, 3]) }
    let(:bpn) { instance_double(Piece, location: [5, 4]) }
    let(:data) do
      [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, bpn, nil, nil, nil],
        [nil, nil, nil, wpn, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    end

    it 'updates location of the old active piece' do
      allow(board).to receive(:data).and_return(data)
      allow(board).to receive(:active_piece).and_return(wpn)
      movement.remove_original_piece
      old_location = movement.board.data[6][3]
      expect(old_location).to be nil
    end
  end

  describe '#update_active_piece_location' do
    subject(:movement) { described_class.new(board, 5, 4) }
    let(:board) { instance_double(Board) }
    let(:wpn) { instance_double(Piece, location: [6, 3]) }
    let(:bpn) { instance_double(Piece, location: [5, 4]) }
    let(:data) do
      [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, bpn, nil, nil, nil],
        [nil, nil, nil, wpn, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    end

    it 'sends #update_location to the active piece' do
      allow(board).to receive(:data).and_return(data)
      allow(board).to receive(:active_piece).and_return(wpn)
      expect(wpn).to receive(:update_location).with(5, 4)
      movement.update_active_piece_location
    end
  end
end
