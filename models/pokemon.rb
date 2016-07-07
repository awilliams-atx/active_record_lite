# NB: This is an example of how to set up models with Rowboat.

require_relative '../lib/sql_object'

class Gym < SQLObject
  has_many :trainers
end

Gym.finalize!

class Trainer < SQLObject
  has_many :pokemons
  belongs_to :gym
end

Trainer.finalize!

class Pokemon < SQLObject
  has_one_through :home, :trainer, :gym
  belongs_to :trainer
end

Pokemon.finalize!
