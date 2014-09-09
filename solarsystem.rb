class Planet
  attr_accessor :name, :mass, :moons, :position, :diameter, :orbital_period, :attr_list, :distance_from_the_sun

  def initialize(planet_hash)
    @name = planet_hash[:name]
    @mass = planet_hash[:mass]
    @moons = planet_hash[:moons]
    @position = planet_hash[:position]
    @diameter = planet_hash[:diameter]
    @orbital_period = planet_hash[:orbital_period]
    @attr_list = planet_hash.keys
    @distance_from_the_sun = planet_hash[:distance_from_the_sun]
  end

end

class SolarSystem
  attr_accessor :planets

  def initialize
    @planets = {}
    @age = 4560000000
  end

  def distance_between(planet1, planet2)
    planet1_dist = planet1.distance_from_the_sun
    planet2_dist = planet2.distance_from_the_sun
    ( planet1_dist - planet2_dist ).abs
  end

  def get_planet_obj(planet)
    @planets[planet]
  end

# gives the number of orbits the planets has made since formation, assuming
# planet age and solar system age are the same (they're not)
  def get_planet_age(planet)
    actual_planet = get_planet_obj(planet)
    age_in_earth_days = @age * 365
    planet_age = age_in_earth_days / actual_planet.orbital_period
    puts "#{actual_planet.name.capitalize} has rotated the sun #{planet_age} times!"
  end

end

#puts ss.get_planet_age(:pluto)
