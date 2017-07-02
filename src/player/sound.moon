with love.sound
  sound_player = {
      soundbank: {
          pop: love.audio.newSource .newSoundData "res/Sound/260614__kwahmah-02__pop.wav"
          hop: love.audio.newSource .newSoundData "res/Sound/264828__commanderrobot__text-message-or-videogame-jump.ogg"
          bop: love.audio.newSource .newSoundData "res/Sound/386654__jalastram__sfx-jump-35.wav" 
          music1: love.audio.newSource .newDecoder "res/Sound/Ascending Paradigm.mp3", 2048
      }

      already_playing_music: false

      play_pop: =>
        @soundbank.pop\play!
      play_hop: =>
        @soundbank.hop\play!
      play_bop: =>
        @soundbank.bop\play!

      start_music: =>
          @soundbank.music1\setLooping true 
          @soundbank.music1\play!
      
    }
  return sound_player