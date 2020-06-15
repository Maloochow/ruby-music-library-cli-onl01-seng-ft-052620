require 'pry'
require_all 'lib'

class MusicLibraryController

    attr_reader :files_o

    def initialize(file_path = "./db/mp3s")
        @files_o = MusicImporter.new(file_path)
        @files_o.import
    end

    def call
        puts "Welcome to your music library!"
        puts "To list all of your songs, enter 'list songs'."
        puts "To list all of the artists in your library, enter 'list artists'."
        puts "To list all of the genres in your library, enter 'list genres'."
        puts "To list all of the songs by a particular artist, enter 'list artist'."
        puts "To list all of the songs of a particular genre, enter 'list genre'."
        puts "To play a song, enter 'play song'."
        puts "To quit, type 'exit'."
        puts "What would you like to do?"
        input = gets.strip
        
        if input == "list songs"
            list_songs
        elsif input == "list artists"
            list_artists
        elsif input == "list genres"
            list_genres
        elsif input == "list artist"
            list_songs_by_artist
        elsif input == "list genre"
            list_songs_by_genre
        elsif input == "play song"
            play_song
        end
        self.call unless input == "exit"

    end

    def list_songs
        sort_file.each_with_index do |song, index| 
            puts "#{index + 1}. #{song.chomp(".mp3")}"
        end
    end
    
    def list_artists
        list_type(Artist.all)
    end
    
    def list_genres
        list_type(Genre.all)
    end
    
    
    def list_songs_by_artist
        puts "Please enter the name of an artist:"
        artist_name = gets.strip
        artist_o = Artist.find_by_name(artist_name)
        artist_o ? list_song_genre(artist_o.songs) : nil
    end
    
    def list_songs_by_genre
        puts "Please enter the name of a genre:"
        genre_name = gets.strip
        genre_o = Genre.find_by_name(genre_name)
        genre_o ? list_artist_song(genre_o.songs) : nil
    end

    def play_song
        puts "Which song number would you like to play?"
        input = gets.strip
        if valid_number?(input.to_i)
        file = sort_file[input.to_i - 1].split(" - ")
        artist = file[0]
        song = file[1]
        puts "Playing #{song} by #{artist}"
        else
            nil
        end
    end

    # def play_song
    #     # binding.pry
    #     puts "Which song number would you like to play?"
    #     user_input = gets.chomp.to_i
    #     binding.pry
    #     if user_input > 0 && user_input <= 5
    #         alpha = Song.all.sort {|a, b| a.name <=> b.name}.uniq
    #         puts "Playing #{alpha[user_input-1].name} by #{alpha[user_input-1].artist.name}"
    #     end

    # end
    
    def valid_number?(number)
        number > 0 && number <= sort_file.length
    end

    def sort_by_name(array)
        array.sort {|a, b| a.name <=> b.name}
    end

    def sort_file
        files_o.files.sort {|a, b| a.split(" - ")[1] <=> b.split(" - ")[1]}
    end

    def list_type(type)
        sort_by_name(type).each_with_index do |v, index|
            puts "#{index + 1}. #{v.name}"
        end
    end
    
    def list_song_genre(array)
        sort_by_name(array).each_with_index do |v, index|
            puts "#{index + 1}. #{v.name} - #{v.genre.name}"
        end
    end

    def list_artist_song(array)
        sort_by_name(array).each_with_index do |v, index|
            puts "#{index + 1}. #{v.artist.name} - #{v.name}"
        end
    end

end