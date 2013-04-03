require_relative 'grid.rb'
require_relative 'rover.rb'

class InvalidMissionBriefingError < StandardError;end

class MissionControl

  def initialize(mission_briefing)
    instructions = parse(mission_briefing)
    @grid = Grid.new(*instructions[:grid])
    @command_defs = instructions[:command_defs]
    launch_rovers!(instructions[:rover_defs])
  end

  def run!
    (0..mission_length).each do |mission_index|
      @command_defs.each_with_index do |seq, rover_index|
        rover = @rovers[rover_index]
        command = seq[mission_index]
        rover.command!(command, other_rovers(rover)) if command
      end
    end
    self
  end

  def display_results
    @rovers.each do |rover|
      puts rover.state
    end
  end

  private

  def parse(mission_briefing)
    instructions = {}
    text=File.open(mission_briefing).read
    text.gsub!(/\r\n?/, "\n")
    arr = text.split("\n")
    instructions[:grid] = arr.shift.split(' ').map { |a| a.to_i }
    instructions[:command_defs] = []
    instructions[:rover_defs] = []
    arr.each_slice(2) do |a|
      instructions[:rover_defs] << a.first.split(' ')
      instructions[:command_defs] << a.last.split('')
    end
    puts instructions.inspect
    instructions
  end

  def launch_rovers!(rover_defs)
    @rovers = []
    rover_defs.each do |rover_def|
      @rovers << Rover.new(@grid, rover_def[0].to_i, rover_def[1].to_i, rover_def[2])
    end
  end

  def other_rovers(rover)
    @rovers.reject { |r| r == rover }
  end

  def mission_length
    @command_defs.sort { |a,b| a.length <=> b.length }.first.length
  end

end
