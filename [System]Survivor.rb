# 
#Authors: leolucas(=Enter), Masked
#About this script: 
#This HUD is a script that contain HP+MP+Stamina and Hunger bar.
#Stamina and Hunger are based in a percentage of MP/MMP.
#RGSS3
#Instructions: The Fome=Hunger and the Stamina are defined by percentage of MP.
#Thus if the hero lose MP then will lose Hunger and Stamina. But if you want
#just do decrease of Hunger or the Stamina you will need manipulate the variables
#directly.
# 
#--------------- #
#                #
# S  E  T  U  P  #
#                #
#--------------- #
module EnterConfigHUD

  Fome  = 199 #, Here are defined the values to Fome/Hunger.

  Mfome = 200 # Here are defined the values to Max Fome/Max Hunger.
    
  Stamina = 199
    
  Mstamina = 200
end

#################################################
class Game_BattlerBase
  attr_reader :fome, :stamina
  attr_accessor :mfome, :mstamina

  alias alsintlzgmactr initialize

  def initialize(*args)
    alsintlzgmactr(*args)
    @fome = EnterConfigHUD::Fome
    @mfome = EnterConfigHUD::Mfome
    @stamina = EnterConfigHUD::Stamina
    @mstamina = EnterConfigHUD::Mstamina
  end

  def fome=(x)
    @fome = x
    @fome = @mfome if @fome > @mfome
    @fome = 0 if @fome < 0
  end

  def stamina=(x)
    @stamina = x
    @stamina = @mstamina if @stamina > @mstamina
    @stamina = 0 if @stamina < 0
  end
##################################################################
end

class HUD

  attr_accessor :actor

  def initialize(actor)
    @actor = actor
    @bg = Sprite.new
    @bg.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @fg = Sprite.new
    @fg.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    update_variables
    draw_background
    draw_foreground
  end

  def update
    refresh if need_update?
  end

  def refresh
    update_variables
    draw_foreground
  end

  def draw_background
    @bg.bitmap.clear
    create_background_bitmaps
    create_background
    @bg.bitmap.blt(190, 350, @background, @background.rect)
  end
  
  def draw_foreground
    @fg.bitmap.clear
    create_foreground_bitmaps
    create_foreground
    @fg.bitmap.blt(190, 350
  end
  
  def create_background_bitmaps
    @bhp = Cache.picture('barraenergiaCompleta')
    @bmp = Cache.picture('barraenergiaCompleta')
    @bfome = Cache.picture('barraenergiaCompleta')
    @bstamina = Cache.picture('barraenergiaCompleta')
    @background = Cache.picture('backgroundHUD')
  end

  def create_background
    @background.blt(16, 12, @bstamina, @bstamina.rect)
    @background.blt(16, 28, @bfome, @bfome.rect)
    @background.blt(16, 44, @bhp, @bhp.rect)
    @background.blt(16, 60, @bmp, @bmp.rect)
  end

  def create_foreground_bitmaps
    @fhp = Cache.picture "hp_bar"
    @fmp = Cache.picture "mp_bar"
    @ffome = Cache.picture "fome_bar"
    @fstamina = Cache.picture "stamina_bar"
    @foreground = Bitmap.new(@background.width, @background.height)
  end

  def create_foreground
    w = @fstamina.width * @actor.stamina/@actor.mstamina.to_f #Define the width of bar
    h = @fstamina.height
    rect = Rect.new(0,0,w.to_i,h)
    @foreground.blt(16, 12, @fstamina, rect)
    
    w = @ffome.width * @actor.fome/@actor.mfome.to_f #Define the width of bar
    h = @ffome.height
    rect = Rect.new(0,0,w.to_i,h)
    @foreground.blt(16, 28, @ffome, rect)

    w = @fhp.width * @actor.hp/@actor.mhp.to_f #Define the width of bar
    h = @fhp.height
    rect = Rect.new(0,0,w.to_i,h)
    @foreground.blt(16, 44, @fhp, rect)

    w = @fmp.width * @actor.mp/@actor.mmp.to_f #Define the width of bar
    h = @fmp.height
    rect = Rect.new(0,0,w.to_i,h)
    @foreground.blt(16, 60, @fmp, rect)
  end

  def update_variables
    @actor_hp = @actor.hp
    @actor_mhp = @actor.mhp
    @actor_mp = @actor.mp
    @actor_mmp = @actor.mmp
    @actor_fome = @actor.fome
    @actor_mfome = @actor.mfome
    @actor_stamina = @actor.stamina
    @actor_mstamina = @actor.mstamina
  end

  def need_update?
    hp_need_update? || mp_need_update? || stamina_need_update? || fome_need_update?
  end

  def hp_need_update?
    @actor_hp != @actor.hp || @actor_mhp != @actor.mhp
  end

  def mp_need_update?
    @actor_mp != @actor.mp || @actor_mmp != @actor.mmp
  end
  
  def fome_need_update?
    @actor_fome != @actor.fome || @actor_mfome != @actor.mfome
  end

  def stamina_need_update?
    @actor_stamina != @actor.stamina || @actor_mstamina != @actor.mstamina
  end

  def visible=(tf)
    @bg.visible=@fg.visible=tf
  end

  def dispose
    @bg.dispose
    @fg.dispose
  end

end

class Scene_Map < Scene_Base
  alias enter_hud_start start
  alias enter_hud_update update
  alias enter_hud_terminate terminate

  def start
    enter_hud_start #alias
    @hud = HUD.new($game_party.members[0])
  end
	
  def update
    enter_hud_update #alias
    @hud.visible = Input.press?(:A)
    @hud.update
  end
	
  def terminate
    enter_hud_terminate
    @hud.dispose
  end
end
