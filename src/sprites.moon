with love.graphics
  sprites = {
    textures: {
      dirt:  .newImage "res/Textures/Grasslands_Dirt.png"
      stone: .newImage "res/Textures/Grasslands_Stone.png"
      sand:  .newImage "res/Textures/Sand.png"
      grass: .newImage "res/Textures/Grasslands_Grass.png"
    }

    plants: {
      skunk: .newImage "res/Plants/W33d.png"
      shrub: .newImage "res/Plants/BouncyShrub.png"
      berry: .newImage "res/Plants/WallBerry.png"
    }

    runes: {
      l_rune: .newImage "res/Runes/Left.png"
      r_rune: .newImage "res/Runes/Right.png"
      u_rune: .newImage "res/Runes/Up.png"
      d_rune: .newImage "res/Runes/Down.png"
      blank: .newImage "res/Runes/Blank.png"
    }
  }

  sprites.anims = {
    run: {}
  }

  for i = 0, 10
    sprites.anims.run[i] = .newImage "res/Run/Run #{i}.png"

  return sprites