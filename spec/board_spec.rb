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
        allow(piece).to receive(:moves).and_return([0, 1])
        allow(piece).to receive(:captures)
        allow(piece).to receive(:update)
      end

      it 'returns true' do
        result = board_moveable.active_piece_moveable?
        expect(result).to be true
      end
    end

    context 'when there is one current_captures' do
      before do
        allow(piece).to receive(:moves).and_return([])
        allow(piece).to receive(:captures).and_return([1, 1])
        allow(piece).to receive(:update)
      end

      it 'returns true' do
        result = board_moveable.active_piece_moveable?
        expect(result).to be true
      end
    end

    context 'when there is no current_move or current_capture' do
      before do
        allow(piece).to receive(:moves).and_return([])
        allow(piece).to receive(:captures).and_return([])
        allow(piece).to receive(:update)
      end

      it 'returns false' do
        result = board_moveable.active_piece_moveable?
        expect(result).to be false
      end
    end
  end

  describe '#valid_piece_movement?' do
    context 'when coordinates matches a valid move' do
      subject(:board_valid) { described_class.new(data_valid, piece) }
      let(:data_valid) { [[piece, nil], [nil, nil]] }
      let(:piece) { double(Piece, location: [0, 0]) }

      it 'returns true' do
        allow(piece).to receive(:moves).and_return([[1, 0]])
        coordinates = { row: 1, column: 0 }
        result = board_valid.valid_piece_movement?(coordinates)
        expect(result).to be true
      end
    end

    context 'when coordinates matches a valid capture' do
      subject(:board_valid) { described_class.new(data_valid, piece) }
      let(:data_valid) { [[piece, nil], [nil, nil]] }
      let(:piece) { double(Piece, location: [0, 0]) }

      it 'returns true' do
        allow(piece).to receive(:moves).and_return([])
        allow(piece).to receive(:captures).and_return([[1, 0]])
        coordinates = { row: 1, column: 0 }
        result = board_valid.valid_piece_movement?(coordinates)
        expect(result).to be true
      end
    end

    context 'when coordinates does not matches valid move or capture' do
      subject(:board_valid) { described_class.new(data_valid, piece) }
      let(:data_valid) { [[piece, nil], [nil, nil]] }
      let(:piece) { double(Piece, location: [0, 0]) }

      it 'returns false' do
        allow(piece).to receive(:moves).and_return([])
        allow(piece).to receive(:captures).and_return([1, 0])
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

    before do
      allow(piece).to receive(:update).with(board_location)
      allow(piece).to receive(:update_location).with(1, 0)
    end

    it 'sends update_location with coordinates to piece' do
      coordinates = { row: 1, column: 0 }
      expect(piece).to receive(:update_location).with(1, 0)
      board_location.update_active_piece_location(coordinates)
    end

    # it 'sends update with board.self to piece' do
    #   coordinates = { row: 1, column: 0 }
    #   expect(piece).to receive(:update).with(board_location)
    #   board_location.update_active_piece_location(coordinates)
    # end
  end

  describe '#reset_board_values' do
    subject(:board_values) { described_class.new(data_values, piece) }
    let(:data_values) { [[piece, nil], [nil, nil]] }
    let(:piece) { double(Piece, location: [0, 0]) }

    it 'sets previous_piece to active_piece' do
      board_values.reset_board_values
      expect(board_values.previous_piece).to eq(piece)
    end

    it 'sets active_piece to nil' do
      board_values.reset_board_values
      expect(board_values.active_piece).to be_nil
    end
  end

  describe '#piece?' do
    subject(:board_piece) { described_class.new(data_piece, pawn) }
    let(:data_piece) { [[pawn, nil], [nil, nil]] }
    let(:pawn) { instance_double(Piece) }

    context 'when coordinates is a piece' do
      it 'returns true' do
        coordinates = { row: 0, column: 0 }
        results = board_piece.piece?(coordinates)
        expect(results).to be true
      end
    end

    context 'when coordinates is not a piece' do
      it 'returns false' do
        coordinates = { row: 1, column: 0 }
        results = board_piece.piece?(coordinates)
        expect(results).to be false
      end
    end
  end

  describe '#update' do
    context 'when capture is pawn en passant' do
      subject(:board) { described_class.new(data, black_pawn) }
      let(:white_pawn) { instance_double(Pawn, color: :white, location: [4, 3], symbol: " \u265F ", en_passant: true) }
      let(:black_pawn) { instance_double(Pawn, color: :black, location: [4, 2], symbol: " \u265F ", en_passant: false) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, black_pawn, white_pawn, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        board.instance_variable_set(:@previous_piece, white_pawn)
      end

      it 'calls update_en_passant' do
        coords = { row: 4, column: 3 }
        expect(board).to receive(:update_en_passant).with(coords)
        board.update(coords)
      end
    end

    context 'when capture is not pawn en passant' do
      context 'when previous piece location does not match move coords' do
        subject(:board) { described_class.new(data, black_pawn) }
        let(:white_pawn) { instance_double(Pawn, color: :white, location: [4, 3], symbol: " \u265F ", en_passant: true) }
        let(:black_pawn) { instance_double(Pawn, color: :black, location: [4, 2], symbol: " \u265F ", en_passant: false) }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, black_pawn, white_pawn, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        before do
          board.instance_variable_set(:@previous_piece, white_pawn)
          allow(black_pawn).to receive(:update_location)
          allow(black_pawn).to receive(:update)
        end

        it 'does not call update_en_passant' do
          coords = { row: 5, column: 2 }
          expect(board).not_to receive(:update_en_passant).with(coords)
          board.update(coords)
        end
      end

      context 'when previous piece is not a pawn' do
        subject(:board) { described_class.new(data, black_pawn) }
        let(:white_rook) { instance_double(Rook, color: :white, location: [4, 3], symbol: " \u265C ") }
        let(:black_pawn) { instance_double(Pawn, color: :black, location: [4, 2], symbol: " \u265F ", en_passant: false) }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, black_pawn, white_rook, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        before do
          board.instance_variable_set(:@previous_piece, white_rook)
          allow(black_pawn).to receive(:update_location)
          allow(black_pawn).to receive(:update)
        end

        it 'does not call update_en_passant' do
          coords = { row: 4, column: 3 }
          expect(board).not_to receive(:update_en_passant).with(coords)
          board.update(coords)
        end
      end

      context 'when active piece is not a pawn' do
        subject(:board) { described_class.new(data, black_rook) }
        let(:white_pawn) { instance_double(Pawn, color: :white, location: [4, 3], symbol: " \u265F ", en_passant: true) }
        let(:black_rook) { instance_double(Rook, color: :black, location: [4, 2], symbol: " \u265C ") }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, black_rook, white_pawn, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        before do
          board.instance_variable_set(:@previous_piece, white_pawn)
          allow(black_rook).to receive(:update_location)
          allow(black_rook).to receive(:update)
        end

        it 'does not call update_en_passant' do
          coords = { row: 4, column: 3 }
          expect(board).not_to receive(:update_en_passant).with(coords)
          board.update(coords)
        end
      end

      context 'when previous piece is not en passant' do
        subject(:board) { described_class.new(data, black_pawn) }
        let(:white_pawn) { instance_double(Pawn, color: :white, location: [4, 3], symbol: " \u265F ", en_passant: false) }
        let(:black_pawn) { instance_double(Pawn, color: :black, location: [4, 2], symbol: " \u265F ", en_passant: false) }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, black_pawn, white_pawn, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        before do
          board.instance_variable_set(:@previous_piece, white_pawn)
          allow(black_pawn).to receive(:update_location)
          allow(black_pawn).to receive(:update)
        end

        it 'does not call update_en_passant' do
          coords = { row: 4, column: 3 }
          expect(board).not_to receive(:update_en_passant).with(coords)
          board.update(coords)
        end
      end
    end
  end

  describe 'possible_en_passant?' do
    context 'when en_passant is possible' do
      subject(:board) { described_class.new(data, black_pawn) }
      let(:white_pawn) { instance_double(Pawn, color: :white, location: [4, 3], symbol: " \u265F ", en_passant: true) }
      let(:black_pawn) { instance_double(Pawn, color: :black, location: [4, 2], symbol: " \u265F ", en_passant: false) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, black_pawn, white_pawn, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        board.instance_variable_set(:@previous_piece, white_pawn)
        allow(black_pawn).to receive(:captures).and_return([[4, 3]])
      end

      it 'returns true' do
        result = board.possible_en_passant?
        expect(result).to be true
      end
    end

    context 'when en_passant is not possible' do
      subject(:board) { described_class.new(data, black_pawn) }
      let(:white_pawn) { instance_double(Pawn, color: :white, location: [4, 3], symbol: " \u265F ", en_passant: false) }
      let(:black_pawn) { instance_double(Pawn, color: :black, location: [4, 2], symbol: " \u265F ", en_passant: false) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, black_pawn, white_pawn, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        board.instance_variable_set(:@previous_piece, white_pawn)
        allow(black_pawn).to receive(:captures).and_return([[4, 3]])
      end

      it 'returns false' do
        result = board.possible_en_passant?
        expect(result).to be false
      end
    end
  end

  # describe 'check?' do
  #   context 'when king is in check' do
  #     subject(:board) { described_class.new(data) }
  #     let(:black_queen) { instance_double(Queen, color: :black, location: [0, 4], captures: [[6, 4], [7, 4]]) }
  #     let(:white_king) { instance_double(King, color: :white, location: [7, 4]) }
  #     let(:data) do
  #       [
  #         [nil, nil, nil, nil, black_queen, nil, nil, nil],
  #         [nil, nil, nil, nil, nil, nil, nil, nil],
  #         [nil, nil, nil, nil, nil, nil, nil, nil],
  #         [nil, nil, nil, nil, nil, nil, nil, nil],
  #         [nil, nil, nil, nil, nil, nil, nil, nil],
  #         [nil, nil, nil, nil, nil, nil, nil, nil],
  #         [nil, nil, nil, nil, nil, nil, nil, nil],
  #         [nil, nil, nil, nil, white_king, nil, nil, nil]
  #       ]
  #     end

  #     it 'returns true' do
  #       result = board.check?(white_king)
  #       expect(result).to be true
  #     end
  #   end

  #   context 'when king is not in check' do
  #     subject(:board) { described_class.new(data) }
  #     let(:black_bishop) { instance_double(Bishop, color: :black, location: [0, 4], captures: [[1, 3], [2, 2]]) }
  #     let(:white_king) { instance_double(King, color: :white, location: [7, 4]) }
  #     let(:data) do
  #       [
  #         [nil, nil, nil, nil, black_bishop, nil, nil, nil],
  #         [nil, nil, nil, nil, nil, nil, nil, nil],
  #         [nil, nil, nil, nil, nil, nil, nil, nil],
  #         [nil, nil, nil, nil, nil, nil, nil, nil],
  #         [nil, nil, nil, nil, nil, nil, nil, nil],
  #         [nil, nil, nil, nil, nil, nil, nil, nil],
  #         [nil, nil, nil, nil, nil, nil, nil, nil],
  #         [nil, nil, nil, nil, white_king, nil, nil, nil]
  #       ]
  #     end

  #     it 'returns false' do
  #       result = board.check?(white_king)
  #       expect(result).to be false
  #     end
  #   end
  # end
end
