#!/usr/bin/env ruby

require 'open-uri'
require 'json'
require 'yaml'

base_stats = {}

[*1..493,808,809].each do |i|
  resp = open("https://db.pokemongohub.net/api/pokemon/#{i}?form=")
  data = JSON.parse(resp.read)
  base_stats[data['name'].downcase] = {
    attack: data['atk'],
    defense: data['def'],
    stamina: data['sta']
  }
end

File.write('base_stats.yaml', base_stats.to_yaml)
