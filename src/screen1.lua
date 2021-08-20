local title = "Inventory" -- export: Name your display.
local bgtext = "Medium Heavy Cargo Ship" -- export: Background text of your choice.
local bgPlanetImg = "assets.prod.novaquark.com/20368/954f3adb-3369-4ea9-854d-a14606334152.png" -- export: (Default: Alioth URL)
local pollRate = 0.06667 -- export: (Default: 0.066667) just a bit slower than the programming board to avoide duplicates.

local fontCache = {}

local rx, ry = getResolution()

local bglayer = createLayer()
local statusLayer = createLayer()
local itemLayer = createLayer()
local curlayer = createLayer()

local cx, cy = getCursor()
click = getCursorPressed()

local json = require('dkjson')

local baseFolder = "assets.prod.novaquark.com"

local itemImages = {
    Hematite = baseFolder.."/70186/4ff8e9b7-5ed8-4b62-9b02-219219081efa.png",
    Bauxite = baseFolder.."/70186/2a660dc9-9af6-4f4b-87d3-bba4defb1964.png",
    Coal = baseFolder.."/70186/edc9f97e-7359-454e-8ba9-8f960037ae9b.png",
    Quartz = baseFolder.."/70186/a8d1c39e-d3d3-4a75-bce1-348036588108.png",
    Natron = baseFolder.."/70186/cec7c516-9f70-4b2b-9d60-6f9527ae36a8.png",
    Chromite = baseFolder.."/70186/b7357f8d-43ce-4279-a7d3-75fb6fda4fcd.png",
    Limestone = baseFolder.."/70186/dc16bf83-bc00-42b3-8f71-1683e8350efb.png",
    Malachite = baseFolder.."/45824/36e5a9ca-c9f6-4e66-b2f4-fe64c9289224.png",
    Pyrite = baseFolder.."/70186/0423117d-8754-470c-873c-9b56bf3b9ae2.png",
    Acanthite = baseFolder.."/70186/e5246f30-14b3-4bf8-bfc1-9bf20a40ed6e.png",
    Garnierite = baseFolder.."/70186/b8a8443d-374d-4df2-b289-bfe69105a962.png",
    Petalite = baseFolder.."/70186/3ce3c407-4cfc-4c90-9258-c7af0a5bcf97.png",
    Cobaltite = baseFolder.."/70186/a1e3cbd0-c1c1-423d-abea-bf89fbbeb936.png",
    Cryolite = baseFolder.."/70186/54c5acf2-7c0c-4154-b38c-ffe22d349b80.png",
    Kolbeckite = baseFolder.."/70186/c4d32953-9bfb-4586-974d-de0a2ea0f954.png",
    GoldNugget = baseFolder.."/70186/335baaee-7651-4b90-9e5a-290950ed0f5a.png",
    Columbite = baseFolder.."/70186/891cbe02-e34c-4473-9cac-65ba67075e47.png",
    Illmenite = baseFolder.."/70186/13f64ee1-4c8d-40bb-9eff-605e6e6e681f.png",
    Rhodonite = baseFolder.."/70186/a2f5af65-de9e-4b49-a752-a47a42eca4e9.png",
    Vanadinite = baseFolder.."/70186/34804219-fcbb-4900-9358-77688ef535fe.png",
    WarpCell = "resources_generated/elementsLib/fuel-parts/fuel-part-warp-cells_001/icons/env_fuel-part-warp-cells_001_icon.png",
    KergonX1Fuel = "resources_generated/iconsLib/materialslib/Kergon.png",
    KergonX2Fuel = "resources_generated/iconsLib/materialslib/Kergon.png",
    KergonX3Fuel = "resources_generated/iconsLib/materialslib/Kergon.png",
    KergonX4Fuel = "resources_generated/iconsLib/materialslib/Kergon.png",
    NitronFuel = "resources_generated/iconsLib/materialslib/Nitron.png",
    TerritoryScanner = "resources_generated/iconsLib/elementslib/territoryscanner.png",
    TerritoryUnit = "assets.prod.novaquark.com/70186/dd5105d3-e139-4d4c-8472-a476dea5801d.png",
    IronScrap = "resources_generated/elementsLib/scraps/scrap-t1_001/icons/scrap-t1_001_icon.png",
    AluminiumScrap = "resources_generated/elementsLib/scraps/scrap-t1_001/icons/scrap-t1_001_icon.png",
    CarbonScrap = "resources_generated/elementsLib/scraps/scrap-t1_001/icons/scrap-t1_001_icon.png",
    SiliconScrap = "resources_generated/elementsLib/scraps/scrap-t1_001/icons/scrap-t1_001_icon.png",
    SodiumScrap = "resources_generated/elementsLib/scraps/scrap-t2_001/icons/scrap-t2_001_icon.png",
    CopperScrap = "resources_generated/elementsLib/scraps/scrap-t2_001/icons/scrap-t2_001_icon.png",
    CalciumScrap = "resources_generated/elementsLib/scraps/scrap-t2_001/icons/scrap-t2_001_icon.png",
    ChromiumScrap = "resources_generated/elementsLib/scraps/scrap-t2_001/icons/scrap-t2_001_icon.png",
    SulfurScrap = "resources_generated/elementsLib/scraps/scrap-t3_001/icons/scrap-t3_001_icon.png",
    LithiumScrap = "resources_generated/elementsLib/scraps/scrap-t3_001/icons/scrap-t3_001_icon.png",
    NickelScrap = "resources_generated/elementsLib/scraps/scrap-t3_001/icons/scrap-t3_001_icon.png",
    SilverScrap = "resources_generated/elementsLib/scraps/scrap-t3_001/icons/scrap-t3_001_icon.png",
    CobaltScrap = "resources_generated/elementsLib/scraps/scrap-t4_001/icons/scrap-t4_001_icon.png",
    ScandiumScrap = "resources_generated/elementsLib/scraps/scrap-t4_001/icons/scrap-t4_001_icon.png",
    FlourineScrap = "resources_generated/elementsLib/scraps/scrap-t4_001/icons/scrap-t4_001_icon.png",
    GoldScrap = "resources_generated/elementsLib/scraps/scrap-t4_001/icons/scrap-t4_001_icon.png",
    Scannerresult = "assets.prod.novaquark.com/76470/95f99200-eccc-4424-b575-7c9b9a051ac2.png"
}

local mt = {__index = function () return "none" end}
setmetatable(itemImages, mt)
mt = nil

function unitCollapse (value, baseUnit)
    local u = ""
    local uv = { "k", "M", "G" }
    local uvi = 0
    if baseUnit == "kg" then
        uv = {"t", "kt", "Mt" }
        u = ""
    elseif baseUnit == "L" then
        u = "L"
    elseif baseUnit == "N" then
        u = "N"
    end
    local m = value
    if m > 1000 then 
        m = m / 1000
        uvi = 1
    end 
    if m > 1000 then 
        m = m / 1000
        uvi = 2
    end
    if m > 1000 then 
        m = m / 1000
        uvi = 3
    end
    if uvi > 0 then
        return string.format("%.2f", m).." "..uv[uvi]..u
    end
    return string.format("%.2f", m).." "..u
end

function prettyStr (x)
    if type(x) == 'table' then
        local elems = {}
        for k, v in pairs(x) do
            table.insert(elems, string.format('%s = %s', prettyStr(k), prettyStr(v)))
        end
        return string.format('{%s}', table.concat(elems, ', '))
    else
        return tostring(x)
    end
end

function getFont (font, size)
    local k = font .. '_' .. tostring(size)
    if not fontCache[k] then fontCache[k] = loadFont(font, size) end
    return fontCache[k]
end

function drawBackground ()
    local lcstartx = 0
    local ccstartx = rx/6
    local rcstartx = ((rx/6) *5) + 10
    local starty = ry/6
    local colWidth = (rx/6) - 10
    local cenWidth = (rx/6) *4
    local colHeight = (ry/6) *4

    local columns = { 
        { ccstartx, starty, cenWidth, colHeight },
        { lcstartx, starty, colWidth, colHeight },
        { rcstartx, starty, colWidth, colHeight },
    }

    for index, column in ipairs(columns) do
        setNextStrokeWidth(bglayer, 1)
        setNextStrokeColor(bglayer, 0, 1, 1, 1)
        setNextFillColor(bglayer, 0, 0, 0, 0)
        addBox(bglayer, column[1], column[2], column[3], column[4] )
    end
end

function drawBackgroundImage (cols)
    if cols and cols ~= "noC" then
        local cenImage = loadImage(bgPlanetImg)
        if isImageLoaded(cenImage) then
            setNextFillColor(bglayer, 1, 1, 1, .33)
            addImage(bglayer, cenImage, (rx/2) - (ry/6), ry/3, ry/3, ry/3)
        end
    end
    if cols and cols ~= "noSCs" then
        local colImage = loadImage(itemImages["TerritoryScanner"])
        if isImageLoaded(colImage) then
            setNextFillColor(bglayer, 1, 1, 1, .33)
            addImage(bglayer, colImage, -5, ry/3, ry/3, ry/3)
            setNextFillColor(bglayer, 1, 1, 1, .33)
            addImage(bglayer, colImage, (((rx/6)*5)), ry/3, ry/3, ry/3)
        end
    end
    if cols and cols ~= "noT" then
        local font = getFont('Play-Bold', 32)
        local sx, sy = getTextBounds(font, bgtext)
        sx, sy = sx + 32, sy + 16
        local x0 = rx/2 - sx/2
        local y0 = ry/2 - sy/2
        local x1 = x0 + sx
        local y1 = y0 + sy
        setNextFillColor(bglayer, 1, 1, 1, 0.33)
        addText(bglayer, font, bgtext, x0, y0)
    end
end

function drawTitle ()
    local font = getFont("Play-Bold", 40)
    setNextTextAlign(bglayer, AlignH_Center, AlignV_Middle)
    addText(bglayer, font, title, rx/2, 40)
end

function drawCursor ()
    if cx < 0 then return end
    setNextFillColor(curlayer, 1, 1, 1, 1)
    addBox(curlayer, cx - 5, cy - 5, 10, 10)
end

function noIcon (startx, starty, square)
    local font = getFont("Play", 16)
    local sx, sy = 0, 0
    r, g, b = 0.5, 0, 0
    setNextStrokeWidth(itemLayer, 5)
    setNextStrokeColor(itemLayer, r, g, b, 1)
    addLine(itemLayer, startx + 5, starty + 5, startx + square - 5, starty + square - 5)
    setNextStrokeWidth(itemLayer, 5)
    setNextStrokeColor(itemLayer, r, g, b, 1)
    addLine(itemLayer, startx + 5, starty + square - 5, startx + square - 5, starty + 5)
    sx, sy = getTextBounds(font, "No")
    addText(itemLayer, font, "No", startx + (square/2) - (sx/2), starty + (square/3) - (sy/2))
    sx, sy = getTextBounds(font, "Icon")
    addText(itemLayer, font, "Icon", startx + (square/2) - (sx/2), starty + ((square/3)*2) - (sy/2))
    sx, sy = getTextBounds(font, "Available")
    addText(itemLayer, font, "Available", startx + (square/2) - (sx/2), starty + square - (sy/2))
end

function refreshButton ()
    local text = "Refresh"
    local font = getFont('Play-Bold', 18)
    local sx, sy = getTextBounds(font, text)
    sx, sy = sx + 24, sy + 12
    local x0 = sx
    local y0 = sy
    local x1 = x0 + sx
    local y1 = y0 + sy
    local r, g, b = 0.3, 0.7, 1.0
    if cx >= x0 and cx <= x1 and cy >= y0 and cy <= y1 then
        r, g, b = 1.0, 0.0, 0.4
        if click then
            Polling = true
            Items = false
            Ship = false
            RotDeg = 0
        end
    end
    setNextShadow(itemLayer, 64, r, g, b, 0.3)
    setNextFillColor(itemLayer, 0.1, 0.1, 0.1, 1)
    setNextStrokeColor(itemLayer, r, g, b, 1)
    setNextStrokeWidth(itemLayer, 2)
    addBoxRounded(itemLayer, x0, y0, sx, sy, 4)
    setNextFillColor(itemLayer, 1, 1, 1, 1)
    setNextTextAlign(itemLayer, AlignH_Center, AlignV_Middle)
    addText(itemLayer, font, text, x0+(sx/2), y0+(sy/2))
end

function pageButtons (pages)
    local text = { "Previous", "Next" }
    for i,v in ipairs(text) do
        local font = getFont('Play-Bold', 24)
        local sx, sy = getTextBounds(font, text[i])
        sx, sy = sx + 24, sy + 12
        local x0 = ((rx/6)+((rx/6)*4*(i-1))) - sx/2
        local y0 = ((ry/3)*2) - sy/2
        local x1 = x0 + sx
        local y1 = y0 + sy
        local r, g, b = 0.3, 0.7, 1.0
        if cx >= x0 and cx <= x1 and cy >= y0 and cy <= y1 then
            r, g, b = 1.0, 0.0, 0.4
            if click then
                if text[i] == "Previous" then
                    if PageView == 1 then
                        PageView = pages
                    else
                        PageView = PageView-1
                    end
                elseif text[i] == "Next" then
                    if PageView == pages then
                        PageView = 1
                    else
                        PageView = PageView+1
                    end
                end
            end
        end
        setNextShadow(itemLayer, 64, r, g, b, 0.3)
        setNextFillColor(itemLayer, 0.1, 0.1, 0.1, 1)
        setNextStrokeColor(itemLayer, r, g, b, 1)
        setNextStrokeWidth(itemLayer, 2)
        addBoxRounded(itemLayer, x0, y0, sx, sy, 4)
        setNextFillColor(itemLayer, 1, 1, 1, 1)
        setNextTextAlign(itemLayer, AlignH_Center, AlignV_Middle)
        addText(itemLayer, font, text[i], x0+(sx/2), y0+(sy/2))
    end
end

function itemPages (items)
    local startx = rx/6
    local starty = ry/6
    local square = (ry/6)-5
    local padding = 5
    if not PageView then
        PageView = 1
    end
    local column = 4
    local row = 3
    local pages = 1
    local indexStart = 1
    if (column*row) < #items then
        pages = math.ceil(#items/(column*row))
    end
    if pages > 1 then
        indexStart = (PageView-1)*(column*row)+1
        itemBox(items, indexStart, column, row, startx, starty, square, padding)
        pageButtons(pages)
    else
        itemBox(items, indexStart, column, row, startx, starty, square, padding)
    end
end

function itemBox(items, indexStart, column, row, startx, starty, square, padding)
    local index = indexStart
    for r=1,row do
        for c=1,column do
            if index <= #items then
                local item = items[index]
                local name = item["image"]
                local boxSize = square+padding
                local centeredx = rx/2-(boxSize*(column/2))
                local colStart = centeredx+padding+((c-1)*boxSize)
                local rowStart = starty+padding+((r-1)*boxSize)
                local r, g, b = 0, 1, 1
                if cx >= colStart and cx <= colStart + square and cy >= rowStart and cy <= rowStart + square then
                    r, g, b = 1, 0, 0
                    if click then
                        itemDisplay = item
                        return
                    end
                end
                setNextStrokeWidth(itemLayer, 1)
                setNextStrokeColor(itemLayer, r, g, b, 1)
                setNextFillColor(itemLayer, 0, 0, 0, 0)
                addBox(itemLayer, colStart, rowStart, square, square)
                if itemImages[name] ~= "none" then
                    local image = loadImage(itemImages[name])
                    if isImageLoaded(image) then
                        addImage(itemLayer, image, colStart, rowStart, square, square)
                    end
                else
                   noIcon(colStart, rowStart, square)
                end
                index = index+1
            else
                return
            end
        end
    end
end

function backButton ()
    local startx = rx/2
    local starty = (ry/3) * 2
    local text = "Back"
    local font = getFont('Play-Bold', 24)
    local sx, sy = getTextBounds(font, text)
    sx, sy = sx + 32, sy + 16
    local x0 = startx - sx/2
    local y0 = starty - sy/2
    local x1 = x0 + sx
    local y1 = y0 + sy
    local r, g, b = 0.3, 0.7, 1.0
    if cx >= x0 and cx <= x1 and cy >= y0 and cy <= y1 then
        r, g, b = 1.0, 0.0, 0.4
        if click then
            itemDisplay = nil
        end
    end
    setNextShadow(itemLayer, 64, r, g, b, 0.3)
    setNextFillColor(itemLayer, 0.1, 0.1, 0.1, 1)
    setNextStrokeColor(itemLayer, r, g, b, 1)
    setNextStrokeWidth(itemLayer, 2)
    addBoxRounded(itemLayer, startx - sx/2, starty - sy/2, sx, sy, 4)
    setNextFillColor(itemLayer, 1, 1, 1, 1)
    setNextTextAlign(itemLayer, AlignH_Center, AlignV_Middle)
    addText(itemLayer, font, text, startx, starty)
end

function displayItem (item, ship)
    local startx = rx/5
    local starty = ry/6 + 15
    local square = ry/5
    local pgBarStartX = startx + square + 5
    local pgBarStartY = starty + 36 + 18 +5
    local pgBarEnd = (startx * 2) - square - 5
    local unitv = item["unitv"]
    local unitm = item["unitm"]
    local qty = item["qty"]
    local itemVol = unitv * qty
    local itemMass = unitm * qty
    local maxMass = ship["maxth"] / ship["g"]
    local volpct = itemVol / ship["maxv"]
    local masspct = itemMass / maxMass
    local title = getFont("Play-Bold", 36)
    local subtitle = getFont("Play-Bold", 18)
    setNextStrokeWidth(itemLayer, 1)
    setNextStrokeColor(itemLayer, 0, 1, 1, 1)
    setNextFillColor(itemLayer, 0, 0, 0, 0)
    addBox(itemLayer, startx, starty, square, square)
    local image = itemImages[item["image"]]
    if image == "none" then
        noIcon(startx, starty, square)
    else
        local itemImage = loadImage(image)
        if isImageLoaded(itemImage) then
            addImage(itemLayer, itemImage, startx, starty , square, square)
        end
    end
    addText(itemLayer, title, item["name"], pgBarStartX, starty + 36)
    addText(itemLayer, subtitle, "Volume", pgBarStartX,starty + 36 + 18)

    local r, g, b = 0, 1, 0
    if volpct > 0.75 then
        r, g, b = 1, 0, 0
    elseif volpct > 0.5 then
        r, g, b = 1, 1, 0
    end
    setNextStrokeWidth(itemLayer, 1)
    setNextStrokeColor(itemLayer, r, g, b, 1)
    setNextFillColor(itemLayer, 0, 0, 0, 0)
    addBox(itemLayer, pgBarStartX, pgBarStartY, pgBarEnd , 10)
    setNextFillColor(itemLayer, r, g, b, 1)
    addBox(itemLayer, pgBarStartX, pgBarStartY, pgBarEnd * volpct , 10)
    addText(itemLayer, subtitle, "Mass", pgBarStartX,pgBarStartY + 28 )
    r, g, b = 0, 1, 0
    if masspct > 0.75 then
        r, g, b = 1, 0, 0
    elseif masspct > 0.5 then
        r, g, b = 1, 1, 0
    end
    setNextStrokeWidth(itemLayer, 1)
    setNextStrokeColor(itemLayer, r, g, b, 1)
    setNextFillColor(itemLayer, 0, 0, 0, 0)
    addBox(itemLayer, pgBarStartX, pgBarStartY+20+ 18, pgBarEnd , 10)
    setNextFillColor(itemLayer, r, g, b, 1)
    addBox(itemLayer, pgBarStartX, pgBarStartY+20+ 18, pgBarEnd * masspct , 10)
    addText(itemLayer, subtitle, "Current Qty: "..string.format("%.2f", qty), pgBarStartX, pgBarStartY+32+18+18)
    addText(itemLayer, subtitle, "Current Volume: "..unitCollapse(itemVol, "L"), pgBarStartX, pgBarStartY+32+18+18+18)
    addText(itemLayer, subtitle, "Current Mass: "..unitCollapse(itemMass, "kg"), pgBarStartX, pgBarStartY+32+36+18+18)
    backButton()
end

function shipMassStatus (ship)
    local startx = (rx/6) + 5

    local starty = (ry/6) * 4.5
    local font = getFont("Play", 18)
    local text = {}
    local currMass = ship["shipm"]
    local contVol = ship["contv"]
    local shipMaxVol = ship["maxv"]
    local maxThrust = ship["maxth"]
    local grav = ship["g"]
    local reqThrust = 0
    local maxMass = 0


    if grav > 0.1 then
        reqThrust = currMass * grav
        maxMass = maxThrust / grav
    end
    text = { "Current Mass: "..unitCollapse(currMass, "kg"),
        "Max Mass: "..unitCollapse(maxMass, "kg"),
        "Current Volume: "..unitCollapse(contVol, "L"),
        "Max Volume: "..unitCollapse(shipMaxVol, "L"),
        "Req Thrust: "..unitCollapse(reqThrust, "N"),
        "Max Thrust: "..unitCollapse(maxThrust, "N")
    }
    for i,v in ipairs(text) do
        local l = 0
        if i%2 == 0 then
            l = 1
        end
        addText(statusLayer, font, text[i], startx, starty + (l * 18))
        if i%2 == 0 then
            startx = startx + (((rx/6)*4)/3)
        end
    end
    local pgBarStartX = (rx/6) + 5
    local pgBarStartY = (ry/6) * 5.25
    local pgBarEnd = ((rx/6) * 4) - 5
    local volpct = contVol / shipMaxVol
    local masspct = currMass / maxMass
    local r, g, b = 0, 1, 0
    if volpct > 0.75 then
        r, g, b = 1, 0, 0
    elseif volpct > 0.5 then
        r, g, b = 1, 1, 0
    end
    setNextStrokeWidth(statusLayer, 1)
    setNextStrokeColor(statusLayer, r, g, b, 1)
    setNextFillColor(statusLayer, 0, 0, 0, 0)
    addBox(statusLayer, pgBarStartX, pgBarStartY, pgBarEnd , 10)
    setNextFillColor(statusLayer, r, g, b, 1)
    addBox(statusLayer, pgBarStartX, pgBarStartY, pgBarEnd * volpct , 10)
    setNextFillColor(statusLayer, r, g, b, 1)
    addText(statusLayer, font, "Volume", pgBarStartX - 100, pgBarStartY + 9)
    r, g, b = 0, 1, 0
    if masspct > 0.75 then
        r, g, b = 1, 0, 0
    elseif masspct > 0.5 then
        r, g, b = 1, 1, 0
    end
    setNextStrokeWidth(statusLayer, 1)
    setNextStrokeColor(statusLayer, r, g, b, 1)
    setNextFillColor(statusLayer, 0, 0, 0, 0)
    addBox(statusLayer, pgBarStartX, pgBarStartY+20, pgBarEnd , 10)
    setNextFillColor(statusLayer, r, g, b, 1)
    addBox(statusLayer, pgBarStartX, pgBarStartY+20, pgBarEnd * masspct , 10)
    setNextFillColor(statusLayer, r, g, b, 1)
    addText(statusLayer, font, "Mass", pgBarStartX - 100, pgBarStartY + 29)
end

function waitAnim ()
    if not RotDeg then
        RotDeg = 0
    end
    setNextRotationDegrees(bglayer, RotDeg)
    setNextStrokeWidth(bglayer, 1)
    setNextStrokeColor(bglayer, 0, 1, 1, 1)
    addLine(bglayer, rx/2, ry/3, rx/2, (ry/3)*2)
    setNextRotationDegrees(bglayer, RotDeg + 90)
    setNextStrokeWidth(bglayer, 1)
    setNextStrokeColor(bglayer, 0, 1, 1, 1)
    addLine(bglayer, rx/2, ry/3, rx/2 , (ry/3)*2)
    setNextStrokeWidth(bglayer, 1)
    setNextStrokeColor(bglayer, 0, 1, 1, 0.5)
    setNextFillColor(bglayer, 0, 0, 0, 0)
    addCircle(bglayer, rx/2, ry/2, ry/6)
    if RotDeg < 90 then
        RotDeg = RotDeg + 10
    else
        RotDeg = 0
    end
end

function closedContainer (error)
    drawBackground()
    drawTitle()
    drawBackgroundImage("noT")
    local font = getFont('Play-Bold', 32)
    local text = ""
    if error == "full" then
        logMessage("full")
        text = "Container is Full"
    elseif error == "noData" then
        logMessage("noData")
        text = "Waiting for data..."
        waitAnim()
    end
    local sx, sy = getTextBounds(font, text)
    sx, sy = sx + 32, sy + 16
    local x0 = rx/2 - sx/2
    local y0 = ry/2 - sy/2
    local x1 = x0 + sx
    local y1 = y0 + sy
    setNextFillColor(bglayer, 1, 0, 0, 1)
    addText(bglayer, font, text, x0, y0) 
end

function processData (data)
    if data == "DONE" then
        Items = {}
        Items = NextItems
        NextItems = {}
        Polling = false
    elseif type(data) == "table" then
        if data["name"] == "ship" then
            Ship = {}
            Ship = data
        else
            if data["id"] then
                if not NextItems then
                    NextItems = {}
                end
                local index = data["id"]
                data["image"] = string.gsub(data["name"], "%s+", "")
                data["image"] = string.gsub(data["image"], "-", "")
                table.insert(NextItems, index, data)
            end
        end
    end
    sendAck()
    data = nil -- Garbage collection
    DataStop = true
end

function sendAck ()
    setOutput("ACK")
    logMessage("ACK sent.")
end

function main ()
    drawBackground()
    drawTitle()
    if itemDisplay then
        drawBackgroundImage("noT")
        displayItem(itemDisplay, Ship)
    else
        drawBackgroundImage("allC")
        itemPages(Items)
    end
    shipMassStatus(Ship)
    drawCursor()
end

local jData = json.decode(getInput(), 1, nil) or {}

if not Init then
    if not LastTime then
        LastTime = getDeltaTime()
    end
    LastTime = LastTime+getDeltaTime()
     if LastTime >= 1 then
         Init = true
     end
end

if jData ~= {} and Init then
    if Polling then
        if not DataStop then
            processData(jData)
            logMessage(prettyStr(jData))
        else
            logMessage("Data Stop")
            if not LastTime then
                LastTime = getDeltaTime()
            end
            local newTime = getDeltaTime()
            LastTime = LastTime+newTime
            if LastTime >= pollRate then
                DataStop = false
                LastTime = false
            end
        end
    else
        refreshButton()
    end
end
if Items and Ship then
    main()
else
    Polling = true
    closedContainer("noData")
end

requestAnimationFrame(5)