require('pg')
require_relative('star.rb')
require_relative('casting.rb')
require_relative('../db/sql_runner.rb')


class Movie

  attr_accessor :title, :genre
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @genre = options['genre']
  end

  def save
    sql = "INSERT INTO movies
          (title, genre)
          VALUES
          ($1, $2)
          RETURNING id"
    values = [@title, @genre]
    movie_hash = SqlRunner.run(sql, values).first()
    @id = movie_hash['id'].to_i
  end

  def update
    sql = "UPDATE movies SET
            (title, genre)
            =
            ($1, $2)
            WHERE id = $3"
    values = [@title, @genre, @id]
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
