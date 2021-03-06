require 'tty-prompt'
require 'pry'
require 'rspotify'

class CLI

    PLAYLISTS = {
        "Chill" => {user: "Spotify", playlist_id: "37i9dQZF1DX889U0CL85jj"}, 
        "Angry" => {user: "1255914082", playlist_id: "36lqaSvXXuBxi3oYIaEI4B"},
        "Groovy" => {user: "kaythalex_", playlist_id: "3Xt0duCIylMNefC4WmjiYt"},
        "Romantic" => {user: "sanik007", playlist_id: "2PV8zQaMhtLjQ5H2z7Js4E"},
        "Depressed" => {user: "q4vft5sfth0myh3s2wr5p9hpo", playlist_id: "2Hkk04yn1uNBxQwEql433E"},
        "Happy" => {user: "oliviatorri_", playlist_id: "6HWkP17KelQ2PYotO3Usaw"},
        "Pumped Up" => {user: "lauratasney", playlist_id: "6BC5W6YXCqyPrHDDwQhJlE"},
        "Melancholy" => {user: "ladeniselara", playlist_id: "5CyR6yCIZQwRdSJSjC5ssl"}
    }

    def initialize
        @rspotify = Rspotify.new
        @rspotify.authenticate
    end

    def start 
        welcome
        display_moods
        mood_selection  
        follow_up_prompt
    end

    def welcome 
        puts "Welcome to the Mood app! We're here to help you find some music that matches your current mood!"
    end

    def display_moods 
        puts "Here are some moods:"
        PLAYLISTS.keys.each.with_index(1) do |key, index|
            puts "#{index}. #{key}"
        end
    end

    def mood_selection 
        puts "How are you feeling? Enter the corresponding number and we'll suggest a song :)"
        local_input = gets.strip.to_i
        if local_input.between?(1, PLAYLISTS.keys.length) 
            mood = PLAYLISTS[PLAYLISTS.keys[local_input - 1]]
            @playlist_id = mood[:playlist_id]
            @user = mood[:user]
            @rspotify.return_random_song(@user, @playlist_id)
        else
            puts "Hmm... unfortunately, that's not an option."
            mood_selection
        end
    end

    def follow_up_prompt
        prompt = TTY::Prompt.new
        follow_up = prompt.select("What would you like to do now?") do |menu|
            menu.choice "Suggest another song that matches this mood."
            menu.choice "Select a different mood."
            menu.choice "Exit"
        end

        if follow_up == "Suggest another song that matches this mood."
            puts @rspotify.return_random_song(@user, @playlist_id)
                    follow_up_prompt
        elsif follow_up == "Select a different mood."
            start

        elsif follow_up == "Exit"
            puts "See ya next time!"
        end
    end          

end