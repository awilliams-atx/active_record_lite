require_relative 'associatable'

module Associatable

  def has_one_through(name, through_name, source_name)
    source_options, through_table, source_table, source_foreign_key =
      has_one_through_options(through_name, source_name)

    query =
      has_one_through_query(source_table, through_table, source_foreign_key)

    define_association_method(query, name, source_options)
  end

  private

  def define_association_method(query, name, source_options)
    define_method(:"#{name}") do
      source_options.model_class
        .new((DBConnection.execute(query, self.owner_id)).first)
    end
  end

  def has_one_through_options(through_name, source_name)
    source_options =
      assoc_options[through_name].model_class.assoc_options[source_name]

    [
      source_options,
      assoc_options[through_name].table_name,
      source_options.table_name,
      source_options.foreign_key.to_s
    ]
  end

  def has_one_through_query(source_table, through_table, source_foreign_key)
    <<-SQL
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
  end
end
