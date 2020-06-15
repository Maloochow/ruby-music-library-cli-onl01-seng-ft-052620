require_relative './concerns/modules.rb'

class MusicImporter
extend Concerns::Findable
attr_reader :path

    def initialize(file_path = nil)
        @path = file_path
    end

    def files
        Dir.children(path)
    end

    def import_song(filename)
        array = filename.chomp(".mp3").split(" - ")
        artist = Artist.find_or_create_by_name(array[0])
        name = array[1]
        genre = Genre.find_or_create_by_name(array[2])
        Song.new(name, artist, genre)
    end

    def import
        files.each do |file_name|
            Song.create_from_filename(file_name)
        end
    end
end