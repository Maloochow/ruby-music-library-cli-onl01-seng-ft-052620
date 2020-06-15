require_relative './concerns/modules.rb'

class Genre
    extend Concerns::Findable
    attr_reader :songs
    attr_accessor :name
    @@all = []

def initialize(name)
    @name = name
    @songs = []
end

def artists
    songs.map {|song| song.artist}.uniq
end

def save
    @@all << self
end

def self.create(name)
    object = self.new(name)
    object.save
    object
end

def self.all
    @@all
end

def self.destroy_all
    @@all.clear
end

end