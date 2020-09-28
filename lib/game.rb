require 'colorize'
require_relative 'grid.rb'
require_relative 'slot.rb'
require_relative 'output.rb'

class Game
  include Output
  
  attr_accessor :grid
  
  def initialize
    @grid = Grid.new
  end

  def play
    clear_terminal
    intro
    create_players
    turn until @grid.full? || @grid.winner? 
    victory_message if @grid.winner? 
    tie_message if @grid.full?
    new_game_prompt
  end

  def intro
    puts INSTRUCTIONS.blue
  end

  Player = Struct.new(:name, :disc)

  def create_players
    @player_one = Player.new(get_name(1), YELLOW_DISC)
    @player_two = Player.new(get_name(2), RED_DISC)
    @active_player = @player_two #initializes as P2 so that it switches to P1 on initial turn
  end

  def get_name(player_num)
    loop do
      puts "\nWhat is your name player #{player_num}?"
      name = gets.chomp.strip
      break name if name.match?(/^[\w]+$/)
      clear_line_above
      puts "\nPlease enter a valid name... (alphanumeric only without spaces)".red
    end
  end

  def turn
    switch_player
    if @grid.slots.all? { |slot| !slot.taken? }
      clear_terminal
      puts @grid
    end
    drop_into_slot(get_choice)
    clear_terminal
    puts @grid
  end

  def switch_player
    @active_player == @player_one ? @active_player = @player_two : @active_player = @player_one
  end

  def drop_into_slot(column_num)
    current_slot = @grid.columns[column_num].find { |slot| slot.taken? == false}
    current_slot.insert_disc(@active_player.disc)
  end

  def valid_choice(column)
    column.match?(/^[1-7]{1}$/)
  end

  def get_choice
    loop do
      puts "\nwhich column would you like to put your disc in #{@active_player.name}? (1-7)"
      column_num = gets.chomp.strip
      choice = column_num.to_i - 1
      break choice if (valid_choice(column_num) && !@grid.column_full?(choice))
      4.times{ clear_line_above }
      if !valid_choice(column_num)
        puts INVALID_COLUMN_NUM_MESSAGE 
      elsif @grid.column_full?(choice)
        puts COLUMN_FULL_MESSAGE
      end 
    end
  end

  def victory_message
    puts "\n#{@active_player.name} won this round!"
  end

  def tie_message
    puts "\nIt's a tie! Nobody won...".red
  end

  def new_game_prompt
    puts "\nPlay again? (Y/N)"
    valid_yes_responses = ["y", "yes", "yup", "yeah"]
    valid_no_responses = ["n", "no", "nope", "nah"]
    response = gets.chomp.downcase
    until valid_yes_responses.any? { |option| option == response } || valid_no_responses.any? { |option| option == response }
      puts "\nPlay again?  (Y/N)"
      response = gets.chomp.downcase
      puts "\n"
    end
    Game.new.play if valid_yes_responses.any? { |option| option == response }
  end
end