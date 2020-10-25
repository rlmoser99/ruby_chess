# frozen_string_literal: true

# contains logic to create 2-d array coordinates from chess notation
class NotationTranslator
  def initialize
    @row = nil
    @column = nil
  end

  # returns a coordinates hash from the user's letter (column) and number (row)
  def translate_notation(letter_number)
    coordinates = letter_number.split(//)
    translate_row(coordinates[1])
    translate_column(coordinates[0])
    { row: @row, column: @column }
  end

  private

  # converts the user's column letter (a-h) to a number 0-7
  def translate_column(letter)
    @column = letter.downcase.ord - 97
  end

  # converts the user's row number (8-1) to a number 0-7
  def translate_row(number)
    @row = 8 - number.to_i
  end
end
