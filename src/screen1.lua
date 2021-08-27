local title = "Inventory" -- export: Name your display.
local bgtext = "Medium Heavy Cargo Ship" -- export: Background text of your choice.
local pollRate = 0.066667 -- export: (Default: 0.066667) just a bit slower than the programming board to avoide duplicates.
local refresh = 10 -- export: (Default: 10) Num of Sec to perform refresh of data.

local rx, ry = getResolution()

fontCache = {} -- on refresh, the fontcache is invalid. This resets it.

local bglayer = createLayer()
local statusLayer = createLayer()
local itemLayer = createLayer()
local curlayer = createLayer()

local cx, cy = getCursor()
click = getCursorPressed()

local json = require('dkjson')
local rslib = require('rslib')

local DEBUG = false

if not ImageLibrary then
    local baseURI = "assets.prod.novaquark.com"
    local baseElem = "resources_generated/elementsLib"
    local baseIcon = "resources_generated/iconsLib"
    local mt = {__index = function () return "none" end}
    ImageLibrary = {
        Helios = baseURI.."/20368/0936494e-9b3d-4d60-9ea0-d93a3f3e29cd.png",
        Alioth = baseURI.."/20368/954f3adb-3369-4ea9-854d-a14606334152.png",
        AliothMoon1 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        AliothMoon4 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        Sanctuary = baseURI.."/20368/1a70dbff-24bc-44cb-905c-6d375d9613b8.png",
        Feli = baseURI.."/20368/da91066c-b3fd-41f4-8c01-26131b0a7841.png",
        FeliMoon1 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        Ion = baseURI.."/20368/91d10712-dc51-4b73-9fc0-6f07d96605a6.png",
        IonMoon1 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        IonMoon2 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        Jago = baseURI.."/20368/7fca8389-6b70-4198-a9c3-4875d15edb38.png",
        Lacobus = baseURI.."/20368/cb67a6a4-933c-4688-a637-898c89eb5b94.png",
        LacobusMoon1 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        LacobusMoon2 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        LacobusMoon3 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        Madis = baseURI.."/20368/46d57ef4-40ee-46ca-8cc5-5aee1504bbfe.png",
        MadisMoon1 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        MadisMoon2 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        MadisMoon3 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        Sicari = baseURI.."/20368/f6e2f801-075f-4ccd-ab94-46d060517e8f.png",
        Sinnen = baseURI.."/20368/54a99084-7c2b-461b-ab1f-ae4229b3b821.png",
        SinnenMoon1 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        Symeon = baseURI.."/20368/97940324-f194-4e03-808d-d71733ad545a.png",
        Talemai = baseURI.."/20368/f68628d9-3245-4d76-968e-ad9c63a19c19.png",
        TalemaiMoon1 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        TalemaiMoon2 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        TalemaiMoon3 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        Teoma = baseURI.."/20368/5a01dd8c-3cf8-4151-99a2-83b22f1e7249.png",
        Thades = baseURI.."/20368/59f997a2-bcca-45cf-aa35-26e0e41ed5c1.png",
        ThadesMoon1 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        ThadesMoon2 = baseURI.."/20368/f410e727-9d4d-4eab-98bf-22994b3fbdcf.png",
        Hematite = baseURI.."/70186/4ff8e9b7-5ed8-4b62-9b02-219219081efa.png",
        Bauxite = baseURI.."/70186/2a660dc9-9af6-4f4b-87d3-bba4defb1964.png",
        Coal = baseURI.."/70186/edc9f97e-7359-454e-8ba9-8f960037ae9b.png",
        Quartz = baseURI.."/70186/a8d1c39e-d3d3-4a75-bce1-348036588108.png",
        Natron = baseURI.."/70186/cec7c516-9f70-4b2b-9d60-6f9527ae36a8.png",
        Chromite = baseURI.."/70186/b7357f8d-43ce-4279-a7d3-75fb6fda4fcd.png",
        Limestone = baseURI.."/70186/dc16bf83-bc00-42b3-8f71-1683e8350efb.png",
        Malachite = baseURI.."/45824/36e5a9ca-c9f6-4e66-b2f4-fe64c9289224.png",
        Pyrite = baseURI.."/70186/0423117d-8754-470c-873c-9b56bf3b9ae2.png",
        Acanthite = baseURI.."/70186/e5246f30-14b3-4bf8-bfc1-9bf20a40ed6e.png",
        Garnierite = baseURI.."/70186/b8a8443d-374d-4df2-b289-bfe69105a962.png",
        Petalite = baseURI.."/70186/3ce3c407-4cfc-4c90-9258-c7af0a5bcf97.png",
        Cobaltite = baseURI.."/70186/a1e3cbd0-c1c1-423d-abea-bf89fbbeb936.png",
        Cryolite = baseURI.."/70186/54c5acf2-7c0c-4154-b38c-ffe22d349b80.png",
        Kolbeckite = baseURI.."/70186/c4d32953-9bfb-4586-974d-de0a2ea0f954.png",
        GoldNugget = baseURI.."/70186/335baaee-7651-4b90-9e5a-290950ed0f5a.png",
        Columbite = baseURI.."/70186/891cbe02-e34c-4473-9cac-65ba67075e47.png",
        Illmenite = baseURI.."/70186/13f64ee1-4c8d-40bb-9eff-605e6e6e681f.png",
        Rhodonite = baseURI.."/70186/a2f5af65-de9e-4b49-a752-a47a42eca4e9.png",
        Vanadinite = baseURI.."/70186/34804219-fcbb-4900-9358-77688ef535fe.png",
        WarpCell = baseElem.."/fuel-parts/fuel-part-warp-cells_001/icons/env_fuel-part-warp-cells_001_icon.png",
        KergonX1Fuel = baseIcon.."/materialslib/Kergon.png",
        KergonX2Fuel = baseIcon.."/materialslib/Kergon.png",
        KergonX3Fuel = baseIcon.."/materialslib/Kergon.png",
        KergonX4Fuel = baseIcon.."/materialslib/Kergon.png",
        NitronFuel = baseIcon.."/materialslib/Nitron.png",
        TerritoryScanner = baseIcon.."/elementslib/territoryscanner.png",
        DeepSpaceAsteroidTracker = baseElem.."/trackers/tracker-deep-space-asteroid_001_m/icons/env_tracker-deep-space-asteroid_001_m_icon.png",
        Package = baseElem.."/packages/package_001/icons/env_package_001_icon.png",
        TerritoryUnit = baseURI.."/70186/dd5105d3-e139-4d4c-8472-a476dea5801d.png",
        IronScrap = baseElem.."/scraps/scrap-t1_001/icons/scrap-t1_001_icon.png",
        AluminiumScrap = baseElem.."/scraps/scrap-t1_001/icons/scrap-t1_001_icon.png",
        CarbonScrap = baseElem.."/scraps/scrap-t1_001/icons/scrap-t1_001_icon.png",
        SiliconScrap = baseElem.."/scraps/scrap-t1_001/icons/scrap-t1_001_icon.png",
        SodiumScrap = baseElem.."/scraps/scrap-t2_001/icons/scrap-t2_001_icon.png",
        CopperScrap = baseElem.."/scraps/scrap-t2_001/icons/scrap-t2_001_icon.png",
        CalciumScrap = baseElem.."/scraps/scrap-t2_001/icons/scrap-t2_001_icon.png",
        ChromiumScrap = baseElem.."/scraps/scrap-t2_001/icons/scrap-t2_001_icon.png",
        SulfurScrap = baseElem.."/scraps/scrap-t3_001/icons/scrap-t3_001_icon.png",
        LithiumScrap = baseElem.."/scraps/scrap-t3_001/icons/scrap-t3_001_icon.png",
        NickelScrap = baseElem.."/scraps/scrap-t3_001/icons/scrap-t3_001_icon.png",
        SilverScrap = baseElem.."/scraps/scrap-t3_001/icons/scrap-t3_001_icon.png",
        CobaltScrap = baseElem.."/scraps/scrap-t4_001/icons/scrap-t4_001_icon.png",
        ScandiumScrap = baseElem.."/scraps/scrap-t4_001/icons/scrap-t4_001_icon.png",
        FlourineScrap = baseElem.."/scraps/scrap-t4_001/icons/scrap-t4_001_icon.png",
        GoldScrap = baseElem.."/scraps/scrap-t4_001/icons/scrap-t4_001_icon.png",
        Scannerresult = baseURI.."/76470/95f99200-eccc-4424-b575-7c9b9a051ac2.png"
    }
    setmetatable(ImageLibrary, mt)
end

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

function drawBackgroundImage (cols, bgImage)
    if cols and cols ~= "noC" then
        local imageName = ImageLibrary[bgImage]
        if imageName then
            local cenImage = loadImage(imageName)
            if isImageLoaded(cenImage) then
                setNextFillColor(bglayer, 1, 1, 1, .33)
                addImage(bglayer, cenImage, (rx/2) - (ry/6), ry/3, ry/3, ry/3)
            end
        end
    end
    if cols and cols ~= "noSCs" then
        local colImage = loadImage(ImageLibrary["TerritoryScanner"])
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
        local r, g, b = 0, 1, 1
        if cx >= x0 and cx <= x1 and cy >= y0 and cy <= y1 then
            r, g, b = 1.0, 0.0, 0.4
            if click then
                if text[i] == "Previous" then
                    DataReceived = false
                    setOutput("PREV")
                elseif text[i] == "Next" then
                    DataReceived = false
                    setOutput("NEXT")
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
        itemBox(items, indexStart, column, row, starty, square, padding)
        pageButtons(pages)
    else
        itemBox(items, indexStart, column, row, starty, square, padding)
    end
end

function itemBox(items, indexStart, column, row, starty, square, padding)
    local index = indexStart
    for r=1,row do
        for c=1,column do
            if index <= #items then
                local item = items[index]
                local name = item["image"]
                local boxSize = square+padding
                local centeredx = rx/2-(boxSize*(column/2))
                local colStart = centeredx-padding+((c-1)*boxSize)
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
                if ImageLibrary[name] ~= "none" then
                    local image = loadImage(ImageLibrary[name])
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

function displayItem (item, core)
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
    local maxMass = nil
    local masspct = nil
    local volpct = itemVol / core["hmaxvol"]
    local title = getFont("Play-Bold", 36)
    local subtitle = getFont("Play-Bold", 18)

    setNextStrokeWidth(itemLayer, 1)
    setNextStrokeColor(itemLayer, 0, 1, 1, 1)
    setNextFillColor(itemLayer, 0, 0, 0, 0)
    addBox(itemLayer, startx, starty, square, square)
    local image = ImageLibrary[item["image"]]
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
    if (core["name"] =="ship" or core["name"] =="space") and core["g"] > 0 then
        maxMass = core["maxth"] / core["g"]
        masspct = itemMass / maxMass
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
    end
    
    addText(itemLayer, subtitle, "Current Qty: "..string.format("%.2f", qty), pgBarStartX, pgBarStartY+32+18+18)
    addText(itemLayer, subtitle, "Current Volume: "..unitCollapse(itemVol, "L"), pgBarStartX, pgBarStartY+32+18+18+18)
    addText(itemLayer, subtitle, "Current Mass: "..unitCollapse(itemMass, "kg"), pgBarStartX, pgBarStartY+32+36+18+18)
    backButton()
end

function massStatus (core)
    local startx = 0
    local starty = (ry/6) * 4.5
    local font = getFont("Play", 18)
    local cMass = core["mass"]
    local mMass = nil
    local hVol = core["hvol"]
    local maxVol = core["hmaxvol"]
    local reqTh = nil
    local maxTh = nil
    local g = nil

    local text = {
        "Current Volume: "..unitCollapse(hVol, "L"),
        "Max Volume: "..unitCollapse(maxVol, "L")
    }

    if core["name"] == "ship" or core["name"] == "space" then
        g = core["g"]
        table.insert(text, "Current Mass: "..unitCollapse(cMass, "kg"))
        table.insert(text, 4, "Current Gravity: "..core["g"].."g")
    end

    if core["name"] == "ship" then
        maxTh = core["maxth"]
        g = core["g"]
        if g > 0.1 then
            reqTh = cMass * g
            mMass = maxTh / g
            table.remove(text, 4)
            table.insert(text, 4, "Max Mass: "..unitCollapse(mMass, "kg"))
            table.insert(text, 5, "Req Thrust: "..unitCollapse(reqTh, "N"))
            table.insert(text, 6, "Max Thrust: "..unitCollapse(maxTh, "N"))
        end
    end
    local textsize = {}
    for i=1,#text do
        local sx, _ = getTextBounds(font, text[i])
        table.insert(textsize, i, sx)
    end
    local lastsize = 0
    for i=1,#textsize do
        lastsize = math.max(lastsize, textsize[i])
    end
    local seg = math.floor(#text/2)
    startx = (rx/2)-(seg*(lastsize/2))-(seg*5)
    for i,v in ipairs(text) do
        local l = 0
        if i%2 == 0 then
            l = 1
        end
        addText(statusLayer, font, text[i], startx, starty + (l * 18))
        if i%2 == 0 then
            startx = startx+lastsize+10
        end
    end

    local pgBarStartX = (rx/6) + 5
    local pgBarStartY = (ry/6) * 5.25
    local pgBarEnd = ((rx/6) * 4) - 5
    local volpct = hVol / maxVol
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
    if core["name"] == "ship" and mMass ~= nil then
        local masspct = cMass / mMass
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
    drawBackgroundImage("noT", "Alioth")
    local font = getFont('Play-Bold', 32)
    local text = ""
    local r, g, b = 1, 1, 1
    if error == "full" then
        --logMessage("full")
        text = "Container is Full"
        r, g, b = 1, 0, 0
    elseif error == "noData" then
        --logMessage("noData")
        text = "No Data Found."
        r, g, b = 1, 0, 0
    elseif error == "polling" then
        --logMessage("polling")
        text = "Requesting data. Standby."
        r, g, b = 0, 1, 1
        waitAnim()
    elseif error == "startup" then
        --logMessage("startup")
        text = "Starting Up. Standby."
        waitAnim()
    end
    local sx, sy = getTextBounds(font, text)
    sx, sy = sx + 32, sy + 16
    local x0 = rx/2 - sx/2
    local y0 = ry/2 - sy/2
    setNextFillColor(bglayer, r, g, b, 1)
    addText(bglayer, font, text, x0, y0)
end

function pollData ()
    
    if not Waiting then
        local function sendAck (ack)
            setOutput(ack)
            logMessage(ack.." sent.")
        end
        local input = getInput()
        local jData = json.decode(input)
        logMessage("input Received: "..rslib.toString(input).." Type: "..type(input))
        logMessage("Json Received: "..rslib.toString(jData).." Type: "..type(jData))
        if RefreshTime and jData == "POLLING" then
            Startup = false
        elseif jData == "READY" then
            sendAck("ACK")
            Waiting = true
        elseif jData == "SYN" then
                sendAck("ACKSYN")
                logMessage("ACKSYN sent.")
                Waiting = true
        elseif not jData == "POLLING" then
            if type(jData) == "string" or type(jData) == "table" then
                if not processData(jData) then sendAck("RESET") end
            end
            sendAck("ACK")
            Waiting = true
        end
    else
        logMessage("Waiting...")
        if not LastTime then
            LastTime = getDeltaTime()
        end
        local newTime = getDeltaTime()
        LastTime = LastTime+newTime
        if LastTime >= pollRate*2 then
            Waiting = false
            LastTime = false
        end
    end
end

function processData (data)
    logMessage("Processing: "..rslib.toString(data))
    if data == "DONE" then
        if NewShip then Ship = NewShip; NewShip = false end
        if NewLand then Land = NewLand; NewLand = false end
        if NewSpace then Space = NewSpace; NewSpace = false end
        if NextItems then Items = NextItems; NextItems = false end
        DataReceived = true
    elseif type(data) == "table" then
        if data["name"] == "ship" then
            data["pl"] = string.gsub(string.gsub(data["pl"], "%s+", ""), "-", "")
            NewShip = data
        elseif data["name"] == "land" then
            data["pl"] = string.gsub(string.gsub(data["pl"], "%s+", ""), "-", "")
            NewLand = data
        elseif data["name"] == "space" then
            data["pl"] = string.gsub(string.gsub(data["pl"], "%s+", ""), "-", "")
            NewSpace = data
        else
            if data["id"] then
                if not NextItems then
                    NextItems = {}
                end
                local index = data["id"]
                local check = NextItems[index] or false
                local check2 = (#NextItems ~= index-1) or false
                if check or check2 then
                    NextItems = false
                    return false
                end
                data["image"] = string.gsub(string.gsub(data["name"], "%s+", ""), "-", "")
                table.insert(NextItems, index, data)
            end
        end
    end
    return true
end

-- render cost profiler 
if DEBUG then 
    local layer = createLayer() 
    local font = loadFont('Play-Bold', 14) 
    setNextFillColor(layer, 1, 1, 1, 1) 
    addText(layer, font, string.format('render cost : %d / %d',  getRenderCost(), getRenderCostMax()), 8, 16) 
end

function main ()
    local core = {}
    if Ship then core = Ship end
    if Land then core = Land end
    if Space then core = Space end
    drawBackground()
    drawTitle()
    if itemDisplay then
        drawBackgroundImage("noT", core["pl"])
        displayItem(itemDisplay, core)
    else
        drawBackgroundImage("allC", core["pl"])
        itemPages(Items)
    end
    massStatus(core)
end

if not Startup then
    if not Init then
        logMessage("-- --- --")
        closedContainer("startup")
        if not LastTime then
            LastTime = getDeltaTime()
        end
        LastTime = LastTime+getDeltaTime()
        if LastTime >= 3 then
            Init = true
            LastTime = false
            DataReceived = false
            setOutput("START")
            logMessage("Startup Complete.")
        end
    else
        if not Items and not (Ship or Land or Space) then
            pollData()
            closedContainer("polling")
        else
            Startup = true
        end
    end
end


if Startup then
    if not Items and not (Ship or Land or Space) then
        closedContainer("noData")
    else
        main()
    end
    if not DataReceived then
        pollData()
    else
        if not RefreshTime then
            RefreshTime = getDeltaTime()
        end
        RefreshTime = RefreshTime+getDeltaTime()
        if RefreshTime >= refresh then
            RefreshTime = false
            DataReceived = false
            setOutput("START")
            Waiting = true
        end
    end
end

drawCursor()
requestAnimationFrame(5)