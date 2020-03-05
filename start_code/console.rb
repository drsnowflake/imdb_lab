require('pg')
require('pry')
require_relative('models/star.rb')
require_relative('models/movie.rb')
require_relative('models/casting.rb')
require_relative('db/sql_runner.rb')

Casting.delete_all
Star.delete_all
Movie.delete_all

star1 = Star.new( {'first_name' => 'Will',
                  'last_name' => 'Powers'} )
star1.save

star2 = Star.new( {'first_name' => 'Daisy',
                    'last_name' => 'Dale'} )
star2.save

movie1= Movie.new( {'title' => 'Lemon Grove',
                    'genre' => 'avant-garden'} )
movie1.save

movie2 = Movie.new( {'title' => 'Twisted Shadow',
                      'genre' => 'crime thriller'} )
movie2.save

movie3 = Movie.new( {'title' => 'Electric Eden',
                      'genre' => 'sci-fi'} )
movie3.save

casting1 = Casting.new( {'movie_id' => movie1.id,
                          'star_id' => star1.id,
                          'fee' => 10} )
casting1.save

casting2 = Casting.new( {'movie_id' => movie2.id,
                          'star_id' => star2.id,
                          'fee' => 20} )
casting2.save

casting3 = Casting.new( {'movie_id' => movie3.id,
                          'star_id' => star1.id,
                          'fee' => 5} )
casting3.save

casting4 = Casting.new( {'movie_id' => movie3.id,
                          'star_id' => star2.id,
                          'fee' => 30} )
casting4.save

binding.pry
nil
