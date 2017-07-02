with love.sound
  sound_player = {
      soundbank: {
          pop: .newSource .newSoundData "res/Sound/260614__kwahmah-02__pop.wav"
          hop: .newSource .newSoundData "264828__commanderrobot__text-message-or-videogame-jump.ogg"
          bop: .newSource .newSoundData "264828__commanderrobot__text-message-or-videogame-jump.ogg" 
          music1: .newSource .newDecoder "Ascending Paradigm.mp3", 2048
      }

      already_playing_music: false

      play_pop: =>
        @soundbank.pop\play!
      play_hop: =>
        @soundbank.hop\play!
      play_bop: =>
        @soundbank[bop]\play!

      start_music: =>
        if already_playing_music
          @soundbank[music1]\setLooping true 
          @soundbank[music1]\play!
      
    }
  return sound_player