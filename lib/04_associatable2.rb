require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    through_class = assoc_options[through_name].model_class
    source_options = through_class.assoc_options[source_name]

    through_table = assoc_options[through_name].table_name
    source_table = source_options.table_name
    source_foreign_key = source_options.foreign_key.to_s

    query = <<-SQL
      SELECT
        #{source_table}.*
      FROM
        #{source_table}
      JOIN
        #{through_table}
      ON
        #{source_table}.id = #{through_table}.#{source_foreign_key}
      WHERE
        #{through_table}.id = ?
    SQL


    define_method(:"#{name}") do
      source_options
        .model_class
        .new((DBConnection.execute(query, self.owner_id)).first)
    end
  end
end
