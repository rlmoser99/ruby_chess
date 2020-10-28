# frozen_string_literal: true

# Contains methods to save or load a game
module Serializer
  def save_game
    Dir.mkdir 'saved_games' unless Dir.exist? 'saved_games'
    filename = "Chess #{Time.now.strftime('%Y-%m-%d')} at #{Time.now.strftime('%H:%M:%S')}"
    File.open("saved_games/#{filename}", 'w+') do |file|
      Marshal.dump(self, file)
    end
    puts "Game was saved as \e[36m[#{filename}\e[0m"
    exit(true)
  end

  def load_game
    file_name = find_saved_file
    File.open("saved_games/#{file_name}") do |file|
      Marshal.load(file)
    end
  end

  def find_saved_file
    puts "\e[36m[#]\e[0m File Name(s)"
    file_list.each_with_index do |name, index|
      puts "\e[36m[#{index + 1}]\e[0m #{name}"
    end
    file_number = select_saved_game
    file_list[file_number.to_i - 1]
  end

  def select_saved_game
    user_mode = gets.chomp
    return user_mode if user_mode.match?(/\d+$/)

    puts 'Input error! You can only enter numbers'
    select_saved_game
  end

  def file_list
    files = []
    Dir.entries('saved_games').each do |name|
      files << name if name.match(/(Chess)/)
    end
    files
  end
end
