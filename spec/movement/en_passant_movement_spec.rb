# frozen_string_literal: true

require_relative '../../lib/movement/en_passant_movement'
require_relative '../../lib/movement/basic_movement'
require_relative '../../lib/board'
require_relative '../../lib/pieces/pawn'

RSpec.describe EnPassantMovement do
  describe '#update_pieces' do
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
      allow(white_pawn).to receive(:update_location).with(2, 2)
      allow(movement).to receive(:update_en_passant_moves)

      coordinates = { row: 3, column: 2 }
      movement.update_pieces(board, coordinates)
    end

    it 'updates the board' do
      expect(movement.board).to eq(board)
    end

    it 'updates the row' do
      expect(movement.row).to eq(3)
    end

    it 'updates the column' do
      expect(movement.column).to eq(2)
    end

    it 'calls #update_en_passant_moves' do
      expect(movement).to receive(:update_en_passant_moves)
      coordinates = { row: 5, column: 3 }
      movement.update_pieces(board, coordinates)
    end
  end

  describe '#update_active_pawn_coordinates' do
    subject(:movement) { described_class.new(board, 3, 2) }
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

    it 'updates new pawn coordinates to active piece' do
      allow(board).to receive(:data).and_return(data)
      allow(board).to receive(:active_piece).and_return(white_pawn)
      movement.update_active_pawn_coordinates
      new_location = movement.board.data[2][2]
      expect(new_location).to be(white_pawn)
    end
  end

  describe '#remove_en_passant_capture' do
    subject(:movement) { described_class.new(board, 3, 2) }
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

    it 'removes opposing pawn from the board' do
      allow(board).to receive(:data).and_return(data)
      allow(board).to receive(:active_piece).and_return(white_pawn)
      movement.remove_en_passant_capture
      old_location = movement.board.data[3][2]
      expect(old_location).to be nil
    end
  end

  describe '#update_active_piece_location' do
    subject(:movement) { described_class.new(board, 3, 2) }
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

    it 'sends #update_location to the active piece' do
      allow(board).to receive(:data).and_return(data)
      allow(board).to receive(:active_piece).and_return(white_pawn)
      expect(white_pawn).to receive(:update_location).with(2, 2)
      movement.update_active_piece_location
    end
  end
end
