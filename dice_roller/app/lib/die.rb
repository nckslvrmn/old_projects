# frozen_string_literal: true

# makes die object to be used by roller
class Die
  attr_accessor :die_name,
                :die_value,
                :drop_count,
                :drop_highest,
                :drop_lowest,
                :iterations,
                :mod_operator,
                :mod_val

  def initialize(die)
    @die_split = match_die(die)
    @die_name = die
    @iterations = @die_split['iterations'].to_i
    @die_value = @die_split['value'].to_i
    @drop_highest = drop_highest?
    @drop_lowest = drop_lowest?
    @drop_count = drop_count?
    @mod_operator = mod_operator?
    @mod_val = mod_val?
  end

  private

  def match_die(die)
    die.match(/(?<iterations>[[:digit:]]*)?d(?<value>[[:digit:]]*)(?<drop>dl|dh)?(?<drop_value>[[:digit:]]*)?(?<modifier>[+-])?(?<modifier_value>[[:digit:]]*)?/)
  end

  def drop_highest?
    true if @die_split['drop'] == 'dh'
  end

  def drop_lowest?
    true if @die_split['drop'] == 'dl'
  end

  def drop_count?
    return nil if @die_split['drop_value'].nil? || @die_split['drop_value'].empty?

    @die_split['drop_value'].to_i
  end

  def mod_operator?
    return '-' if @die_split['modifier'] == '-'

    return '+' if @die_split['modifier'] == '+'

    nil
  end

  def mod_val?
    return nil if @die_split['modifier_value'].nil? || \
                  @die_split['modifier_value'].empty?

    @die_split['modifier_value'].to_i
  end
end
