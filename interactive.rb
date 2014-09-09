require "./solarsystem.rb"

class SolarSysInfo

  def initialize(solar_system)
    @solar_system = solar_system
  end

  def run
    yes_answers = ["yes", "y", "yup", "yeah", "of course!", "why not?"]
    loop do
      planet = planet_query
      subject = info_query(planet)
      give_information(planet, subject)
      puts "Is there anything else you'd like to look up?"
      print "> "
      continue = gets.chomp
      unless yes_answers.include? continue
        break
      end
    end
  end

  def planet_name_array
    planet_array = @solar_system.planets.keys
    planets_capd = []
    planet_array.each do |planet_name|
      planets_capd << planet_name.to_s.capitalize
    end
    return  planets_capd
  end

  def planet_attr_array(planet)
    attr_array = planet_instance(planet).attr_list
    attr_array << "distance_between"
    attr_array << "number_of_rotations"
    attr_array.collect! do |attr|
      attr = attr.to_s
      fix_underscore(attr)
    end
    return attr_array
  end

  def planet_query
    print "Select a planet: "
    puts planet_name_array.join(', ')
    loop do
      print "> "
      planet = gets.chomp.downcase.capitalize
      if planet_name_array.include? planet
        puts "Accessing information about #{planet}..."
        return planet.downcase.to_sym
      else
        puts "I don't know anything about #{planet}, try one of these: "
        puts planet_name_array.join(', ')
      end
    end
  end

  def info_query(planet)
    puts "I know about these features of #{planet.capitalize}: "
    attrs = planet_attr_array(planet).join(', ')
    puts attrs
    puts "What would you like information about?"
    loop do
      print "> "
      info_choice = gets.chomp.downcase
      choice_with_underscore = fix_underscore(info_choice)
      if planet_attr_array(planet).include? choice_with_underscore
        puts "Accessing information about #{planet.capitalize}'s #{info_choice}..."
        return choice_with_underscore.to_sym
      else
        puts "I don't know anything about #{info_choice}, try one of these: "
        puts attrs
      end
    end
  end

  def fix_underscore(name)
    if name.include? (' ')
      name.gsub(' ', '_')
    elsif name.include? ('_')
      name.gsub('_', ' ')
    else
      name
    end
  end

  def planet_instance(planet)
    @solar_system.planets[planet]
  end

  def give_information(planet, subject)
    planet_cap = planet.capitalize
    actual_planet = planet_instance(planet)
    case subject
    when :name
      puts "#{planet_cap} is called #{actual_planet.name.capitalize}. Duh."
    when :mass
      puts "#{planet_cap} has a mass of #{mass} Earths."
    when :moons
      moons = actual_planet.moons
      if moons[0] == 0
        puts "#{planet_cap} has no moons that I know of."
      else
        puts "#{planet_cap} has at least #{moons[0]} moons. Some of their names are: "
        puts moons[1].join(', ')
      end
    when :position
      puts "#{planet_cap}'s order relative to the sun is: #{actual_planet.position}."
    when :diameter
      puts "#{planet_cap} has a diameter of #{actual_planet.diameter} km."
    when :orbital_period
      puts "#{planet_cap} has an orbital period of #{actual_planet.orbital_period} Earth days."
    when :distance_from_the_sun
      puts "#{planet_cap} is #{actual_planet.distance_from_the_sun} light minutes from the sun."
    when :distance_between
      planet2 = planet_instance(planet_query)
      puts "#{planet_cap} is #{@solar_system.distance_between(actual_planet, planet2)} light minutes away from #{planet2.name.capitalize}."
    when :number_of_rotations
      @solar_system.get_planet_age(planet)
    else
      puts "Wow, how'd you get here?"
      puts subject
      puts subject.class
    end
  end

end

#fix moons to include number of moons

planets = [
  {name: "mercury", mass: 0.0555, moons: [0], position: 1, diameter: 4879, orbital_period: 88, distance_from_the_sun: 3.877},
  {name: "venus", mass: 0.815, moons: [0], position: 2, diameter: 7521, orbital_period: 225, distance_from_the_sun: 5.975},
  {name: "earth", mass: 1, moons: [1, ["Moon"]], position: 3, diameter: 12742, orbital_period: 365, distance_from_the_sun: 8.376},
  {name: "mars", mass: 0.107, moons: [2, ["Phobos", "Deimos"]], position: 4, diameter: 6779, orbital_period: 687, distance_from_the_sun: 11.97},
  #{name: "asteroid belt", position: 5},
  {name: "jupiter", mass: 317.8, moons: [63, ["Io", "Europa", "Ganymede", "Callisto"]], position: 5, diameter: 139822, orbital_period: 4332, distance_from_the_sun: 43.93},
  {name: "saturn", mass: 95.152, moons: [61, ["Mimas", "Enceladus", "Tethys", "Dione", "Rhea", "Titan", "Lapetus"]], position: 6, diameter: 116464, orbital_period: 10759, distance_from_the_sun: (1.38 * 60)},
  {name: "uranus", mass: 14.536, moons: [27, ["Miranda", "Aiel", "Umbriel", "Tiania", "Oberon"]], position: 7, diameter: 50724, orbital_period: 30687, distance_from_the_sun: (2.778 * 60)},
  {name: "neptune", mass: 14.98, moons: [14, ["Triton", "Nereid", "Larissa"]], position: 8, diameter: 49244, orbital_period: 60190, distance_from_the_sun: (4.162 * 60)},
  {name: "pluto", mass: 0.00218 , moons: [5, ["Charon", "Styx", "Nix", "Kerberos", "Hydra"]], position: 9, diameter: 2368, orbital_period: 90465, distance_from_the_sun: (5.64 * 60)}
]

ss = SolarSystem.new

planets.each do |planet|
  new_planet = Planet.new(planet)
  ss.planets[new_planet.name.to_sym] = new_planet
end

infomatic = SolarSysInfo.new(ss)
infomatic.run
