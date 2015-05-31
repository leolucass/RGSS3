#Authors: leolucas(=Enter)
#About this script: 
#This MOD is a script that contain a 
#HUD (HP,MP, thirsty, Stamina and Hunger bar);
#if you press the "S" key then these bars become visible.
#and
#If the player have stamina enough then he can run pressing the SHIFT key else he not can run
#If thirst or hunger or hp <= 1 then Game Over
#RGSS3
#Script version 2.0
# S  E  T  U  P  
module EnterConfigHUD

  HUNGER  = 199  #hunger

  MHUNGER = 200  
    
  Stamina = 199
    
  Mstamina = 200
  
  THIRST = 199 
  
  MTHIRST = 200
end
#------------------------------------------------ 
#Creating new attributes 

class Game_BattlerBase
   attr_accessor :HUNGER, :mHUNGER, :stamina, :mstamina, :THIRST, :mTHIRST

  alias modificando initialize

  def initialize(*args)
    modificando(*args)
    @HUNGER = EnterConfigHUD::HUNGER
    @mHUNGER = EnterConfigHUD::MHUNGER
    @stamina = EnterConfigHUD::Stamina
    @mstamina = EnterConfigHUD::Mstamina
    @THIRST = EnterConfigHUD::THIRST
    @mTHIRST = EnterConfigHUD::MTHIRST
  
  end

  def HUNGER=(x) #Is something like setHUNGER and getHUNGER but to act like exception treatment
    @HUNGER = x
    @HUNGER = @mHUNGER if @HUNGER > @mHUNGER #Here is defined the limit of the value
    @HUNGER = 0 if @HUNGER < 0 
  end

  def stamina=(x)
    @stamina = x
    @stamina = @mstamina if @stamina > @mstamina  
    @stamina = 0 if @stamina < 0  
  end
  
  def THIRST=(x)
    @THIRST = x
    @THIRST = @mTHIRST if @THIRST > @mTHIRST
    @THIRST = 0 if @THIRST < 0
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
    #@sbox = Sprite.new#soon
    #@sbox.bitmap = Bitmap.new(Graphics.width, Graphics.height)#soon
    @THIRSTBox = Sprite.new 
    @THIRSTBox.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @fTHIRSTBox = Sprite.new
    @fTHIRSTBox.bitmap = Bitmap.new(Graphics.width, Graphics.height)##foreground
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
    #@sbox.bitmap.clear#soon
    @THIRSTBox.bitmap.clear
    create_background_bitmaps
    create_background
    @bg.bitmap.blt(190, 350, @background, @background.rect)
    #@sbox.bitmap.blt(30,3,@scorebox, @scorebox.rect) #To the first numbers are defined the coordinates
    @THIRSTBox.bitmap.blt(525,150, @bTHIRST, @bTHIRST.rect)
    end
  
  def draw_foreground
    @fg.bitmap.clear
     @fTHIRSTBox.bitmap.clear
    create_foreground_bitmaps
    create_foreground
    @fg.bitmap.blt(190, 350, @foreground, @foreground.rect)
    @fTHIRSTBox.bitmap.blt(525,150, @foreTHIRST, @foreTHIRST.rect)
  end
  
  def create_background_bitmaps
    @bhp = Cache.picture('barraenergiaCompleta')
    @bmp = Cache.picture('barraenergiaCompleta')
    @bHUNGER = Cache.picture('barraenergiaCompleta')
    @bstamina = Cache.picture('barraenergiaCompleta')
    @background = Cache.picture('backgroundHUD')
    @bTHIRST = Cache.picture('SedeBar')#
 #@scorebox = Cache.picture('scorebox')#
  end

  def create_background
    @background.blt(16, 12, @bstamina, @bstamina.rect) #Here is drawn the background of bars
    @background.blt(16, 2, @bHUNGER, @bHUNGER.rect)
    @background.blt(16, 28, @bhp, @bhp.rect)
    @background.blt(16, 54, @bmp, @bmp.rect)
    @bTHIRST.blt(55,14, @bTHIRST, @bTHIRST.rect)
  end

  def create_foreground_bitmaps
    @fhp = Cache.picture "hp_bar"
    @fmp = Cache.picture "mp_bar"
    @fHUNGER = Cache.picture "Fome_bar"
    @fstamina = Cache.picture "stamina_bar"
    @fTHIRST = Cache.picture "sede_bar"
    @foreTHIRST = Bitmap.new(@bTHIRST.width, @bTHIRST.height)#
    @foreground = Bitmap.new(@background.width, @background.height) #drawing a space that have measures of image backgroundHUD. And it'll use the blt and rect to put the images of bars.
    end

  def create_foreground
    w = @fstamina.width * @actor.stamina/@actor.mstamina.to_f #Define the width of bar
    h = @fstamina.height
    rect = Rect.new(0,0,w.to_i,h)
    @foreground.blt(16, 12, @fstamina, rect)
    
    w = @fHUNGER.width * @actor.HUNGER/@actor.mHUNGER.to_f #Define the width of bar
    h = @fHUNGER.height
    rect = Rect.new(0,0,w.to_i,h)
    @foreground.blt(16, 2, @fHUNGER, rect)

    w = @fhp.width * @actor.hp/@actor.mhp.to_f #Define the width of bar
    h = @fhp.height
    rect = Rect.new(0,0,w.to_i,h)
    @foreground.blt(16, 29, @fhp, rect)

    w = @fmp.width * @actor.mp/@actor.mmp.to_f #Define the width of bar
    h = @fmp.height
    rect = Rect.new(0,0,w.to_i,h)
    @foreground.blt(16, 53, @fmp, rect)
    
    w = @fTHIRST.width
    h = @fTHIRST.height * @actor.THIRST/@actor.mTHIRST.to_f #Define the width of bar
    rect = Rect.new(0,0,h.to_i,h)
    @foreTHIRST.blt(0, 0, @fTHIRST, rect)
  end

  def update_variables
    @actor_hp = @actor.hp
    @actor_mhp = @actor.mhp
    @actor_mp = @actor.mp
    @actor_mmp = @actor.mmp
    @actor_HUNGER = @actor.HUNGER
    @actor_mHUNGER = @actor.mHUNGER
    @actor_stamina = @actor.stamina
    @actor_mstamina = @actor.mstamina
    @actor_THIRST = @actor.THIRST
    @actor_mTHIRST = @actor.mTHIRST
  end

  def need_update?
    hp_need_update? || mp_need_update? || stamina_need_update? || HUNGER_need_update? || THIRST_need_update?
  end
  
  def hp_need_update?
    @actor_hp != @actor.hp || @actor_mhp != @actor.mhp
  end

  def mp_need_update?
    @actor_mp != @actor.mp || @actor_mmp != @actor.mmp
  end
  
  def HUNGER_need_update?
    @actor_HUNGER != @actor.HUNGER || @actor_mHUNGER != @actor.mHUNGER
  end

  def stamina_need_update?
    @actor_stamina != @actor.stamina || @actor_mstamina != @actor.mstamina
  end
  
  def THIRST_need_update?
    @actor_THIRST != @actor.THIRST || @actor_mTHIRST != @actor.mTHIRST
    end
  def visible=(tf) #true or false will be the value returned = tf. Here will be linked with the "Input.press?" condition
    @bg.visible=@fg.visible=tf
    @THIRSTBox.visible = @fTHIRSTBox.visible = tf
  end
  #def scoreVisible=(tf)#
  #@sbox.visible = tf
#end
  def dispose
    @bg.dispose
    @fg.dispose
    @fTHIRSTBox.dispose
    @fTHIRSTBox.dispose
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
      if @groupp.THIRST <= 1 || @groupp.HUNGER<= 1 || @groupp.hp <= 1
        SceneManager.goto(Scene_Gameover)
        end
    #-------------------------
    enter_hud_update #alias
    @hud.visible = Input.press?(:Y) #S key
    #@hud.scoreVisible = Input.press?(:A) # shift key
    #-------------------
    #--------------------------
    #@hud.THIRSTVisible = true
    @hud.update
    
        
  end
 
  def terminate
    enter_hud_terminate
    @hud.dispose
  end
end
class Game_Interpreter #thanks Sixth
  
  def change_hunger(actor_id,value)
    old_val = $game_party.members[actor_id].HUNGER
    new_val = old_val + value
    $game_party.members[actor_id].HUNGER = new_val
  end
  
  def change_stamina(actor_id,value)
    old_val = $game_party.members[actor_id].stamina
    new_val = old_val + value
    $game_party.members[actor_id].stamina = new_val
  end  
   def change_hp(actor_id,value)
    old_val = $game_party.members[actor_id].hp
    new_val = old_val + value
    $game_party.members[actor_id].hp = new_val
  end 
  
  def change_sp(actor_id,value)
    old_val = $game_party.members[actor_id].sp
    new_val = old_val + value
    $game_party.members[actor_id].sp = new_val
  end 
end
