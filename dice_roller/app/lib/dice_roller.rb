# frozen_string_literal: true

require_relative './die'

# class to roll the dice
class DiceRoller
  def initialize; end

  def roll_dice(die)
    rolls = []
    die.iterations.times do
      rolls.push(Random.rand(1..die.die_value))
    end
    rolls = drop_rolls(die, rolls) if die.drop_count
    result = apply_modifier(die, rolls.sum) if die.mod_val
    [rolls, result || rolls.sum]
  end

  private

  def drop_rolls(die, rolls)
    rolls.sort!
    die.drop_count.times do
      rolls.delete_at(rolls.length - 1) if die.drop_highest
      rolls.delete_at(0) if die.drop_lowest
    end
    rolls
  end

  def apply_modifier(die, rolls_sum)
    modified = rolls_sum - die.mod_val if die.mod_operator == '-'
    modified = rolls_sum + die.mod_val if die.mod_operator == '+'
    return 0 if modified.negative?

    modified
  end
end
