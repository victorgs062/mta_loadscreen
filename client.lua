local screenW,screenH = guiGetScreenSize()
local resW,resH = 1920,1080
local x,y =  (screenW/resW), (screenH/resH)

local InterMedium = dxCreateFont('files/fonts/Inter-Medium.ttf', y*15)
local InterRegular = dxCreateFont('files/fonts/Inter-Regular.ttf', y*13)

soundPaused = false

addEventHandler('onClientResourceFileDownload', root, function(resourceName, fileName, fileSize, fileState)
	rN = resourceName
	fN = fileName
end )

loadingDx = function()
	if not soundPaused then
		posicaoSom = getSoundPosition(soundLoad)
	end
	
	dxDrawImage(x*0, y*0, x*1920, y*1080, 'files/img/fundo.png', 0, 0, 0, tocolor(255,255,255,255))
	dxDrawImage(x * 46.07, y * 33.17, x * 42.87, y * 32.68, 'files/img/discord.png', 0, 0, 0, (isMouseInPosition(x * 46.07, y * 33.17, x * 42.87, y * 32.68) and tocolor(config.gerais.color[1], config.gerais.color[2], config.gerais.color[3], 255) or tocolor(80, 80, 80, 255)))
	dxDrawImage(x * 133.08, y * 35.21, x * 40.83, y * 28.58, 'files/img/youtube.png', 0, 0, 0, (isMouseInPosition(x * 133.08, y * 35.21, x * 40.83, y * 28.58) and tocolor(config.gerais.color[1], config.gerais.color[2], config.gerais.color[3], 255) or tocolor(80, 80, 80, 255)))
	dxDrawImage(x * 218.17, y * 34.17, x * 31.67, y * 31.67, 'files/img/instagram.png', 0, 0, 0, (isMouseInPosition(x * 218.17, y * 34.17, x * 31.67, y * 31.67) and tocolor(config.gerais.color[1], config.gerais.color[2], config.gerais.color[3], 255) or tocolor(80, 80, 80, 255)))
	
	dxDrawText(config.gerais.music, x * 1412, y * 20, x * (428+1412), y * (45+20), tocolor(237, 237, 237, 255), 1.00, InterMedium, "right", "center")
	dxDrawText(getResourceName(rN)..'/'..fN, x * 41, y * 962, x * (464+41), y * (38+962), tocolor(237, 237, 237, 255), 1.00, InterRegular, "left", "center")
	
	dxDrawImage(x*37, y*1000, x*1226, y*23, 'files/img/retangulo.png', 0, 0, 0, tocolor(0,0,0,140))
	dxDrawImageSection(37, 1000, (1226 * (porcentagemDownload / 100)), 23, 0, 0, (1226 * (porcentagemDownload / 100)), 23, "files/img/retangulo.png", 0, 0, 0, tocolor(config.gerais.color[1], config.gerais.color[2], config.gerais.color[3], 255), true)

	if soundPaused then
		dxDrawImage(x*1855, y*20, x*45, y*45, 'files/img/play.png', 0, 0, 0, tocolor(config.gerais.color[1], config.gerais.color[2], config.gerais.color[3],255))
	else
		dxDrawImage(x*1855, y*20, x*45, y*45, 'files/img/pause.png', 0, 0, 0, tocolor(config.gerais.color[1], config.gerais.color[2], config.gerais.color[3],255))
	end

	if isSoundFinished(soundLoad) and soundPaused == false then
		soundLoad = playSound('musica.mp3')
		setSoundVolume(soundLoad, 0.5)
	end
end


addEventHandler( 'onClientTransferBoxProgressChange', root, function(downloadAtual, totalSize)
	porcentagemDownload = math.min((downloadAtual / totalSize) * 100, 100)
	donwloaded = string.format('%.2f', downloadAtual / 1024 / 1024)
	totalS = string.format('%.2f', totalSize / 1024 / 1024)

	if ( not isEventHandlerAdded("onClientRender", getRootElement(), loadingDx )) then
		setTransferBoxVisible(false)
		soundLoad = playSound('musica.mp3')
		setSoundVolume(soundLoad, 0.5)
		addEventHandler( "onClientRender", getRootElement(), loadingDx )
		showCursor(true)
        showChat(false)
	end
end)

function clickCursor(b,s)
	if (b == 'left') and (s == 'down') then 
		if ( isEventHandlerAdded("onClientRender", getRootElement(), loadingDx )) then
			if isMouseInPosition(x*1855, y*20, x*45, y*45) then 
			soundControl()
			elseif isMouseInPosition(x * 46.07, y * 33.17, x * 42.87, y * 32.68) then 
				setClipboard ( config.links.Discord )
			elseif isMouseInPosition(x * 133.08, y * 35.21, x * 40.83, y * 28.58) then 
				setClipboard ( config.links.YouTube )
			elseif isMouseInPosition(x * 218.17, y * 34.17, x * 31.67, y * 31.67) then 
				setClipboard ( config.links.Instagram )
			end
		end
	end
end
addEventHandler('onClientClick', root, clickCursor)

checkDownload = function()
	if isTransferBoxActive() == false then
		if ( isEventHandlerAdded("onClientRender", getRootElement(), loadingDx )) then
			if soundLoad then
				stopSound( soundLoad )
			end
			posicaoSom = 0
			removeEventHandler( "onClientRender", getRootElement(), loadingDx )
			showCursor(false)
			showChat(true)
		end
	end
end
timerCheck = setTimer( checkDownload, 1000, 0 )

soundControl = function()
	if ( isEventHandlerAdded("onClientRender", getRootElement(), loadingDx )) then
		if soundPaused then
			soundLoad = playSound('musica.mp3')
			setSoundVolume(soundLoad, 0.5)
			setSoundPosition( soundLoad, posicaoSom )
			soundPaused = false
		else
			stopSound( soundLoad )
			soundPaused = true
		end
	end
end

function isSoundFinished(theSound)
	if not soundPaused then
    	return ( getSoundPosition(theSound) == getSoundLength(theSound) )
    else
    	return false
    end
end
	
function isMouseInPosition(x,y,w,h)
	if isCursorShowing() then
		local sx,sy = guiGetScreenSize()
		local cx,cy = getCursorPosition()
		local cx,cy = (cx*sx),(cy*sy)
		if (cx >= x and cx <= x+w) and (cy >= y and cy <= y+h) then
			return true
		end
	end
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

local _dxDrawImageSection = dxDrawImageSection;
function dxDrawImageSection(pX, pY, w, h, ...)
    return _dxDrawImageSection(x * pX, y * pY, x * w, y * h, ...);
end