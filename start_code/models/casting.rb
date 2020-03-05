require('pg')
require_relative('movie.rb')
require_relative('star.rb')
require_relative('../db/sql_runner.rb')


class Casting

  attr_reader :id
  attr_accessor :fee, :movie_id, :star_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @movie_id = options['movie_id'].to_i
    @star_id = options['star_id'].to_i
    @fee = options['fee'].to_i
  end

  def save
    sql = "INSERT INTO castings
            (movie_id, star_id, fee)
            VALUES
            ($1, $2, $3)
            RETURNING id"
    values = [@movie_id, @star_id, @fee]
    casting_hash = SqlRunner.run(sql, values).first()
    @id = casting_hash['id'].to_i
  end

  def update
    sql = "UPDATE castings SET
            (movie_id, star_id, fee)
            =
            ($1, $2, $3)
            WHERE id = $4"
    values = [@movie_id, @star_id, @fee, @id]
    SqlRunner.run(sql, values)
  end

  def self.all
    sql = "SELECT * FROM castings"
    casting_array = SqlRunner.run(sql)
    return casting_array.map { |casting| Casting.new(casting) }
  end

  def self.delete_all
    sql = "DELETE FROM castings"
    SqlRunner.run(sql)
  end

end
