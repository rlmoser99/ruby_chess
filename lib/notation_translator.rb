# frozen_string_literal: true

# contains logic for chess board
class NotationTranslator
  def initialize
    @row = nil
    @column = nil
  end

  def translate_notation(letter_number)
    coordinates = letter_number.split(//)
    translate_row(coordinates[1])
    translate_column(coordinates[0])
    { row: @row, column: @column }
  end

  protected

  def translate_column(letter)
    @column = letter.downcase.ord - 97
  end

  def translate_row(number)
    @row = 8 - number.to_i
  end
end
