# defines a destiny character and all its attributes
class Character
  attr_reader :id, :class, :gender, :items, :pl, :race

  private

  def initialize(id: nil, pl: nil, char_class: nil, race: nil, gender: nil)
    @id = id
    @class = char_class
    @gender = gender
    @items = []
    @pl = pl
    @race = race
  end
end
