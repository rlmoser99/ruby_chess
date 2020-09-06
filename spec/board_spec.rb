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

  describe '#update_final_coordinates' do
    subject(:board) { described_class.new(empty_data, rook) }
    let(:empty_data) { Array.new(8) { Array.new(8) } }
    let(:rook) { instance_double(Rook) }

    it 'updates coordinate with the chess piece' do
      coordinates = { row: 3, column: 0 }
      board.update_final_coordinates(coordinates)
      expect(board.data[3][0]).to eq(rook)
    end
  end

  describe '#update_original_coordinates' do
    subject(:board) { described_class.new(data_update, piece) }
    let(:data_update) { [[piece, nil], [nil, nil]] }
    let(:piece) { double('piece', location: [0, 0]) }

    it 'removes active_piece from original coordinates' do
      expect { board.update_original_coordinates }.to change { board.data[0][0] }.to(nil)
    end
  end
end
