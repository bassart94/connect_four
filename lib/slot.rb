class Slot
  attr_accessor :value

  def initialize(value = nil)
    @value = value
  end

  def taken?
    @value == nil ? false : true
  end

  def insert_disc(value)
    @value = value
  end
end