# Rowboat

Rowboat is a lightweight SQLite3 database ORM influenced by Active Record for development in Rails. With it, programmers can declare associations between tables, which in turn conveniently defines methods on virtual database object which fire off SQL queries.

#### Persisting to a database

Declaring a `SQLObject` makes it simple to build up an object's attributes and save it to the database. The syntax convention follows the pattern of declaring instances of a Ruby class.

```ruby
class Pokemon < SQLObject
end
```

#### Associations

Classes can be linked through Rowboat via association methods.

```ruby
class Pokemon < SQLObject
  belongs_to :trainer
end

class Trainer < SQLObject
  has_many :pokemon
end
```

The above associations provide reader methods like `pikachu.trainer` and writer methods like `ash.pokemons`.

`has_many` associations make an effort to set up methods automatically, but sometimes extra guidance must be provided, e.g. when an association method name does not match a class name exactly.

```ruby
class Employee
  has_many :subordinates,
    class_name: 'Employee',
    foreign_key: :employee_id
end
```

Without providing the options hash to the `has_many` association above, Rowboat would look for a table called `subordinates`.

A `SQLObject` does not store its attributes as instance variables; instead, they are stored in an `attributes` hash. This nesting is important because a `SQLObject` has a number of other important instance variables, like column names.

A key feature of Rowboat is lazy assignment of variables. One important place where this happens is in `SQLObject#columns`; declaring it once as an instance variable keeps

#### Magic

Rowboat makes an attempt where appropriate to do what you want, not what you say. This means, for example, deducing an appropriate SQL query.

```ruby
  ceru = Gym.new
  ceru.name = 'Cerulean Gym'
  ceru.save

  misty = Trainer.new
  misty.name = 'Misty'
  misty.gym_id = ceru.id

  bulb = Pokemon.new
  bulb.name = 'Bulbasaur'
  bulb.trainer =  misty.id
```

In all above cases, Rowboat will write an INSERT query in SQL since the attribute `id` is absent from all objects on instantiation.

## The future of Rowboat

* **Validations** - Methods that prevent protect a database from invalid data entry.
* **Callbacks** - Methods that run at various points in the lifecycle of a SQLObject
* **Convenience methods** - e.g. `#destroy_all`

###### Resources

[Active Support](https://github.com/rails/rails/tree/master/activesupport): Provides grammatical methods like `#constantize` and `#pluralize`

[sqlite3](https://github.com/sparklemotion/sqlite3-ruby) Database intefacing gem for Ruby
