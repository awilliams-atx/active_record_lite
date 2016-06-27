# Rowboat

Rowboat is a lightweight SQLite3 database ORM influenced by Active Record for development in Rails. With it, programmers can declare associations between tables, which in turn conveniently defines methods on virtual database object which fire off SQL queries.

#### Persisting to a database

Declaring a class that inherits from `SQLObject` makes it simple to build up an object's attributes and save it to the database.

```ruby
class Pokemon < SQLObject
end
```

Instantiating a SQLObject stages a record for persisting.

```ruby
pikachu = Pokemon.new
```

Attributes of the instance can be set in an options hash or one at a time.

```ruby
starmie = Pokemon.new
starmie.name = 'Pikachu'
starmie.trainer_id = 2

onyx = Pokemon.new(name: 'onyx', trainer_id: 1)
```

Calling `#save` on a SQLObject instance inserts or updates the database record based on the presence or absence of an `id` attribute.

```ruby
starmie.save # => Inserts a new record.
onyx.save # => Inserts a new record.

onyx.name = 'Onyx'
onyx.save # => Updates the record.
```

#### Associations

Inter-record references are declared  via association methods called at the class level.

```ruby
class Gym < SQLObject
  has_many :trainers
end

class Trainer < SQLObject
  belongs_to :gym
  has_many :pokemons
end

class Pokemon < SQLObject
  belongs_to :trainer
  has_one_through :home, :trainer, :gym
end
```

**NB:** Call '::finalize!' on a SQLObject (the class, not the instance) after it is defined in order to provide attribute getter and setter methods.

```ruby
class Pokemon < SQLObject
  belongs_to :trainer
  has_one_through :home, :trainer, :gym
end

Pokemon.finalize! # => Setters, getters available based on column names.
```

## The future of Rowboat

* **Validations** - Methods that prevent protect a database from invalid data entry.
* **Callbacks** - Methods that run at various points in the lifecycle of a SQLObject
* **Convenience methods** - e.g. `#destroy_all`

###### Resources

[Active Support](https://github.com/rails/rails/tree/master/activesupport): Provides grammatical methods like `#constantize` and `#pluralize`

[sqlite3](https://github.com/sparklemotion/sqlite3-ruby) Database intefacing gem for Ruby
