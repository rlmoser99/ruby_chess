# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/pawn'
require_relative '../lib/pieces/piece'

RSpec.describe Board do
  subject(:board) { described_class.new }

  describe '#initial_placement' do
    before do
      board.initial_placement
    end

    it 'has top row of black game pieces' do
      expect(board.data[0].all? { |piece| piece.color == :black }).to be true
    end

    it 'has second row of black game pieces' do
      expect(board.data[1].all? { |piece| piece.color == :black }).to be true
    end

    it 'has sixth row of white game pieces' do
      expect(board.data[6].all? { |piece| piece.color == :white }).to be true
    end

    it 'has bottom row of white game pieces' do
      expect(board.data[7].all? { |piece| piece.color == :white }).to be true
    end

    it 'has top row first Rook' do
      expect(board.data[0][0].instance_of?(Rook)).to be true
    end

    it 'has top row first Knight' do
      expect(board.data[0][1].instance_of?(Knight)).to be true
    end

    it 'has top row first Bishop' do
      expect(board.data[0][2].instance_of?(Bishop)).to be true
    end

    it 'has top row Queen' do
      expect(board.data[0][3].instance_of?(Queen)).to be true
    end

    it 'has top row King' do
      expect(board.data[0][4].instance_of?(King)).to be true
    end

    it 'has top row second Bishop' do
      expect(board.data[0][5].instance_of?(Bishop)).to be true
    end

    it 'has top rowsecond Knight' do
      expect(board.data[0][6].instance_of?(Knight)).to be true
    end

    it 'has top row second Rook' do
      expect(board.data[0][7].instance_of?(Rook)).to be true
    end

    it 'has second row of pawns' do
      expect(board.data[1].all? { |piece| piece.instance_of?(Pawn) }).to be true
    end

    it 'has sixth row of pawns' do
      expect(board.data[6].all? { |piece| piece.instance_of?(Pawn) }).to be true
    end

    it 'has bottom row first Rook' do
      expect(board.data[7][0].instance_of?(Rook)).to be true
    end

    it 'has bottom row first Knight' do
      expect(board.data[7][1].instance_of?(Knight)).to be true
    end

    it 'has bottom row first Bishop' do
      expect(board.data[7][2].instance_of?(Bishop)).to be true
    end

    it 'has bottom row Queen' do
      expect(board.data[7][3].instance_of?(Queen)).to be true
    end

    it 'has bottom row King' do
      expect(board.data[7][4].instance_of?(King)).to be true
    end

    it 'has bottom row second Bishop' do
      expect(board.data[7][5].instance_of?(Bishop)).to be true
    end

    it 'has bottom row second Knight' do
      expect(board.data[7][6].instance_of?(Knight)).to be true
    end

    it 'has bottom row second Rook' do
      expect(board.data[7][7].instance_of?(Rook)).to be true
    end
  end

  describe '#update_new_coordinates' do
    subject(:board) { described_class.new(empty_data, rook) }
    let(:empty_data) { Array.new(8) { Array.new(8) } }
    let(:rook) { instance_double(Rook) }

    it 'updates coordinate with the chess piece' do
      coordinates = { row: 3, column: 0 }
      board.update_new_coordinates(coordinates)
      expect(board.data[3][0]).to eq(rook)
    end
  end

  describe '#remove_old_piece' do
    subject(:board) { described_class.new(data_update, piece) }
    let(:data_update) { [[piece, nil], [nil, nil]] }
    let(:piece) { double('piece', location: [0, 0]) }

    it 'removes active_piece from original coordinates' do
      expect { board.remove_old_piece }.to change { board.data[0][0] }.to(nil)
    end
  end

  describe '#update_active_piece' do
    subject(:board) { described_class.new(data_update) }
    let(:data_update) { [[piece, nil], [nil, nil]] }
    let(:piece) { double(Piece, location: [0, 0]) }

    it 'updates active piece with coordinates' do
      coordinates = { row: 0, column: 0 }
      board.update_active_piece(coordinates)
      expect(board.active_piece).to eq(piece)
    end
  end

  describe '#active_piece_moveable?' do
    subject(:board_moveable) { described_class.new(data_moveable, piece) }
    let(:data_moveable) { [[piece, nil], [nil, nil]] }
    let(:piece) { double(Piece, location: [0, 0]) }

    context 'when there is one current_move' do
      before do
        allow(piece).to receive(:current_moves).and_return([0, 1])
        allow(piece).to receive(:current_captures)
      end

      it 'returns true' do
        result = board_moveable.active_piece_moveable?
        expect(result).to be true
      end
    end

    context 'when there is one current_captures' do
      before do
        allow(piece).to receive(:current_moves).and_return([])
        allow(piece).to receive(:current_captures).and_return([1, 1])
      end

      it 'returns true' do
        result = board_moveable.active_piece_moveable?
        expect(result).to be true
      end
    end

    context 'when there is no current_move or current_capture' do
      before do
        allow(piece).to receive(:current_moves).and_return([])
        allow(piece).to receive(:current_captures).and_return([])
      end

      it 'returns false' do
        result = board_moveable.active_piece_moveable?
        expect(result).to be false
      end
    end
  end

  describe '#valid_piece_movement?' do
    context 'when coordinates matches a valid move' do
      subject(:board_valid) { described_class.new(data_valid, piece, [[1, 0]]) }
      let(:data_valid) { [[piece, nil], [nil, nil]] }
      let(:piece) { double(Piece, location: [0, 0]) }

      it 'returns true' do
        coordinates = { row: 1, column: 0 }
        result = board_valid.valid_piece_movement?(coordinates)
        expect(result).to be true
      end
    end

    context 'when coordinates matches a valid capture' do
      subject(:board_valid) { described_class.new(data_valid, piece, [], [[1, 0]]) }
      let(:data_valid) { [[piece, nil], [nil, nil]] }
      let(:piece) { double(Piece, location: [0, 0]) }

      it 'returns true' do
        coordinates = { row: 1, column: 0 }
        result = board_valid.valid_piece_movement?(coordinates)
        expect(result).to be true
      end
    end

    context 'when coordinates does not matches valid move or capture' do
      subject(:board_valid) { described_class.new(data_valid, piece, [], [[1, 0]]) }
      let(:data_valid) { [[piece, nil], [nil, nil]] }
      let(:piece) { double(Piece, location: [0, 0]) }

      it 'returns false' do
        coordinates = { row: 2, column: 0 }
        result = board_valid.valid_piece_movement?(coordinates)
        expect(result).to be false
      end
    end
  end

  describe '#update_active_piece_location' do
    subject(:board_location) { described_class.new(data_location, piece) }
    let(:data_location) { [[piece, nil], [nil, nil]] }
    let(:piece) { double(Piece, location: [0, 0]) }

    it 'sends coordinates to piece' do
      coordinates = { row: 1, column: 0 }
      expect(piece).to receive(:update_location).with(1, 0)
      board_location.update_active_piece_location(coordinates)
    end
  end

  describe '#reset_active_piece_values' do
    subject(:board_values) { described_class.new(data_values, piece, [[1, 1]], [[0, 1]]) }
    let(:data_values) { [[piece, nil], [nil, nil]] }
    let(:piece) { double(Piece, location: [0, 0]) }

    it 'sets active_piece to nil' do
      board_values.reset_active_piece_values
      expect(board_values.active_piece).to be_nil
    end

    it 'sets valid_moves to be an empty array' do
      board_values.reset_active_piece_values
      valid_moves = board_values.instance_variable_get(:@valid_moves)
      expect(valid_moves).to be_empty
    end

    it 'sets valid_captures to be an empty array' do
      board_values.reset_active_piece_values
      valid_captures = board_values.instance_variable_get(:@valid_captures)
      expect(valid_captures).to be_empty
    end
  end
end
