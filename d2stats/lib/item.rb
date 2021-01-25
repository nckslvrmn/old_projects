# defines a destiny item and all its attributes
class Item
  attr_reader :damage_mod, :pl, :quality, :hash, :id, :name

  def damage_mod?
    return true if @damage_mod
    false
  end

  private

  def initialize(id: nil,
                 hash: nil,
                 pl: nil,
                 name: nil,
                 quality: nil,
                 damage_mod: false)
    @damage_mod = damage_mod
    @hash = hash
    @id = id
    @name = name
    @pl = pl
    @quality = quality
  end
end
