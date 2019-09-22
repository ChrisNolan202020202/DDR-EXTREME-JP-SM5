local t = LoadFallbackB();

t[#t+1] = StandardDecorationFromFileOptional("StyleIcon","StyleIcon");
t[#t+1] = StandardDecorationFromFile("StageDisplay","StageDisplay")
<<<<<<< HEAD
t[#t+1] = LoadActor("BannerHandler.lua");
=======
t[#t+1] = loadfile( THEME:GetPathB("ScreenSelectMusic","decorations/BannerHandler.lua") )();
t[#t+1] = StandardDecorationFromFile("BannerFrame","BannerFrame")
>>>>>>> 02a5ad6b3f7b6c1cfec507b64be1c6f0cc2f9ad1
t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay")
t[#t+1] = StandardDecorationFromFileOptional("SortDisplay","SortDisplay")

if not GAMESTATE:IsCourseMode() then
	for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
		t[#t+1] = loadfile( THEME:GetPathB("ScreenSelectMusic","decorations/diff") )(pn);
		t[#t+1] = loadfile( THEME:GetPathB("ScreenSelectMusic","decorations/modicons") )(pn)..{
			InitCommand=function(s) s:draworder(100) end,
		};
	end;

	t[#t+1] = StandardDecorationFromFileOptional("GrooveRadar","GrooveRadar")

	-- other items (balloons, etc.)

	t[#t+1] = StandardDecorationFromFile( "Balloon", "Balloon" );

	t[#t+1] = Def.Sprite{
		Texture="GrooveRadar base",
		InitCommand=function(s) s:xy(SCREEN_CENTER_X-168,SCREEN_CENTER_Y+90) end,
		OnCommand=function(s) s:zoom(0):rotationz(-360):sleep(0.3):decelerate(0.4):rotationz(0):zoom(1) end,
		OffCommand=function(s) s:sleep(0.4):accelerate(0.383):zoom(0):rotationz(-360) end,
		BeginCommand=function(self,param) self:visible( not GAMESTATE:IsCourseMode() ) end;
	}

	t[#t+1] = Def.ActorFrame{
		OnCommand=function(s)
			s:fov(10):draworder(101)
			:xy( SCREEN_CENTER_X-84, SCREEN_CENTER_Y-83 )
			:vanishpoint(SCREEN_CENTER_X-84, SCREEN_CENTER_Y-83)
			:addx(-280):sleep(0.450):linear(0.267):addx(274)
			:linear(0.05):addx(-6):decelerate(0.116):addx(12):decelerate(0.067)
			:addx(-4):decelerate(0.1):addx(4)
		end,
		OffCommand=function(s)
			s:accelerate(0.316):addx(-SCREEN_WIDTH/2.28)
		end,
		CurrentSongChangedMessageCommand=function(s)
			local c = {"BorderBack","Front","Back","BorderFront"}
			for v in ivalues(c) do
				s:GetChild(v):GetChild("Spr"):visible(false)
				if GAMESTATE:GetCurrentSong() then
					if GAMESTATE:GetCurrentSong():GetCDTitlePath() then
						s:GetChild(v):GetChild("Spr"):visible(true):Load( GAMESTATE:GetCurrentSong():GetCDTitlePath() )
					end
				end
			end
		end,

		Def.ActorFrame{
			Name="BorderBack",
			OnCommand=function(s) s:spin():effectmagnitude(0,-180,0) end,
			Def.Sprite{
				Name="Spr", OnCommand=function(s) s:z(-2):glowshift()
					:effectcolor1(color("1,1,1,1")):cullmode("CullMode_Back") end,
			},
		},
		Def.ActorFrame{
			Name="Back",
			OnCommand=function(s) s:spin():effectmagnitude(0,-180,0) end,
			Def.Sprite{
				Name="Spr", OnCommand=function(s) s:shadowlength(1):cullmode("CullMode_Back"):glowshift():effectcolor2(color("0,0,0,0.7")):effectcolor1(color("0,0,0,0")) end,
			},
		},
		Def.ActorFrame{
			OnCommand=function(s) s:spin():effectmagnitude(0,-180,0) end,
			Name="Front",
			Def.Sprite{ Name="Spr", OnCommand=function(s) s:shadowlength(1):glow(Color.White):diffuse(color("0,0,0,1")):cullmode("CullMode_Front") end }
		},
		Def.ActorFrame{
			Name="BorderFront",
			OnCommand=function(s) s:spin():effectmagnitude(0,-180,0) end,
			Def.Sprite{ Name="Spr", OnCommand=function(s) s:z(-2):glowshift():effectoffset(0.5):effectcolor2(color("0.7,0.7,0.7,1")):effectcolor1(Color.Black):cullmode("CullMode_Front") end,
		},
		}
	}

	local GRPos = {
		{-3,-90},
		{-104,-31},
		{-99,47},
		{98,47},
		{107,-31},
	}

	for i,v in ipairs(GRPos) do
		t[#t+1] = Def.Sprite{
			Texture=THEME:GetPathG("GrooveRadar","labels"),
			OnCommand=function(s)
				s:animate(0):setstate(i-1)
				:xy(SCREEN_CENTER_X-168+v[1],SCREEN_CENTER_Y+92+v[2])
				:diffusealpha(0):addx(-10):sleep(0.1+i/10):linear(0.1):diffusealpha(1):addx(10)
			end;
			OffCommand=function(s)
				s:sleep(i/10):linear(0.1):diffusealpha(0):addx(-10)
			end;
		}
	end
end

t[#t+1] = Def.Sprite {
Texture="help 1x3.png",
	InitCommand=function(self)
		self:draworder(100):CenterX():y(SCREEN_BOTTOM-35)
		self:SetAllStateDelays(4.224)
	end,
	OnCommand=function(self)
		self:shadowlength(0):addy(999):sleep(0.6):addy(-999):diffuseblink():effectperiod(1.056)
	end,
	OffCommand=function(self)
		self:addy(999)
	end
};

local numwh = THEME:GetMetric("MusicWheel","NumWheelItems")+2
t[#t+1] = Def.Actor{
	OnCommand=function(s)
		if SCREENMAN:GetTopScreen() then
			local wheel = SCREENMAN:GetTopScreen():GetChild("MusicWheel"):GetChild("MusicWheelItem")
			for i=1,numwh do
				local inv = numwh-math.round( (i-numwh/2) )+1
				wheel[i]:addx(500)
				:sleep( (i < numwh/2) and i/20 or inv/20 )
				:decelerate(0.5):addx(-500)
			end
		end
	end;
	OffCommand=function(s)
		SOUND:PlayAnnouncer("select group comment all music")
		if SCREENMAN:GetTopScreen() then
			local wheel = SCREENMAN:GetTopScreen():GetChild("MusicWheel"):GetChild("MusicWheelItem")
			for i=1,numwh do
				local inv = numwh-math.round( (i-numwh/2) )+1
				wheel[i]:sleep( (i < numwh/2) and i/20 or inv/20 )
				:accelerate(0.5):addx(500):sleep(1)
			end
		end
	end;
}

return t
