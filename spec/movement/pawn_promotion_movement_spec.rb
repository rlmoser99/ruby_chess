# frozen_string_literal: true

require_relative '../../lib/movement/pawn_promotion_movement'
require_relative '../../lib/board'
require_relative '../../lib/pieces/pawn'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/pieces/queen'

RSpec.describe PawnPromotionMovement do
  describe '#update_location' do
    subject(:movement) { described_class.new }
    let(:board) { instance_double(Board) }
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
      user_input = '1'
      allow(movement).to receive(:puts)
      allow(movement).to receive(:select_promotion_piece).and_return(user_input)
      allow(movement).to receive(:create_promotion_piece).and_return(black_queen)
      allow(board).to receive(:data).and_return(data)
      allow(board).to receive(:active_piece).and_return(black_pawn)
      allow(board).to receive(:delete_observer)
      allow(board).to receive(:active_piece=)
      allow(board).to receive(:game_mode).and_return(nil)
    end

    it 'removes observer from original pawn' do
      expect(board).to receive(:delete_observer).with(black_pawn)
      coordinates = { row: 7, column: 1 }
      movement.update_pieces(board, coordinates)
    end

    it 'removes pawn from original location' do
      coordinates = { row: 7, column: 1 }
      movement.update_pieces(board, coordinates)
      expect(movement.board.data[6][1]).to be nil
    end

    it 'updates coordinates with new piece' do
      coordinates = { row: 7, column: 1 }
      movement.update_pieces(board, coordinates)
      expect(movement.board.data[7][1]).to eq(black_queen)
    end

    it 'sends active_piece to board with new piece' do
      expect(board).to receive(:active_piece=).with(black_queen)
      coordinates = { row: 7, column: 1 }
      movement.update_pieces(board, coordinates)
    end
  end

  describe '#new_promotion_piece' do
    context 'when board game mode is computer' do
      subject(:movement) { described_class.new }
      let(:board) { instance_double(Board, active_piece: black_pawn) }
      let(:black_pawn) { instance_double(Pawn, location: [6, 1], color: :black) }

      it 'creates a new Queen' do
        movement.instance_variable_set(:@board, board)
        movement.instance_variable_set(:@row, 7)
        movement.instance_variable_set(:@column, 1)
        allow(board).to receive(:game_mode).and_return(:computer)
        allow(board).to receive(:add_observer)
        result = movement.send(:new_promotion_piece)
        expect(result).to be_a(Queen)
      end
    end

    context 'when board game mode is not computer' do
      subject(:movement) { described_class.new }
      let(:board) { instance_double(Board, active_piece: black_pawn, game_mode: nil) }
      let(:black_pawn) { instance_double(Pawn, location: [6, 1], color: :black) }

      before do
        movement.instance_variable_set(:@board, board)
        movement.instance_variable_set(:@row, 7)
        movement.instance_variable_set(:@column, 1)
        allow(movement).to receive(:puts)
        allow(movement).to receive(:pawn_promotion_choices)
        user_input = '2'
        allow(movement).to receive(:select_promotion_piece).and_return(user_input)
        allow(movement).to receive(:create_promotion_piece).with(user_input)
      end

      after do
        movement.send(:new_promotion_piece)
      end

      it ' the promotion choices' do
        expect(movement).to receive(:pawn_promotion_choices)
      end

      it 'gets the player choice' do
        expect(movement).to receive(:select_promotion_piece).and_return('2')
      end

      it 'creates the chosen piece' do
        expect(movement).to receive(:create_promotion_piece).with('2')
      end
    end
  end

  describe '#create_promotion_piece' do
    subject(:movement) { described_class.new }
    let(:board) { instance_double(Board, active_piece: black_pawn) }
    let(:black_pawn) { instance_double(Pawn, location: [6, 1], color: :black) }

    it 'creates a new piece' do
      movement.instance_variable_set(:@board, board)
      movement.instance_variable_set(:@row, 7)
      movement.instance_variable_set(:@column, 1)
      pawn_move_info = { color: :black, location: [7, 1] }
      expect(Queen).to receive(:new).with(board, pawn_move_info)
      user_input = '1'
      movement.send(:create_promotion_piece, user_input)
    end
  end

  describe '#select_promotion_piece' do
    subject(:movement) { described_class.new }
    let(:board) { instance_double(Board, active_piece: black_pawn) }
    let(:black_pawn) { instance_double(Pawn, location: [6, 1], color: :black) }

    context 'when user input is valid' do
      it 'returns valid user input' do
        user_input = '1'
        allow(movement).to receive(:gets).and_return(user_input)
        result = movement.send(:select_promotion_piece)
        expect(result).to eq('1')
      end
    end

    context 'when user input is not valid' do
      it 'outputs an input error warning' do
        warning = 'Input error! Only enter 1-digit (1-4).'
        expect(movement).to receive(:puts).with(warning).once
        user_input = '1'
        letter_input = 'a'
        allow(movement).to receive(:gets).and_return(letter_input, user_input)
        movement.send(:select_promotion_piece)
      end

      it 'returns second valid user input' do
        user_input = '1'
        letter_input = 'a'
        allow(movement).to receive(:gets).and_return(letter_input, user_input)
        warning = 'Input error! Only enter 1-digit (1-4).'
        allow(movement).to receive(:puts).with(warning).once
        result = movement.send(:select_promotion_piece)
        expect(result).to eq('1')
      end
    end
  end
end
