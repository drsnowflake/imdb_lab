require('pg')
require_relative('star.rb')
require_relative('casting.rb')
require_relative('../db/sql_runner.rb')


class Movie

  attr_accessor :title, :genre, :budget
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @genre = options['genre']
    @budget = options['budget'].to_i
  end

  def save
    sql = "INSERT INTO movies
          (title, genre, budget)
          VALUES
          ($1, $2, $3)
          RETURNING id"
    values = [@title, @genre, @budget]
    movie_hash = SqlRunner.run(sql, values).first()
    @id = movie_hash['id'].to_i
  end

  def update
    sql = "UPDATE movies SET
            (title, genre, budget)
            =
            ($1, $2, $3)
            WHERE id = $4"
    values = [@title, @genre, @budget, @id]
    SqlRunner.run(sql, values)
  end

  def all_stars
    sql = "SELECT stars.* FROM stars
            INNER JOIN castings
            ON castings.star_id = stars.id
            WHERE movie_id = $1"
    values = [@id]
    stars_array = SqlRunner.run(sql, values)
    return stars_array.map { |star| Star.new(star)}
  end

  def remaining_budget
    sql = "SELECT castings.fee FROM castings
            WHERE castings.movie_id = $1"
    values = [@id]
    return remaining_budget = @budget - SqlRunner.run(sql, values).reduce(0) { |total, fee_hash| total + fee_hash['fee'].to_i }
  end

  def self.all
    sql = "SELECT * FROM movies"
    movie_array = SqlRunner.run(sql)
    return movie_array.map { |movie| Movie.new(movie) }
  end

  def self.delete_all
    sql = "DELETE FROM movies"
    SqlRunner.run(sql)
  end

end
