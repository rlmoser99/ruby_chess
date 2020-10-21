# frozen_string_literal: true

require_relative '../../lib/movement/pawn_promotion_movement'
require_relative '../../lib/board'
require_relative '../../lib/pieces/pawn'
require_relative '../../lib/pieces/piece'

RSpec.describe PawnPromotionMovement do
  describe '#update_location' do
    subject(:movement) { described_class.new }
    let(:board) { instance_double(Board, active_piece: black_pawn) }
    let(:black_pawn) { instance_double(Pawn, location: [6, 1], color: :black) }
    let(:black_queen) { instance_double(Piece, color: :black) }
    let(:data) do
      [
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, black_pawn, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    end

    before do
      allow(movement).to receive(:pawn_promotion_choices)
      user_input = '1'
      allow(movement).to receive(:select_promotion_piece).and_return(user_input)
      allow(movement).to receive(:create_promotion_piece).and_return(black_queen)
      allow(board).to receive(:data).and_return(data)
      allow(board).to receive(:active_piece=).and_return(black_queen)
      allow(board).to receive(:delete_observer)
    end

    it 'removes observer from original pawn' do
      expect(board).to receive(:delete_observer).with(black_pawn)
      coordinates = { row: 7, column: 1 }
      movement.update_pieces(board, coordinates)
    end

    it 'updates coordinates with new piece' do
      coordinates = { row: 7, column: 1 }
      movement.update_pieces(board, coordinates)
      expect(movement.board.data[7][1]).to eq(black_queen)
    end

    it 'removes pawn from original location' do
      coordinates = { row: 7, column: 1 }
      movement.update_pieces(board, coordinates)
      expect(movement.board.data[6][1]).to be nil
    end

    # DO SOME INDIVIDUAL METHOD TESTING!

    # it 'updates board active piece to new piece' do
    #   coordinates = { row: 7, column: 1 }
    #   movement.update_pieces(board, coordinates)
    #   expect(movement.board.active_piece).to eq(black_queen)
    # end

    # it 'removes captured pawn from captured location' do
    #   coordinates = { row: 3, column: 2 }
    #   movement.update_pieces(board, coordinates)
    #   expect(movement.board.data[3][2]).to be nil
    # end

    # it 'sends #update_location (with altered coords) to pawn' do
    #   expect(white_pawn).to receive(:update_location).with(2, 2)
    #   coordinates = { row: 3, column: 2 }
    #   movement.update_pieces(board, coordinates)
    # end
  end
end
