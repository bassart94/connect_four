require 'pry'
require_relative 'slot.rb'
require_relative 'output.rb'

class Grid
  include Output

  attr_accessor :slots, :columns

  def initialize
    @slots = []
    @columns = Array.new(7)
    @columns.each_with_index do |column, i| 
      depth = Array.new(6)
      depth.each_with_index do |slot, i| 
        depth[i] = Slot.new
        @slots << depth[i]  
      end
      columns[i] = depth
    end
  end

  def full?
    @slots.all? { |slot| slot.taken? == true }
  end

  def column_full?(column)
    @columns[column].all? { |slot| slot.taken? == true }
  end

  def winner?
    players = [RED_DISC, YELLOW_DISC]
    
    # column
    players.each do |player|
      for x in 0..6
        for y in 0..2
          vertical_line = []
          for l in 0..3
            vertical_line << @columns[x][y + l]
          end
          return player if vertical_line.count{ |slot| slot.value == player } == 4  
        end
      end
    end

    # row
    players.each do |player|
      for y in 0..5
        for x in 0..3
          row = []
          for l in 0..3
            row << @columns[x + l][y] 
          end
          return player if row.count{ |slot| slot.value == player } == 4 
        end 
      end
    end

    # diagonal slope up
    players.each do |player|
      for x in 0..3
        for y in 0..2
          diag_up = []
          for l in 0..3 
            diag_up << @columns[x + l][y + l]
          end
          return player if diag_up.count{ |slot| slot.value == player } == 4 
        end
      end
    end
    
    # diagonal slope down
    players.each do |player|
      for x in 3..6
        for y in 0..2
          diag_down = []
          for l in 0..3 
            diag_down << @columns[x - l][y + l]
          end
          return player if diag_down.count{ |slot| slot.value == player } == 4 
        end
      end
    end

    false
  end

  def to_s
    <<~BOARD

      #{COLUMN_HEADER}
      #{ROW_DIVIDER}
      #{format_row(5)}
      #{ROW_DIVIDER}
      #{format_row(4)}
      #{ROW_DIVIDER}
      #{format_row(3)}
      #{ROW_DIVIDER}
      #{format_row(2)}
      #{ROW_DIVIDER}
      #{format_row(1)}
      #{ROW_DIVIDER}
      #{format_row(0)}

    BOARD
  end
end