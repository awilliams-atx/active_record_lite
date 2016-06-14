require_relative 'db_connection'

module Searchable
  def where(params)
    query = <<-SQL
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_line(params)}
    SQL

    parse_all(DBConnection.execute(query, params.values))
  end

  private

  def where_line(params)
    params.keys.map { |key| "\"#{key}\" = ?" }.join(" AND ")
  end
end
