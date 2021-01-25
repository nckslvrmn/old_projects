# frozen_string_literal: true

require_relative './lib/dice_roller'
require 'sinatra'

get '/' do
  erb :index
end

post '/roll' do
  if params['die'].empty?
    redirect '/'
  else
    d = Die.new(params['die'])
    roller = DiceRoller.new
    rolls, result = roller.roll_dice(d)
  end
  erb :result, locals: { die: params['die'],
                         rolls: rolls,
                         result: result }
end

not_found do
  'This is nowhere to be found.'
end
