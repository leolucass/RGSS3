# 
#Author: leolucas(=Enter)
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
  attr_accessor :fome, :mfome, :stamina, :mstamina

  alias alsintlzgmactr initialize

  def initialize(*args)
    alsintlzgmactr(*args)
    @fome = EnterConfigHUD::Fome
    @mfome = EnterConfigHUD::Mfome
    @stamina = EnterConfigHUD::Stamina
    @mstamina = EnterConfigHUD::Mstamina
  end
##################################################################
end
class Scene_Map < Scene_Base
  
	alias enter_hud_start start
	alias enter_hud_update update
	alias enter_hud_terminate terminate

	def start
		enter_hud_start #alias
		@actor = $game_party.members[0]
		create_hud
		update_variables
	end
	
	def create_hud
		create_sprites
		create_bitmaps
		get_bitmap_size
		draw_hp
		draw_mp
		draw_fome
    draw_stamina
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
	
	def create_sprites
		@hp = Sprite.new
		@mp = Sprite.new
		@fome_bar = Sprite.new
    @stamina_bar = Sprite.new
    @backgroundHUD = Sprite.new
	end
	def create_bitmaps
		@hp.bitmap = bitmap = Cache.picture('barraenergiaCompleta')#Verificar isso, quando apaga ela e coloca outra, as barras não aparecem
		@mp.bitmap = bitmap = Cache.picture('barraenergiaCompleta')
		@fome_bar.bitmap = bitmap = Cache.picture('barraenergiaCompleta')
    @stamina_bar.bitmap = bitmap = Cache.picture('barraenergiaCompleta')
    @backgroundHUD.bitmap = bitmap = Cache.picture('backgroundHUD')
    @backgroundHUD.x = 190
    @backgroundHUD.y = 350 
	end
	
	def get_bitmap_size
		@hpw = @hp.width
		@hph = @hp.height
		@mpw = @mp.width
		@mph = @mp.height
		@fomew = @fome_bar.width
		@fomeh =  @fome_bar.height  
    @staminaw = @stamina_bar.width
		@staminah=  @stamina_bar.height  
	end
  
  def draw_stamina
    @stamina_bar.bitmap.clear
		@stamina_bar.bitmap = Bitmap.new(@staminaw,@staminah)
		staminaw = @staminaw *@actor.stamina/@actor.mstamina#Define the width of bar
		staminah = @staminah
    rect = Rect.new(0,0,staminaw,staminah)
		@stamina_bar.bitmap.blt(0,0,Cache.picture("stamina_bar"),rect)
		@stamina_bar.x = 206
		@stamina_bar.y = 362
    end
	def draw_hp
		@hp.bitmap.clear
		@hp.bitmap = Bitmap.new(@hpw,@hph)
		hpw = @hpw *@actor.hp/@actor.mhp #Define the width of bar
		hph = @hph
		rect = Rect.new(0,0,hpw-1,hph) #Was put "-1" to fix the value bugged
		@hp.bitmap.blt(0,0,Cache.picture("hp_bar"),rect)
		@hp.x = 206
		@hp.y = 379
    end
	 def draw_mp
 
		@mp.bitmap.clear
		@mp.bitmap = Bitmap.new(@mpw,@mph)
		mpw = @mpw *@actor.mp / @actor.mmp
		mph = @mph
		rect = Rect.new(0,0,mpw,mph)
		@mp.bitmap.blt(0,0,Cache.picture("sp_bar"),rect)
		@mp.x = 206
		@mp.y = 403
     
	end
  
	 def draw_fome
		@fome_bar.bitmap.clear
		@fome_bar.bitmap = Bitmap.new(@fomew,@fomeh)
		fomew = @fomew *@actor.fome/@actor.mfome #Define the width of bar
		fomeh = @fomeh
    rect = Rect.new(0,0,fomew,fomeh)
		@fome_bar.bitmap.blt(0,0,Cache.picture("Hunger"),rect)
		@fome_bar.x = 206
		@fome_bar.y = 352
    end
	
	
	 def update
		enter_hud_update #alias
		
		draw_hp if hp_need_update?
		draw_mp if mp_need_update?
    draw_fome if fome_need_update?
    draw_stamina if stamina_need_update?
    @hp.visible = Input.press?(Input::A)
    @mp.visible = Input.press?(Input::A)
    @fome_bar.visible = Input.press?(Input::A)
    @stamina_bar.visible = Input.press?(Input::A)
    @backgroundHUD.visible = Input.press?(Input::A)
	end
 
	
	
   def hp_need_update?
		return true unless @actor_hp == @actor.hp
		return true unless @actor_mhp == @actor.mhp
    end
	def mp_need_update?
		return true unless @actor_hp == @actor.mp   
    #Only will return "true" if the hp of hero don't be equal to itself
    #Só vai retornar true se o hp do herói NÃO estiver igual ao do próprio herói
		return true unless @actor_mhp == @actor.mmp 
	end
  
  	def fome_need_update?
		return true unless @actor_fome == @actor.fome  

		return true unless @actor_mfome == @actor.mmp 
	end
  def stamina_need_update?
		return true unless @actor_stamina == @actor.stamina 

		return true unless @actor_mstamina == @actor.mstamina
	end
	
	
	def terminate
			enter_hud_terminate
			dispose_hud
	end
	
	def dispose_hud
		@hp.bitmap.dispose
		@hp.dispose
		@mp.bitmap.dispose
		@mp.dispose
    @fome_bar.bitmap.dispose
    @fome_bar.dispose
    @stamina_bar.bitmap.dispose
    @stamina_bar.dispose
    @backgroundHUD.bitmap.dispose
    @backgroundHUD.dispose
  end
end
