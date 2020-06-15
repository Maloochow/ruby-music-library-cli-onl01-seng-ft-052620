require_relative './concerns/modules.rb'
require_relative './musicimporter.rb'

class Song
extend Concerns::Findable
attr_accessor :name
attr_reader :artist, :genre
@@all = []

    def initialize(name, artist_object = nil, genre_object = nil)
        @name = name
        self.artist = artist_object if artist_object
        self.genre = genre_object if genre_object
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

    def artist=(artist)
        @artist = artist
        artist.add_song(self)
    end

    def genre=(genre_object)
        @genre = genre_object
        genre_object.songs << self unless genre_object.songs.include?(self)
    end

    def self.new_from_filename(filename)
        MusicImporter.new.import_song(filename)
    end

    def self.create_from_filename(filename)
        new_from_filename(filename).save
    end

end