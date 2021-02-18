# frozen_string_literal: true

require_relative '../../lib/movement/movement_factory'
require_relative '../../lib/movement/castling_movement'
require_relative '../../lib/movement/basic_movement'
require_relative '../../lib/movement/pawn_promotion_movement'
require_relative '../../lib/movement/en_passant_movement'

RSpec.describe MovementFactory do
  context "when given the 'Basic' movement string" do
    subject(:factory) { described_class.new('Basic') }
  
    it 'sends #new to BasicMovement' do
      allow(BasicMovement).to receive(:new)
      factory.build
    end
  end

  context "when given the 'Castling' movement string" do
    subject(:factory) { described_class.new('Castling') }
  
    it 'sends #new to CastlingMovement' do
      allow(CastlingMovement).to receive(:new)
      factory.build
    end
  end
  
  context "when given the 'EnPassant' movement string" do
    subject(:factory) { described_class.new('EnPassant') }
  
    it 'sends #new to EnPassantMovement' do
      allow(EnPassantMovement).to receive(:new)
      factory.build
    end
  end
  
  context "when given the 'PawnPromotion' movement string" do
    subject(:factory) { described_class.new('PawnPromotion') }
  
    it 'sends #new to PawnPromotionMovement' do
      allow(PawnPromotionMovement).to receive(:new)
      factory.build
    end
  end
end