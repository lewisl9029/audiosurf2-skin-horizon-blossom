jumping = PlayerCanJump()
function fif(test, if_true, if_false)
  if test then return if_true else return if_false end
end

hifi = GetQualityLevel() > 2 -- GetQualityLevel returns 1,2,or 3
function ifhifi(if_true, if_false)
  if hifi then return if_true else return if_false end
end

ultra = GetQualityLevel4() == 4 -- GetQualityLevel returns 1,2,or 3
function ifultra(if_true, if_false)
  if ultra then return if_true else return if_false end
end

quality = GetQualityLevel4()
function ByQuality4(low,med,high,ultra)
	if quality < 2 then return low
	elseif quality <3 then return med
	elseif quality <4 then return high
	else return ultra end
end

skinvars = GetSkinProperties()
trackWidth = skinvars["trackwidth"]
--trackWidth = fif(jumping, 11.5, 7)
ispuzzle = skinvars.colorcount>1
fullsteep = jumping or skinvars.prefersteep or (not ispuzzle)

SetScene{
	glowpasses = 0,
	glowspread = 0,
	radialblur_strength = ifultra(.4,0), -- foreground radial blur
	-- radialblur_strength = ifhifi(.1,0), -- foreground radial blur
--	radialblur_strength = fif(jumping,2,0),
	--environment = "city",
	watertype = 0,
	water = false, --only use the water cubes in wakeboard mode
	watertint = {r=230,g=230,b=230,a=100},
	watertexture = "WaterCubesBlue_BlackTop_WhiteLowerTier.png",--texture used to color the dynamic "digital water" surface
	towropes = false,--use the tow ropes if jumping
	airdebris_count = ifhifi(2000,0),
	airdebris_density = ifhifi(1,0),
	airdebris_texture = "sakura2.png",

--	airdebris_count = ifhifi(fif(jumping, 80000, 100000),1000),
--	airdebris_density = ifhifi(100,2),
    airdebris_particlesize = 10,
    airdebris_flashsizescaler = .1,
    -- airdebris_fieldsize = 300,
	airdebris_layer = 13,
	hide_default_background_verticals = true,
	use_intro_swoop_cam = false,

	useblackgrid=false,
	twistmode={curvescaler=1, steepscaler=fif(fullsteep,1,.65)} -- note: "cork" is the same as {curvescaler=1, steepscaler=1} and "cork_flatish" is the same as {curvescaler=1, steepscaler=.4}
}

SetBlockFlashes{
	texture=ByQuality4("hit32.jpg", "hit64.jpg", "hit128.jpg", "hit128.jpg")
}

--pixel style...
if ultra then
	radialBlurEffect = BuildMaterial{ -- background radial blur (seen mostly on star air debris trails)
		shader="PostRadialBlur",
		shadersettings={_Amount=.035, _Center={.5,.5,0}}
	}

	AddPostEffect{
		depth="background",
		material = radialBlurEffect
	}
end

if not jumping then
squareMesh = BuildMesh{
				recalculateNormalsEveryFrame=false,
				--splitVertices = true,
				--barycentricTangents = true,
				meshes={"squaremorph_baseline.obj", "squaremorph0.obj", "squaremorph1.obj", "squaremorph2.obj", "squaremorph3.obj", "squaremorph4.obj"}
			}

	SetBlocks{
		maxvisiblecount = fif(hifi,100,30),
		allow_mod_block_scaling = false,
		colorblocks={
			--mesh = "SingleLozenge.obj",
			mesh = "NewBlock.obj",
			reflect = ifhifi(true, false),
			--shader = fif(ispuzzle, "Diffuse", "Rim Light"),
			--shader = fif(ispuzzle, "Diffuse", "VertexColorUnlitTinted"),
			shader = fif(ispuzzle, "UnlitEdgedBlock", "UnlitEdgedBlock"),
			shadersettings={_Brightness=1.00},
			texture = "NewBlock.png",
		    height = 0,
		    float_on_water = false,
		    scale = {1.3,1,0.8}
		},
		greyblocks={
			--mesh = "singlespike.obj",
			mesh = "NewSpikeRot.obj",
			reflect = ifhifi(true, false),
			shader = "UnlitEdgedSpike",
			texture = "NewBlock.png"
			--shader = "VertexColorUnlitTinted",
			--texture = "doublespike.png"
		},
		powerups={--override the following objects in case the mod uses them
			powerpellet={
				--mesh = squareMesh,
				mesh = "PowerStar.obj",
				--shader = fif(hifi,"MatCap/Vertex/Textured Lit Double", "MatCap/Vertex/PlainBright"),
				shader = fif(ispuzzle, "UnlitEdgedBlock", "UnlitEdgedBlock"),
				--shadersettings = fif(hifi, {_Brightness=3.0}, {_Brightness=5}),
				shadersettings={_Brightness=1.00},
				--textures = {_MainTex="White.png", _MatCap="matcapchrome.jpg"},
				texture = "NewBlock.png",
				scale = {1,1,1},
				--scale = {2.7,2.7,2.7},
				shadercolors = {_Color="highway", scaletype="intensity", minscaler=2, maxscaler=2.5},
				reflect = ifhifi(true, false)
			}
		}
	}
end

SetPuzzleGraphics{
	usesublayerclone = false,
	puzzlematchmaterial = {shader="Unlit/Transparent",texture="tileMatchingBars.png",aniso=9},
	puzzleflyupmaterial = {shader="VertexColorUnlitTintedAddFlyup",texture="tileMatchingBars.png"},
	puzzlematerial = {shader="VertexColorUnlitTintedAlpha",texture="tilesSquare.png",texturewrap="clamp",aniso=9, usemipmaps="false",shadercolors={_Color={255,255,255,255}}}
}

if jumping then
	SetPlayer{
		--showsurfer = true,
		--showboard = true,
		cameramode = "first_jumpthird",
		--cameramode_air = "third",--"first_jumptrickthird", --start in first, go to third for jumps and tricks

		camfirst={ --sets the camera position when in first person mode. Can change this while the game is running.
			pos={0,2.7,-3.50475},
			rot={20.49113,0,0},
			strafefactor = 1
		},
		camthird={ --sets the two camera positions for 3rd person mode. lerps out towards pos2 when the song is less intense
			pos={0,2.7,-3.50475},
			rot={20.49113,0,0},
			strafefactor = 0.75,
			pos2={0,2.8,-3.50475},
			rot2={20.49113,0,0},
			strafefactorFar = 1},
		surfer={ --set all the models used to represent the surfer
			arms={
				--mesh="arm.obj",
				shader="RimLightHatchedSurfer",
				shadercolors={
					_Color={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=6, param="_Threshold", paramMin=2, paramMax=2},
					_RimColor={255,255,255}
				},
				texture="FullLeftArm_1024_wAO.png"
			},
			board={
				--mesh="wakeboard.obj",
				shader=ifhifi("RimLightHatchedSurferExternal","VertexColorUnlitTinted"), -- don't use the transparency shader in lofi mode. less fillrate needed that way
				renderqueue=3999,
				shadercolors={ --each color in the shader can be set to a static color, or change every frame like the arm model above
					_Color={colorsource="highway", scaletype="intensity", minscaler=5, maxscaler=5},
					_RimColor={0,0,0}
				},
				shadersettings={
					_Threshold=11
				},
				texture="board_internalOutline.png"
			},
			body={
				--mesh="surferbot.obj",
				shader="RimLightHatchedSurferExternal", -- don't use the transparency shader in lofi mode. less fillrate needed that way
				renderqueue=3000,
				layer = 14,
				shadercolors={
					_Color={colorsource="highway", scaletype="intensity", minscaler=3, maxscaler=3},
					_RimColor={255,255,255}
				},
				shadersettings={
					_Threshold=1.7
				},
				texture="robot_HighContrast.png"
			}
		}
	}
else
    local shipMesh = BuildMesh{
			mesh="racingship_scaled75.obj",
			barycentricTangents = true, --for use with wireframe shaders
			--calculateTangents = true,
			calculateNormals = false,
			submeshesWhenCombining = false
		}

		shipMaterial = BuildMaterial{
			renderqueue = 2000,
			shader="UnlitTintedTexGlowWire",
			shader = "MatCap/Vertex/PlainBrightGlow",
			shadersettings={_GlowScaler=9, _Brightness=.66},
			shadercolors={
				_Color = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=1},
				--_SpecColor = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=1},
				_GlowColor = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=1}
				},
			textures={_MatCap="matcapchrome2.jpg", _Glow="glowBWj1.png"}
		}

		vehicleTable={
			min_hover_height= 0.11,
			max_hover_height = 1.4,
			use_water_rooster = false,
            smooth_tilting = false,
            smooth_tilting_speed = 10,
            smooth_tilting_max_offset = -20,
			pos={x=0,y=0,z=0},
			--scale={x=.75, y=.75, z=.75},

			mesh = shipMesh,--built with BuildMesh above
			--materials = {shipMaterial}, --assign the pre-created material
			material = shipMaterial,
			reflect = true,
			--mesh="racingship.obj",
			--calculateTangents = true,
			--calculateNormals = false,
			--submeshesWhenCombining = false,
			layer = 15,
--			renderqueue = 2000,
--			shader="SelfGlowBumpSpec2_compiled.shader",
--			shadersettings={_Shininess=0.1, _GlowScaler=9},
--			shadercolors={
--				_Color = {colorsource="highwayinverted", scaletype="intensity", minscaler=1, maxscaler=1},
--				_SpecColor = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=1},
--				_GlowColor = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=1}
--				},
--			textures={_MainTex="maintex_darkerNeg170_highlights.png", _BumpMap="normal.png", _Glow="glowBW.png"},
			scale = {x=1,y=1,z=1},
			thrusters = {crossSectionShape={{-.35,-.35,0},{-.5,0,0},{-.35,.35,0},{0,.5,0},{.35,.35,0},{.5,0,0},{.35,-.35,0}},
						perShapeNodeColorScalers={.5,1,1,1,1,1,.5},
						shader="TransparentShadowCaster",
						layer = 14,
						renderqueue = 3000,
						colorscaler = {close=2.5, far=0},
						sizefalloff = 1,
						minrenderedsize = 0.05,
						extrusions=25,
						stretch=-0.1191,
						updateseconds = 0.025,
						instances={
							{pos={0.03,0.49,-1.62},rot={0,0,0},scale={0.6,0.6,0.6}},
							{pos={0.03,0.49,-1.62},rot={0,0,0},scale={0.45,0.45,0.8}},
							{pos={0.03,0.49,-1.62},rot={0,0,0},scale={0.3,0.3,0.8}},
							{pos={0.03,0.49,-1.62},rot={0,0,0},scale={0.1,0.1,0.8}},

							{pos={0.31,0.28,-1.64},rot={0,0,0},scale={0.3,0.3,0.66}},
							{pos={0.31,0.28,-1.64},rot={0,0,0},scale={0.1,0.1,0.66}},

							{pos={-0.25,0.28,-1.64},rot={0,0,0},scale={0.3,0.3,0.66}},
							{pos={-0.25,0.28,-1.64},rot={0,0,0},scale={0.1,0.1,0.66}}
						}}
		}
	SetPlayer{
        
		--showsurfer = false,
		--showboard = false,
		cameramode = "third",
	--	cameramode_air = "first",--"first_jumptrickthird", --start in first, go to third for jumps and tricks

		camfirst={
			pos={0,1.84,-0.8},
			rot={20,0,0}},
		camthird={
			pos={0,2,-0.5},
			rot={30,0,0},
			strafefactorFar = .75,
			pos2={0,5,-4},
			rot2={30,0,0},
			strafefactorFar = 1,
			transitionspeed = 1,
			puzzleoffset=-0.65,
			puzzleoffset2=-1.5},
        vehicle=vehicleTable
		-- vehicle={ --livecoding not supported here
		-- 	min_hover_height= 0.23,
		-- 	max_hover_height = 0.8,
		-- 	use_water_rooster = false,
        --     smooth_tilting = false,
        --     smooth_tilting_speed = 10,
        --     smooth_tilting_max_offset = -20,
		-- 	pos={x=0,y=0,z=0},
		-- 	mesh="ninjamono.obj",
		-- 	--shader="VertexColorUnlitTintedPixelate",
		-- 	shader="Rim Light Pixelate",
		-- 	--layer = ifhifi(14,15), -- in hifif mode, render it to the topmost only. so the non-pixelated parts don't show through
		-- 	layer = 15,
		-- 	reflect = ifhifi(true, false),
		-- 	renderqueue = 2000,
		-- 	shadersettings={_Scale=8, _Brightness=1.5},
		-- 	shadercolors={
		-- 		_Color = {colorsource="highway", scaletype="intensity", minscaler=1, maxscaler=1.5},
		-- 		_RimColor = {0,0,0}},
		-- 	texture="ninjaMono.png",
		-- 	scale = {x=1,y=1,z=1},
        --     thrusters =ifhifi( {crossSectionShape={{-.35,-.35,0},{-.5,0,0},{-.35,.35,0},{0,.5,0},{.35,.35,0},{.5,0,0},{.35,-.35,0}},
		-- 				perShapeNodeColorScalers={.5,1,1,1,1,1,.5},
		-- 				--shader="VertexColorUnlitTinted",
		-- 				shader="VertexColorUnlitTintedAddSmooth",
		-- 				layer = 14,
		-- 				renderqueue = 2999,
		-- 				colorscaler = 2,
		-- 				extrusions=22,
		-- 				stretch=-0.1191,
		-- 				updateseconds = 0.025,
		-- 				instances={
		-- 					{pos={0,.46,-1.28},rot={0,0,0},scale={.7,.7,.7}},
		-- 					{pos={.175,0.21,-1.297},rot={0,0,58.713},scale={.7,.7,.7}},
		-- 					{pos={-.175,0.21,-1.297},rot={0,0,313.7366},scale={.7,.7,.7}}
		-- 				}}, false)
		-- }
    -- vehicle={
		-- 	--mesh="AS2_ITM3D_Cube-Pickup_small.obj",
		-- 	mesh="AS2_ITM2D_Game-Vehicle.obj",
		-- 	texture="AS2_ITM2D_Game-Vehicle_DIF.jpg",
		-- 	scale = {x=1,y=1,z=1},
		-- 	min_hover_height= 0.11,
		-- 	shadowcaster = true,
		-- 	shadowreceiver = true,
		-- 	max_hover_height = 1.4,
		-- 	use_water_rooster = false,
    --         smooth_tilting = false,
    --         reflect = true,
    --         rollscaler = -1,
		-- 	pos={x=0,y=0,z=0},
		-- 	shader="Diffuse",
		-- 	layer = 13,
		-- 	renderqueue = 2000,
		-- 	thrusters = {crossSectionShape={{-.35,-.35,0},{-.5,0,0},{-.35,.35,0},{0,.5,0},{.35,.35,0},{.5,0,0},{.35,-.35,0}},
		-- 				perShapeNodeColorScalers={.5,1,1,1,1,1,.5},
		-- 				--shader="VertexColorUnlitTinted",
		-- 				shader="Diffuse",
		-- 				layer = 13,
		-- 				renderqueue = 1, -- 3999,
		-- 				colorscaler = 2,
		-- 				extrusions=25,
		-- 				stretch=-0.1191,
		-- 				updateseconds = 0.025,
		-- 				instances={
		-- 					{pos={0,.26,-1.76},rot={0,0,0},scale={.3,.25,.7}}--,
		-- 					--{pos={.19,0.17,-1},rot={0,0,58.713},scale={.15,.15,.7}},
		-- 					--{pos={-.19,0.17,-1},rot={0,0,313.7366},scale={.15,.15,.7}}
		-- 				}}
		-- }
	}
end

function Update(dt, trackLocation, playerStrafe, playerJumpHeight, intensity)
    if not hifi then
        return
    end
	if shipMaterial then
		local enginePower = 3 + 20*intensity
		UpdateShaderSettings{material=shipMaterial, shadersettings={_GlowScaler=enginePower}}
	end
end

--if hifi then
--	SetSkybox{
--		skyscreen = "Skyscreen/TheGrid"
--	}
--else
SetSkybox{
  sky=ifhifi({
    showsun = false,
    flare = false,
    month=8,
    hour=13,
    minute=0,
    longitude=184.5,
    cloudmaxheight=2.0,
    cloudminheight=-4.0,
    clouddensity=0.6,
    cirrusposition=-4.0,
    useProceduralAmbientLight = true,
    useProceduralSunLight = true
  }, nil),
	skysphere="skybox4.png",
	--color=fogColor
	color={255,255,255,255}
}
	--SetSkybox{ --this shows how to set up a skybox. There's also a dynamic sky system that's used by the audiosprint skin. It could be used here too.
	--	skysphere="skybox.png"
	--}
--end

SetTrackColors{ --enter any number of colors here. The track will use the first ones on less intense sections and interpolate all the way to the last one on the most intense sections of the track
	    {r=170, g=0, b=255},
	    {r=63, g=81, b=181},
	    {r=0, g=176, b=255},
		{r=0, g=200, b=83},
		{r=255, g=235, b=59},
		{r=230, g=81, b=0},
		{r=213, g=0, b=0}
}

if skinvars.colorcount < 5 then
	SetBlockColors{
	    {r=170, g=0, b=255},
	    {r=0, g=176, b=255},
		{r=0, g=200, b=83},
		{r=230, g=81, b=0},
		{r=213, g=0, b=0}
	}
else
	SetBlockColors{
	    {r=170, g=0, b=255},
	    {r=63, g=81, b=181},
	    {r=0, g=176, b=255},
		{r=0, g=200, b=83},
		{r=255, g=235, b=59},
		{r=230, g=81, b=0},
		{r=213, g=0, b=0}
	}
end

--SetBlockColors{ --this is only used for puzzle modes (which you don't have yet) with multiple colors of blocks
--    {r=93, g=8, b=132},
--	{r=1.0, g=0.27, b=0.2},
--    {r=0.047, g=0.5098, b=0.94},
--    {r=1.0, g=0.85, b=0.4157},
--	{r=0, g=0.29, b=0.08},
--    {r=1,g=0,b=0}
--}

--wakeHeight = 2
--if jumping then wakeHeight=2 else wakeHeight = 0 end
--SetWake{ --setup the spray coming from the two pulling "boats"
--	height = wakeHeight,
--	fallrate = 0.95,
--	shader = "VertexColorUnlitTinted",
--	layer = 13, -- looks better not rendered in background when water surface is not type 2
--	bottomcolor = {r=0,g=0,b=100},
--	topcolor = "highway"
--}

wakeHeight = 2
if jumping then wakeHeight=2 else wakeHeight = 0 end
SetWake{ --setup the spray coming from the two pulling "boats"
	height = wakeHeight,
	fallrate = .999,
	shader = "VertexColorUnlitTintedAddSmooth",
	layer = 13, -- looks better not rendered in background when water surface is not type 2
	bottomcolor = "highway",
	topcolor = {r=0,g=0,b=0}
}

SetRings{ --setup the tracks tunnel rings. the airtexture is the tunnel used when you're up in a jump
    texture = "aRing_FadedEarringAlphaTestable_1024_4.png",
	--texture = ByQuality4("aRing_FadedEarringAlphaTestable_256.png", "aRing_FadedEarringAlphaTestable_512.png", "aRing_FadedEarringAlphaTestable_1024.png", "aRing_FadedEarringAlphaTestable_1024.png"),
	--texture="Classic_OnBlack",
	shader="VertexColorUnlitTintedAddSmooth",
	-- shader = "VertexColorUnlitTintedAddDouble",
	layer = 13, -- on layer13, these objects won't be part of the glow effect
	size=trackWidth*2, --22
	offset = fif(jumping, {0,0,0}, {0,1,0}),
	percentringed=ifhifi(.4, .2),-- .2,
	airtexture="Bits.png",
	airshader="VertexColorUnlitTintedAddSmoothNoDepth",
	airsize=ifhifi(16, 0)
}


track = GetTrack()--get the track data from the game engine


--RAILS. rails are the bulk of the graphics in audiosurf. Each one is a 2D shape extruded down the length of the track.
-- if #skinvars["lanedividers"] > 2 then
-- 	local laneDividers = skinvars["lanedividers"]
-- 	for i=1,#laneDividers do
-- 		CreateRail{ -- lane line
-- 			positionOffset={
-- 				x=laneDividers[i],
-- 				y=0.1},
-- 			crossSectionShape={
-- 				{x=-.07,y=0},
-- 				{x=.07,y=0}},
-- 			perShapeNodeColorScalers={
-- 				1,
-- 				1},
-- 			colorMode="static",
-- 			color = {r=255,g=255,b=255,a=125},
-- 			flatten=false,
-- 			nodeskip = 2,
-- 			wrapnodeshape = false,
-- 			shader="VertexColorUnlitTintedAlpha",
-- 			shadercolors={_Color={r=255,g=255,b=255,a=255}}
-- 		}
-- 	end
-- end



--CreateRail{--big cliff low detail. This one will almost always be able to render the song's full future.
--	positionOffset={
--		x=0,
--		y=0},
--	crossSectionShape={
--		{x=0,y=-4},
--		{x=0,y=-35}
--		},
--	perShapeNodeColorScalers={
--		1,
--		.4},
--	colorMode="highway",
--	color = {r=255,g=255,b=255},
--	flatten=false,
--	wrapnodeshape = true,
--	texture="cliffRails.png",
--	fullfuture = true,
--	stretch = 3,
--	calculatenormals = true,
--	shader="Cliff"
--}

--[[
CreateRail{--distant water
	positionOffset={
		x=0,
		y=0},
	crossSectionShape={
		{x=-12,y=-5.5},
		{x=12,y=-5.5}},
	perShapeNodeColorScalers={
		1,
		1},
	colorMode="static",
	color = {r=0,g=137,b=255},
	flatten=false,
	wrapnodeshape = false,
    layer=13,
	texture="White.png",
	shader="VertexColorUnlitTinted"
}
--]]

--if jumping then wakeHeight=(ifhifi(4,2)) else wakeHeight = 0 end
wakeHeight=(ifhifi(4,2))
extraWidth = trackWidth - 5
if jumping then extraWidth = 0 end
wakeStrafe = 7.5 + extraWidth
--wakeStrafe = 14.7
if not jumping then wakeHeight = 2 end
SetWake{ --setup the spray coming from the two pulling "boats"
	height = wakeHeight,
	fallrate = 0.95,
	--offsets = {{wakeStrafe,0,0}, {-wakeStrafe,0,0}, {0,0,0}},
	offsets = {{wakeStrafe,0,0}, {-wakeStrafe,0,0}},
	--strafe = wakeStrafe,
	shader = fif(jumping, "VertexColorUnlitTintedAddSmooth", "VertexColorUnlitTintedAddSmoothQuarter"),
	layer = fif(jumping, 11, 13), -- looks better not rendered in background when water surface is not type 2
	bottomcolor = fif(jumping, "highway", "highwayinverted"), -- {r=114,g=148,b=255},
	topcolor = {r=0,g=0,b=0}
}

CreateRail{--road surface
    positionOffset={
        x=0,
        y=0},
    crossSectionShape={
        {x=-trackWidth,y=0},
        {x=trackWidth,y=0}},
    colorMode="static",
    layer=13,
    wrapnodeshape = false,
    fullfuture = true,
    color = {r=255,g=255,b=255,a=125},
    flatten=false,
    renderqueue=3000,
    --texture="subroad.png",
    shader="VertexColorUnlitTintedAlpha",
    shadercolors={_Color={r=255,g=255,b=255,a=255}}
}

local shoulderLines = skinvars["shoulderlines"]
for i=1,#shoulderLines do
    CreateRail{ -- lane line
        positionOffset={
            x=shoulderLines[i],
            y=0.02},
        crossSectionShape={
            {x=-.1,y=0},
            {x=.1,y=0}},
        perShapeNodeColorScalers={
            1,
            1},
        colorMode="highwayinverted",
        color = {r=255,g=255,b=255},
        flatten=false,
        --nodeskip = 2,
        wrapnodeshape = false,
        shader="VertexColorUnlitTintedAddSmooth"
    }
    CreateRail{ -- lane line
        positionOffset={
            x=shoulderLines[i],
            y=0.04},
        crossSectionShape={
            {x=-.04,y=0},
            {x=.04,y=0}},
        perShapeNodeColorScalers={
            1,
            1},
        colorMode="highwayinverted",
        color = {r=255,g=255,b=255},
        flatten=false,
        --nodeskip = 2,
        wrapnodeshape = false,
        shader="VertexColorUnlitTintedAddSmooth"
    }
end

CreateRail{--left wake guide
    positionOffset={
        x=-wakeStrafe,
        y=0},
    crossSectionShape={
        {x=-.1,y=-.05},
        {x=-.1,y=.05},
        {x=.1,y=.05},
        {x=.1,y=-.05}},
    perShapeNodeColorScalers={
        1,
        1,
        1,
        1},
    colorMode=fif(jumping,"highway","highwayinverted"),
    color = {r=255,g=255,b=255},
    flatten=jumping,
    texture="White.png",
    renderqueue=2999,
    shader="VertexColorUnlitTintedAddSmooth"
}

CreateRail{--right wake guide
    positionOffset={
        x=wakeStrafe,
        y=0},
    crossSectionShape={
        {x=-.1,y=-.05},
        {x=-.1,y=.05},
        {x=.1,y=.05},
        {x=.1,y=-.05}},
    perShapeNodeColorScalers={
        1,
        1,
        1,
        1},
    colorMode=fif(jumping,"highway","highwayinverted"),
    color = {r=255,g=255,b=255},
    flatten=jumping,
    texture="White.png",
    renderqueue=2999,
    shader="VertexColorUnlitTintedAddSmooth"
}

auroraExtent = ifhifi(77, 22)
CreateRail{--left aurora
	positionOffset={
		x=-18,
		y=33},
	crossSectionShape={
		{x=-auroraExtent,y=.5},
		{x=-11,y=.5},
		{x=-11,y=-.5},
		{x=-auroraExtent,y=-.5}},
	perShapeNodeColorScalers={
		0,
		1,
		1,
		0},
	colorMode="aurora",
	color = {r=255,g=255,b=255},
	flatten=true,
    layer=11,
	texture="White.png",
	renderqueue=2999,
	shader="VertexColorUnlitTintedAddSmooth"
}

CreateRail{--left aurora lower
	positionOffset={
		x=0,
		y=-20},
	crossSectionShape={
		{x=-auroraExtent,y=.5},
		{x=-11,y=.5},
		{x=-11,y=-.5},
		{x=-auroraExtent,y=-.5}},
	perShapeNodeColorScalers={
		0,
		1,
		1,
		0},
	colorMode="aurora",
	color = {r=255,g=255,b=255},
	flatten=true,
    layer=11,
	texture="White.png",
	renderqueue=2999,
	shader="VertexColorUnlitTintedAddSmooth"
}

CreateRail{--right aurora
	positionOffset={
		x=18,
		y=33},
	crossSectionShape={
		{x=11,y=.5},
		{x=auroraExtent,y=.5},
		{x=auroraExtent,y=-.5},
		{x=11,y=-.5}},
	perShapeNodeColorScalers={
		1,
		0,
		0,
		1},
	colorMode="aurora",
	color = {r=255,g=255,b=255},
	flatten=true,
    layer=11,
	texture="White.png",
	renderqueue=2999,
	shader="VertexColorUnlitTintedAddSmooth"
}

CreateRail{--right aurora lower
	positionOffset={
		x=0,
		y=-20},
	crossSectionShape={
		{x=11,y=.5},
		{x=auroraExtent,y=.5},
		{x=auroraExtent,y=-.5},
		{x=11,y=-.5}},
	perShapeNodeColorScalers={
		1,
		0,
		0,
		1},
	colorMode="aurora",
	color = {r=255,g=255,b=255},
	flatten=true,
    layer=11,
	texture="White.png",
	renderqueue=2999,
	shader="VertexColorUnlitTintedAddSmooth"
}