########################
#author: leolucass(=Enter)
########
class Game_BattlerBase
  attr_accessor :stamina
 
  alias alsintlzgmactr initialize
 
  def initialize(*args)
    alsintlzgmactr(*args)
    @stamina = 222
  end
 
end
class Scene_Map < Scene_Base
  #include SetHUD
	alias enter_hud_start start
	alias enter_hud_update update
	alias enter_hud_terminate terminate
 
	def start
		enter_hud_start #alias
		@actor = $game_party.members[0]
    #getMax_Stamina
    #getStamina
		create_hud
		update_variables
	end
	
	def create_hud
		create_sprites
		create_bitmaps
		get_bitmap_size
		draw_hp
		draw_mp
		draw_stamina
		draw_fome
	end
	
	def update_variables
		@actor_hp = @actor.hp
		@actor_mhp = @actor.mhp
		@actor_mp = @actor.mp
		@actor_mmp = @actor.mmp
		@actor_stamina = @stamina
    @actor_fome = @actor.mp
    @actor_mfome = @actor.mmp
		
	end
	
	def create_sprites
		@hp = Sprite.new
		@mp = Sprite.new
		@stamina_bar = Sprite.new
		@fome_bar = Sprite.new
	end
	def create_bitmaps
		@hp.bitmap = bitmap = Cache.picture('barraenergia')
		@mp.bitmap = bitmap = Cache.picture('barraenergia')
		@stamina_bar.bitmap = bitmap = Cache.picture('barraenergia')
		@fome_bar.bitmap = bitmap = Cache.picture('barraenergia')
	end
	
	def get_bitmap_size
		@hpw = @hp.width
		@hph = @hp.height
		@mpw = @mp.width
		@mph = @mp.height
		@staminaw = @stamina_bar.width
		@staminah = @stamina_bar.height
		@fomew = @mp.width
		@fomeh = @mp.height
	end
	
	def draw_hp
		@hp.bitmap.clear
		@hp.bitmap = Bitmap.new(@hpw,@hph)
		hpw = @hpw * @actor.hp/@actor.mhp #Define a largura da barra
		hph = @hph
		rect = Rect.new(0,0,hpw,hph)
		@hp.bitmap.blt(0,0,Cache.picture("barraenergiaCompleta"),rect)
		@hp.x = 205
		@hp.y = 380
    end
	 def draw_mp
 
		@mp.bitmap.clear
		@mp.bitmap = Bitmap.new(@mpw,@mph)
		mpw = @mpw * @actor.mp / @actor.mmp
		mph = @mph
		rect = Rect.new(0,0,mpw,mph)
		@mp.bitmap.blt(0,0,Cache.picture("barraenergiaCompleta"),rect)
		@mp.x = 205
		@mp.y = 400
     
	end
   def draw_stamina
		@stamina_bar.bitmap.clear
		@stamina_bar.bitmap = Bitmap.new(@staminaw,@staminah)
		staminaw = @actor.stamina
		staminah = @actor.stamina
		rect = Rect.new(0,0,staminaw ,staminah)
		@stamina_bar.bitmap.blt(0,0,Cache.picture("barraenergiaCompleta"),rect)
		@stamina_bar.x = 205
		@stamina_bar = 340
	end
  
	 def draw_fome
		@fome_bar.bitmap.clear
		@fome_bar.bitmap = Bitmap.new(@fomew,@fomeh)
		fomew = @mpw * @actor.mp/ @actor.mmp #Define a largura da barra
		fomeh= @mph
			rect = Rect.new(0,0,fomew ,fomeh)
		@fome_bar.bitmap.blt(0,0,Cache.picture("barraenergiaCompleta"),rect)
		@fome_bar.x = 205
		@fome_bar.y = 320
    end
	
	
	 def update
		enter_hud_update #alias
		
		draw_hp if hp_need_update?
		draw_mp if mp_need_update?
		draw_stamina if stamina_need_update?
    fome_need_update?
 
		 
	end
	
	
	
	
   def hp_need_update?
		return true unless @actor_hp == @actor.hp
		return true unless @actor_mhp == @actor.mhp
    end
	def mp_need_update?
		return true unless @actor_hp == @actor.mp  #Só vai retornar true se o hp do herói NÃO estiver igual ao do próprio herói
 
		return true unless @actor_mhp == @actor.mmp #do máximo 
	end
	def stamina_need_update?
		return true unless @actor_stamina == @stamina
  end
  
  	def fome_need_update? #*está dando erro, pois vc precisa associar ao heroi, para que o evento diminua o valor dessa variavel
		return true unless @actor_fome == @actor.mp  #Só vai retornar true se o hp do herói NÃO estiver igual ao do próprio herói
 
		return true unless @actor_mfome == @actor.mmp #do máximo 
	end
	
	
	def terminate
			enter_hud_terminate
			dispose_hud
	end
	
	def dispose_hud
		@hp.bitmap.dispose
		@hp.bitmap.dispose
		@stamina_bar.bitmap.dispose
		@stamina.dispose
		@mp.bitmap.dispose
		@mp.dispose
  end
end