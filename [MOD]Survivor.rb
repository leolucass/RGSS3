#Authors: leolucas(=Enter)
#About this script: 
#This MOD is a script that contain a 
#HUD (HP,MP, thirsty, Stamina and Hunger bar);
#if you press the Shift key then these bars become visible.
#and
#If the player have stamina enough then he can run pressing the SHIFT key else he not can run
#If thirsty <= 1 then Game Over
#RGSS3
#Script version 1.5
#
# S  E  T  U  P  
module EnterConfigHUD

  Fome  = 199  #hunger

  Mfome = 200  
    
  Stamina = 199
    
  Mstamina = 200
  
  Sede = 199 #thirsty
  
  Msede = 200
end
#------------------------------------------------ 
#Creating new attributes 

class Game_BattlerBase
   attr_accessor :fome, :mfome, :stamina, :mstamina, :sede, :msede

  alias modificando initialize

  def initialize(*args)
    modificando(*args)
    @fome = EnterConfigHUD::Fome
    @mfome = EnterConfigHUD::Mfome
    @stamina = EnterConfigHUD::Stamina
    @mstamina = EnterConfigHUD::Mstamina
    @sede = EnterConfigHUD::Sede
    @msede = EnterConfigHUD::Msede
  
  end

  def fome=(x) #Is something like setFome and getFome but to act like exception treatment
    @fome = x
    @fome = @mfome if @fome > @mfome #Here is defined the limit of the value
    @fome = 0 if @fome < 0 
  end

  def stamina=(x)
    @stamina = x
    @stamina = @mstamina if @stamina > @mstamina  
    @stamina = 0 if @stamina < 0  
  end
  
  def sede=(x)
    @sede = x
    @sede = @msede if @sede > @msede
    @sede = 0 if @sede < 0
  end
  
  end  #Game_BattlerBase

#-------------------------------------------------
# H U D
class SurvivorHUD

  attr_accessor :actor

  def initialize(actor)
  
    @actor = actor
    @bg = Sprite.new
    @bg.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @fg = Sprite.new
    @fg.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    #@sbox = Sprite.new#
    #@sbox.bitmap = Bitmap.new(Graphics.width, Graphics.height)#
    @sedeBox = Sprite.new # 
    @sedeBox.bitmap = Bitmap.new(Graphics.width, Graphics.height)#
    @fsedeBox = Sprite.new
    @fsedeBox.bitmap = Bitmap.new(Graphics.width, Graphics.height)##foreground
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
    #@sbox.bitmap.clear#
    @sedeBox.bitmap.clear#
    create_background_bitmaps
    create_background
    @bg.bitmap.blt(190, 350, @background, @background.rect)
    #@sbox.bitmap.blt(30,3,@scorebox, @scorebox.rect) #To the first numbers are defined the coordinates
    @sedeBox.bitmap.blt(525,150, @bSede, @bSede.rect)
    end
  
  def draw_foreground
    @fg.bitmap.clear
     @fsedeBox.bitmap.clear
    create_foreground_bitmaps
    create_foreground
    @fg.bitmap.blt(190, 350, @foreground, @foreground.rect)
    @fsedeBox.bitmap.blt(525,150, @foreSede, @foreSede.rect)
  end
  
  def create_background_bitmaps
    @bhp = Cache.picture('barraenergiaCompleta')
    @bmp = Cache.picture('barraenergiaCompleta')
    @bfome = Cache.picture('barraenergiaCompleta')
    @bstamina = Cache.picture('barraenergiaCompleta')
    @background = Cache.picture('backgroundHUD')
    @bSede = Cache.picture('sedeBar')#
 #@scorebox = Cache.picture('scorebox')#
  end

  def create_background
    @background.blt(16, 12, @bstamina, @bstamina.rect) #Here is drawn the background of bars
    @background.blt(16, 2, @bfome, @bfome.rect)
    @background.blt(16, 28, @bhp, @bhp.rect)
    @background.blt(16, 54, @bmp, @bmp.rect)
    @bSede.blt(55,14, @bSede, @bSede.rect)
  end

  def create_foreground_bitmaps
    @fhp = Cache.picture "hp_bar"
    @fmp = Cache.picture "mp_bar"
    @ffome = Cache.picture "fome_bar"
    @fstamina = Cache.picture "stamina_bar"
    @fSede = Cache.picture "sede_bar"
    @foreSede = Bitmap.new(@bSede.width, @bSede.height)#
    @foreground = Bitmap.new(@background.width, @background.height) #drawing a space that have measures of image backgroundHUD. And it'll use the blt and rect to put the images of bars.
    end

  def create_foreground
    w = @fstamina.width * @actor.stamina/@actor.mstamina.to_f #Define the width of bar
    h = @fstamina.height
    rect = Rect.new(0,0,w.to_i,h)
    @foreground.blt(16, 12, @fstamina, rect)
    
    w = @ffome.width * @actor.fome/@actor.mfome.to_f #Define the width of bar
    h = @ffome.height
    rect = Rect.new(0,0,w.to_i,h)
    @foreground.blt(16, 2, @ffome, rect)

    w = @fhp.width * @actor.hp/@actor.mhp.to_f #Define the width of bar
    h = @fhp.height
    rect = Rect.new(0,0,w.to_i,h)
    @foreground.blt(16, 29, @fhp, rect)

    w = @fmp.width * @actor.mp/@actor.mmp.to_f #Define the width of bar
    h = @fmp.height
    rect = Rect.new(0,0,w.to_i,h)
    @foreground.blt(16, 53, @fmp, rect)
    
    w = @fSede.width
    h = @fSede.height * @actor.sede/@actor.msede.to_f #Define the width of bar
    rect = Rect.new(0,0,h.to_i,h)
    @foreSede.blt(0, 0, @fSede, rect)
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
    @actor_sede = @actor.sede
    @actor_msede = @actor.msede
  end

  def need_update?
    hp_need_update? || mp_need_update? || stamina_need_update? || fome_need_update? || sede_need_update?
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
  
  def sede_need_update?
    @actor_sede != @actor.sede || @actor_msede != @actor.msede
    end
  def visible=(tf) #true or false will be the value returned = tf. Here will be linked with the "Input.press?" condition
    @bg.visible=@fg.visible=tf
    @sedeBox.visible = @fsedeBox.visible = tf
  end
  #def scoreVisible=(tf)#
  #@sbox.visible = tf
#end
  def dispose
    @bg.dispose
    @fg.dispose
    @fsedeBox.dispose
    @fsedeBox.dispose
  end

end
#---------------------------- C O R R E R --------------------
class Game_Player < Game_Character
  alias enter_initialize initialize
  def initialize
    $Ncorre = false
    enter_initialize
  end
  def dash?
    return false if @move_route_forcing
  return false if $game_map.disable_dash?
  return false if vehicle
  return false if $Ncorre == true #
  return Input.press?(:A) if $Ncorre == false
  return $Ncorre
  end
end
 
#----------------------- using [mod]survivor --------------------------
 
class Scene_Map < Scene_Base
  alias enter_hud_start start
  alias enter_hud_update update
  alias enter_hud_terminate terminate

  def start
    enter_hud_start #alias
    @hud = SurvivorHUD.new($game_party.members[0])
  end
 
  def update
    #------------------------
     @groupp = $game_party.members[0]
     if @groupp.stamina <= 1
        $Ncorre = true
        else
        $Ncorre = false
   end
    if Input.trigger?(:A)
        @decrease = 10
        @groupp.stamina = @groupp.stamina - @decrease  
      end
      if @groupp.sede <= 1
        SceneManager.goto(Scene_Gameover)
        end
    #-------------------------
    enter_hud_update #alias
    @hud.visible = Input.press?(:Y) #S key
  #@hud.scoreVisible = Input.press?(:A) # shift key
    #-------------------
    #--------------------------
    #@hud.sedeVisible = true  
    @hud.update
    
        
  end
 
  def terminate
    enter_hud_terminate
    @hud.dispose
  end
end
