-- Required Libraries
json = require('dkjson')
rslib = require('rslib')

-- Don't turn this on unless you know that your chat will get spammed.
DEBUG = true

-- global variables
MaxVolume = 1150000 --export: (Default 1150000) Put the maximum volume of your containers in L. 1 kL = 1000 L
DataStart = false
SortByMass = false --export: (Default false) Sorts by Volume or Mass.

-- planet reference table
local function Atlas()
    return {
        [0] = {
            [0] = {
                GM = 0,
                bodyId = 0,
                center = {
                    x = 0,
                    y = 0,
                    z = 0
                },
                name = 'Space',
                planetarySystemId = 0,
                radius = 0,
                hasAtmosphere = false,
                gravity = 0,
                noAtmosphericDensityAltitude = 0,
                surfaceMaxAltitude = 0
            },
            [2] = {
                name = "Alioth",
                description = "Alioth is the planet selected by the arkship for landfall; it is a typical goldilocks planet where humanity may rebuild in the coming decades. The arkship geological survey reports mountainous regions alongside deep seas and lush forests. This is where it all starts.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9401,
                atmosphericEngineMaxAltitude = 5580,
                biosphere = "Forest",
                classification = "Mesoplanet",
                bodyId = 2,
                GM = 157470826617,
                gravity = 1.0082568597356114,
                fullAtmosphericDensityMaxAltitude = -10,
                habitability = "High",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 6272,
                numSatellites = 2,
                positionFromSun = 2,
                center = {
                    x = -8,
                    y = -8,
                    z = -126303
                },
                radius = 126067.8984375,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 3410,
                surfaceArea = 199718780928,
                surfaceAverageAltitude = 200,
                surfaceMaxAltitude = 1100,
                surfaceMinAltitude = -330,
                systemZone = "High",
                territories = 259472,
                type = "Planet",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [21] = {
                name = "Alioth Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 21,
                GM = 2118960000,
                gravity = 0.24006116402380084,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 457933,
                    y = -1509011,
                    z = 115524
                },
                radius = 30000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 11309733888,
                surfaceAverageAltitude = 140,
                surfaceMaxAltitude = 200,
                surfaceMinAltitude = 10,
                systemZone = nil,
                territories = 14522,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [22] = {
                name = "Alioth Moon 4",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 22,
                GM = 2165833514,
                gravity = 0.2427018259886451,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -1692694,
                    y = 729681,
                    z = -411464
                },
                radius = 30330,
                safeAreaEdgeAltitude = 500000,
                size = "L",
                spaceEngineMinAltitude = 0,
                surfaceArea = 11559916544,
                surfaceAverageAltitude = -15,
                surfaceMaxAltitude = -5,
                surfaceMinAltitude = -50,
                systemZone = nil,
                territories = 14522,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [5] = {
                name = "Feli",
                description = "Feli is easily identified by its massive and deep crater. Outside of the crater, the arkship geological survey reports a fairly bland and uniform planet, it also cannot explain the existence of the crater. Feli is particular for having an extremely small atmosphere, allowing life to develop in the deeper areas of its crater but limiting it drastically on the actual surface.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.5488,
                atmosphericEngineMaxAltitude = 66725,
                biosphere = "Barren",
                classification = "Mesoplanet",
                bodyId = 5,
                GM = 16951680000,
                gravity = 0.4801223280476017,
                fullAtmosphericDensityMaxAltitude = 30,
                habitability = "Low",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 78500,
                numSatellites = 1,
                positionFromSun = 5,
                center = {
                    x = -43534464,
                    y = 22565536,
                    z = -48934464
                },
                radius = 41800,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 42800,
                surfaceArea = 21956466688,
                surfaceAverageAltitude = 18300,
                surfaceMaxAltitude = 18500,
                surfaceMinAltitude = 46,
                systemZone = "Low",
                territories = 27002,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [50] = {
                name = "Feli Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 50,
                GM = 499917600,
                gravity = 0.11202853997062348,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -43902841.78,
                    y = 22261034.7,
                    z = -48862386
                },
                radius = 14000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2463008768,
                surfaceAverageAltitude = 800,
                surfaceMaxAltitude = 900,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3002,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [120] = {
                name = "Ion",
                description = "Ion is nothing more than an oversized ice cube frozen through and through. It is a largely inhospitable planet due to its extremely low temperatures. The arkship geological survey reports extremely rough mountainous terrain with little habitable land.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9522,
                atmosphericEngineMaxAltitude = 10480,
                biosphere = "Ice",
                classification = "Hypopsychroplanet",
                bodyId = 120,
                GM = 7135606629,
                gravity = 0.36009174603570127,
                fullAtmosphericDensityMaxAltitude = -30,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 17700,
                numSatellites = 2,
                positionFromSun = 12,
                center = {
                    x = 2865536.7,
                    y = -99034464,
                    z = -934462.02
                },
                radius = 44950,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 6410,
                surfaceArea = 25390383104,
                surfaceAverageAltitude = 500,
                surfaceMaxAltitude = 1300,
                surfaceMinAltitude = 250,
                systemZone = "Average",
                territories = 32672,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [121] = {
                name = "Ion Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 121,
                GM = 106830900,
                gravity = 0.08802242599860607,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 2472916.8,
                    y = -99133747,
                    z = -1133582.8
                },
                radius = 11000,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1520530944,
                surfaceAverageAltitude = 100,
                surfaceMaxAltitude = 200,
                surfaceMinAltitude = 3,
                systemZone = nil,
                territories = 1922,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [122] = {
                name = "Ion Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 122,
                GM = 176580000,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 2995424.5,
                    y = -99275010,
                    z = -1378480.7
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = -1900,
                surfaceMaxAltitude = -1400,
                surfaceMinAltitude = -2100,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [9] = {
                name = "Jago",
                description = "Jago is a water planet. The large majority of the planet&apos;s surface is covered by large oceans dotted by small areas of landmass across the planet. The arkship geological survey reports deep seas across the majority of the planet with sub 15 percent coverage of solid ground.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9835,
                atmosphericEngineMaxAltitude = 9695,
                biosphere = "Water",
                classification = "Mesoplanet",
                bodyId = 9,
                GM = 18606274330,
                gravity = 0.5041284298678057,
                fullAtmosphericDensityMaxAltitude = -90,
                habitability = "Very High",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 10900,
                numSatellites = 0,
                positionFromSun = 9,
                center = {
                    x = -94134462,
                    y = 12765534,
                    z = -3634464
                },
                radius = 61590,
                safeAreaEdgeAltitude = 500000,
                size = "XL",
                spaceEngineMinAltitude = 5900,
                surfaceArea = 47668367360,
                surfaceAverageAltitude = 0,
                surfaceMaxAltitude = 1200,
                surfaceMinAltitude = -500,
                systemZone = "Very High",
                territories = 60752,
                type = "Planet",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [100] = {
                name = "Lacobus",
                description = "Lacobus is an ice planet that also features large bodies of water. The arkship geological survey reports deep oceans alongside a frozen and rough mountainous environment. Lacobus seems to feature regional geothermal activity allowing for the presence of water on the surface.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.7571,
                atmosphericEngineMaxAltitude = 11120,
                biosphere = "Ice",
                classification = "Psychroplanet",
                bodyId = 100,
                GM = 13975172474,
                gravity = 0.45611622622739767,
                fullAtmosphericDensityMaxAltitude = -20,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 12510,
                numSatellites = 3,
                positionFromSun = 10,
                center = {
                    x = 98865536,
                    y = -13534464,
                    z = -934461.99
                },
                radius = 55650,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 6790,
                surfaceArea = 38917074944,
                surfaceAverageAltitude = 800,
                surfaceMaxAltitude = 1660,
                surfaceMinAltitude = 250,
                systemZone = "Average",
                territories = 50432,
                type = "Planet",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [102] = {
                name = "Lacobus Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 102,
                GM = 444981600,
                gravity = 0.14403669598391783,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 99180968,
                    y = -13783862,
                    z = -926156.4
                },
                radius = 18000,
                safeAreaEdgeAltitude = 500000,
                size = "XL",
                spaceEngineMinAltitude = 0,
                surfaceArea = 4071504128,
                surfaceAverageAltitude = 150,
                surfaceMaxAltitude = 300,
                surfaceMinAltitude = 10,
                systemZone = nil,
                territories = 5072,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [103] = {
                name = "Lacobus Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 103,
                GM = 211503600,
                gravity = 0.11202853997062348,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 99250052,
                    y = -13629215,
                    z = -1059341.4
                },
                radius = 14000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2463008768,
                surfaceAverageAltitude = -1380,
                surfaceMaxAltitude = -1280,
                surfaceMinAltitude = -1880,
                systemZone = nil,
                territories = 3002,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [101] = {
                name = "Lacobus Moon 3",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 101,
                GM = 264870000,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 98905288.17,
                    y = -13950921.1,
                    z = -647589.53
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "L",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = 500,
                surfaceMaxAltitude = 820,
                surfaceMinAltitude = 3,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [1] = {
                name = "Madis",
                description = "Madis is a barren wasteland of a rock; it sits closest to the sun and temperatures reach extreme highs during the day. The arkship geological survey reports long rocky valleys intermittently separated by small ravines.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.8629,
                atmosphericEngineMaxAltitude = 7165,
                biosphere = "Barren",
                classification = "hyperthermoplanet",
                bodyId = 1,
                GM = 6930729684,
                gravity = 0.36009174603570127,
                fullAtmosphericDensityMaxAltitude = 220,
                habitability = "Low",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 8050,
                numSatellites = 3,
                positionFromSun = 1,
                center = {
                    x = 17465536,
                    y = 22665536,
                    z = -34464
                },
                radius = 44300,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 4480,
                surfaceArea = 24661377024,
                surfaceAverageAltitude = 750,
                surfaceMaxAltitude = 850,
                surfaceMinAltitude = 670,
                systemZone = "Low",
                territories = 30722,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [10] = {
                name = "Madis Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 10,
                GM = 78480000,
                gravity = 0.08002039003323584,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 17448118.224,
                    y = 22966846.286,
                    z = 143078.82
                },
                radius = 10000,
                safeAreaEdgeAltitude = 500000,
                size = "XL",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1256637056,
                surfaceAverageAltitude = 210,
                surfaceMaxAltitude = 420,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 1472,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [11] = {
                name = "Madis Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 11,
                GM = 237402000,
                gravity = 0.09602446196397631,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 17194626,
                    y = 22243633.88,
                    z = -214962.81
                },
                radius = 12000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1809557376,
                surfaceAverageAltitude = -700,
                surfaceMaxAltitude = 300,
                surfaceMinAltitude = -2900,
                systemZone = nil,
                territories = 1922,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [12] = {
                name = "Madis Moon 3",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 12,
                GM = 265046609,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 17520614,
                    y = 22184730,
                    z = -309989.99
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = 700,
                surfaceMaxAltitude = 1100,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [26] = {
                name = "Sanctuary",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9666,
                atmosphericEngineMaxAltitude = 6935,
                biosphere = "",
                classification = "",
                bodyId = 26,
                GM = 68234043600,
                gravity = 1.0000000427743831,
                fullAtmosphericDensityMaxAltitude = -30,
                habitability = "",
                hasAtmosphere = true,
                isSanctuary = true,
                noAtmosphericDensityAltitude = 7800,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -1404835,
                    y = 562655,
                    z = -285074
                },
                radius = 83400,
                safeAreaEdgeAltitude = 0,
                size = "L",
                spaceEngineMinAltitude = 4230,
                surfaceArea = 87406149632,
                surfaceAverageAltitude = 80,
                surfaceMaxAltitude = 500,
                surfaceMinAltitude = -60,
                systemZone = nil,
                territories = 111632,
                type = "",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [6] = {
                name = "Sicari",
                description = "Sicari is a typical desert planet; it has survived for millenniums and will continue to endure. While not the most habitable of environments it remains a relatively untouched and livable planet of the Alioth sector. The arkship geological survey reports large flatlands alongside steep plateaus.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.897,
                atmosphericEngineMaxAltitude = 7725,
                biosphere = "Desert",
                classification = "Mesoplanet",
                bodyId = 6,
                GM = 10502547741,
                gravity = 0.4081039739797361,
                fullAtmosphericDensityMaxAltitude = -625,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 8770,
                numSatellites = 0,
                positionFromSun = 6,
                center = {
                    x = 52765536,
                    y = 27165538,
                    z = 52065535
                },
                radius = 51100,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 4480,
                surfaceArea = 32813432832,
                surfaceAverageAltitude = 130,
                surfaceMaxAltitude = 220,
                surfaceMinAltitude = 50,
                systemZone = "Average",
                territories = 41072,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [7] = {
                name = "Sinnen",
                description = "Sinnen is a an empty and rocky hell. With no atmosphere to speak of it is one of the least hospitable planets in the sector. The arkship geological survey reports mostly flatlands alongside deep ravines which look to have once been riverbeds. This planet simply looks to have dried up and died, likely from solar winds.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9226,
                atmosphericEngineMaxAltitude = 10335,
                biosphere = "Desert",
                classification = "Mesoplanet",
                bodyId = 7,
                GM = 13033380591,
                gravity = 0.4401121421448438,
                fullAtmosphericDensityMaxAltitude = -120,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 11620,
                numSatellites = 1,
                positionFromSun = 7,
                center = {
                    x = 58665538,
                    y = 29665535,
                    z = 58165535
                },
                radius = 54950,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 6270,
                surfaceArea = 37944188928,
                surfaceAverageAltitude = 317,
                surfaceMaxAltitude = 360,
                surfaceMinAltitude = 23,
                systemZone = "Average",
                territories = 48002,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [70] = {
                name = "Sinnen Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 70,
                GM = 396912600,
                gravity = 0.1360346539426409,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 58969616,
                    y = 29797945,
                    z = 57969449
                },
                radius = 17000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 3631681280,
                surfaceAverageAltitude = -2050,
                surfaceMaxAltitude = -1950,
                surfaceMinAltitude = -2150,
                systemZone = nil,
                territories = 4322,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [110] = {
                name = "Symeon",
                description = "Symeon is an ice planet mysteriously split at the equator by a band of solid desert. Exactly how this phenomenon is possible is unclear but some sort of weather anomaly may be responsible. The arkship geological survey reports a fairly diverse mix of flat-lands alongside mountainous formations.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9559,
                atmosphericEngineMaxAltitude = 6920,
                biosphere = "Ice, Desert",
                classification = "Hybrid",
                bodyId = 110,
                GM = 9204742375,
                gravity = 0.3920998898971822,
                fullAtmosphericDensityMaxAltitude = -30,
                habitability = "High",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 7800,
                numSatellites = 0,
                positionFromSun = 11,
                center = {
                    x = 14165536,
                    y = -85634465,
                    z = -934464.3
                },
                radius = 49050,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 4230,
                surfaceArea = 30233462784,
                surfaceAverageAltitude = 39,
                surfaceMaxAltitude = 450,
                surfaceMinAltitude = 126,
                systemZone = "High",
                territories = 38882,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [4] = {
                name = "Talemai",
                description = "Talemai is a planet in the final stages of an Ice Age. It seems likely that the planet was thrown into tumult by a cataclysmic volcanic event which resulted in its current state. The arkship geological survey reports large mountainous regions across the entire planet.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.8776,
                atmosphericEngineMaxAltitude = 9685,
                biosphere = "Barren",
                classification = "Psychroplanet",
                bodyId = 4,
                GM = 14893847582,
                gravity = 0.4641182439650478,
                fullAtmosphericDensityMaxAltitude = -78,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 10890,
                numSatellites = 3,
                positionFromSun = 4,
                center = {
                    x = -13234464,
                    y = 55765536,
                    z = 465536
                },
                radius = 57500,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 5890,
                surfaceArea = 41547563008,
                surfaceAverageAltitude = 580,
                surfaceMaxAltitude = 610,
                surfaceMinAltitude = 520,
                systemZone = "Average",
                territories = 52922,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [42] = {
                name = "Talemai Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 42,
                GM = 264870000,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -13058408,
                    y = 55781856,
                    z = 740177.76
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = 720,
                surfaceMaxAltitude = 850,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [40] = {
                name = "Talemai Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 40,
                GM = 141264000,
                gravity = 0.09602446196397631,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -13503090,
                    y = 55594325,
                    z = 769838.64
                },
                radius = 12000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1809557376,
                surfaceAverageAltitude = 250,
                surfaceMaxAltitude = 450,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 1922,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [41] = {
                name = "Talemai Moon 3",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 41,
                GM = 106830900,
                gravity = 0.08802242599860607,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -12800515,
                    y = 55700259,
                    z = 325207.84
                },
                radius = 11000,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1520530944,
                surfaceAverageAltitude = 190,
                surfaceMaxAltitude = 400,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 1922,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [8] = {
                name = "Teoma",
                description = "[REDACTED] The arkship geological survey [REDACTED]. This planet should not be here.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.7834,
                atmosphericEngineMaxAltitude = 5580,
                biosphere = "Forest",
                classification = "Mesoplanet",
                bodyId = 8,
                GM = 18477723600,
                gravity = 0.48812434578525177,
                fullAtmosphericDensityMaxAltitude = 15,
                habitability = "High",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 6280,
                numSatellites = 0,
                positionFromSun = 8,
                center = {
                    x = 80865538,
                    y = 54665536,
                    z = -934463.94
                },
                radius = 62000,
                safeAreaEdgeAltitude = 500000,
                size = "L",
                spaceEngineMinAltitude = 3420,
                surfaceArea = 48305131520,
                surfaceAverageAltitude = 700,
                surfaceMaxAltitude = 1100,
                surfaceMinAltitude = -200,
                systemZone = "High",
                territories = 60752,
                type = "Planet",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [3] = {
                name = "Thades",
                description = "Thades is a scorched desert planet. Perhaps it was once teaming with life but now all that remains is ash and dust. The arkship geological survey reports a rocky mountainous planet bisected by a massive unnatural ravine; something happened to this planet.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.03552,
                atmosphericEngineMaxAltitude = 32180,
                biosphere = "Desert",
                classification = "Thermoplanet",
                bodyId = 3,
                GM = 11776905000,
                gravity = 0.49612641213015557,
                fullAtmosphericDensityMaxAltitude = 150,
                habitability = "Low",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 32800,
                numSatellites = 2,
                positionFromSun = 3,
                center = {
                    x = 29165536,
                    y = 10865536,
                    z = 65536
                },
                radius = 49000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 21400,
                surfaceArea = 30171856896,
                surfaceAverageAltitude = 13640,
                surfaceMaxAltitude = 13690,
                surfaceMinAltitude = 370,
                systemZone = "Low",
                territories = 38882,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [30] = {
                name = "Thades Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 30,
                GM = 211564034,
                gravity = 0.11202853997062348,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 29214402,
                    y = 10907080.695,
                    z = 433858.2
                },
                radius = 14000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2463008768,
                surfaceAverageAltitude = 60,
                surfaceMaxAltitude = 300,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3002,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [31] = {
                name = "Thades Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 31,
                GM = 264870000,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 29404193,
                    y = 10432768,
                    z = 19554.131
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = 70,
                surfaceMaxAltitude = 350,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            }
        }
    }
end
local function PlanetRef()
    --[[                    START OF LOCAL IMPLEMENTATION DETAILS             ]]--
    -- Type checks
    local function isNumber(n)
        return type(n) == 'number'
    end
    local function isSNumber(n)
        return type(tonum(n)) == 'number'
    end
    local function isTable(t)
        return type(t) == 'table'
    end
    local function isString(s)
        return type(s) == 'string'
    end
    local function isVector(v)
        return isTable(v) and isNumber(v.x and v.y and v.z)
    end
    local function isMapPosition(m)
        return isTable(m) and isNumber(m.latitude and m.longitude and m.altitude and m.bodyId and m.systemId)
    end
    -- Constants
    local deg2rad = math.pi / 180
    local rad2deg = 180 / math.pi
    local epsilon = 1e-10
    local num = ' *([+-]?%d+%.?%d*e?[+-]?%d*)'
    local posPattern = '::pos{' .. num .. ',' .. num .. ',' .. num .. ',' .. num .. ',' .. num .. '}'
    -- Utilities
    local utils = require('cpml.utils')
    local vec3 = require('cpml.vec3')
    local function formatNumber(n)
        local result = string.gsub(string.reverse(stringf('%.4f', n)), '^0*%.?', '')
        return result == '' and '0' or string.reverse(result)
    end
    local function formatValue(obj)
        if isVector(obj) then
            return stringf('{x=%.3f,y=%.3f,z=%.3f}', obj.x, obj.y, obj.z)
        end
        if isTable(obj) and not getmetatable(obj) then
            local list = {}
            local nxt = next(obj)
            if type(nxt) == 'nil' or nxt == 1 then -- assume this is an array
                list = obj
            else
                for k, v in pairs(obj) do
                    local value = formatValue(v)
                    if type(k) == 'number' then
                        table.insert(list, stringf('[%s]=%s', k, value))
                    else
                        table.insert(list, stringf('%s=%s', k, value))
                    end
                end
            end
            return stringf('{%s}', table.concat(list, ','))
        end
        if isString(obj) then
            return stringf("'%s'", obj:gsub("'", [[\']]))
        end
        return tostring(obj)
    end
    -- CLASSES
    -- BodyParameters: Attributes of planetary bodies (planets and moons)
    local BodyParameters = {}
    BodyParameters.__index = BodyParameters
    BodyParameters.__tostring = function(obj, indent)
        local keys = {}
        for k in pairs(obj) do
            table.insert(keys, k)
        end
        table.sort(keys)
        local list = {}
        for _, k in ipairs(keys) do
            local value = formatValue(obj[k])
            if type(k) == 'number' then
                table.insert(list, stringf('[%s]=%s', k, value))
            else
                table.insert(list, stringf('%s=%s', k, value))
            end
        end
        if indent then
            return stringf('%s%s', indent, table.concat(list, ',\n' .. indent))
        end
        return stringf('{%s}', table.concat(list, ','))
    end
    BodyParameters.__eq = function(lhs, rhs)
        return lhs.planetarySystemId == rhs.planetarySystemId and lhs.bodyId == rhs.bodyId and
                float_eq(lhs.radius, rhs.radius) and float_eq(lhs.center.x, rhs.center.x) and
                float_eq(lhs.center.y, rhs.center.y) and float_eq(lhs.center.z, rhs.center.z) and
                float_eq(lhs.GM, rhs.GM)
    end
    local function mkBodyParameters(systemId, bodyId, radius, worldCoordinates, GM)
        -- 'worldCoordinates' can be either table or vec3
        assert(isSNumber(systemId), 'Argument 1 (planetarySystemId) must be a number:' .. type(systemId))
        assert(isSNumber(bodyId), 'Argument 2 (bodyId) must be a number:' .. type(bodyId))
        assert(isSNumber(radius), 'Argument 3 (radius) must be a number:' .. type(radius))
        assert(isTable(worldCoordinates),
            'Argument 4 (worldCoordinates) must be a array or vec3.' .. type(worldCoordinates))
        assert(isSNumber(GM), 'Argument 5 (GM) must be a number:' .. type(GM))
        return setmetatable({
            planetarySystemId = tonum(systemId),
            bodyId = tonum(bodyId),
            radius = tonum(radius),
            center = vec3(worldCoordinates),
            GM = tonum(GM)
        }, BodyParameters)
    end
    -- MapPosition: Geographical coordinates of a point on a planetary body.
    local MapPosition = {}
    MapPosition.__index = MapPosition
    MapPosition.__tostring = function(p)
        return stringf('::pos{%d,%d,%s,%s,%s}', p.systemId, p.bodyId, formatNumber(p.latitude * rad2deg),
                formatNumber(p.longitude * rad2deg), formatNumber(p.altitude))
    end
    MapPosition.__eq = function(lhs, rhs)
        return lhs.bodyId == rhs.bodyId and lhs.systemId == rhs.systemId and
                float_eq(lhs.latitude, rhs.latitude) and float_eq(lhs.altitude, rhs.altitude) and
                (float_eq(lhs.longitude, rhs.longitude) or float_eq(lhs.latitude, math.pi / 2) or
                    float_eq(lhs.latitude, -math.pi / 2))
    end
    -- latitude and longitude are in degrees while altitude is in meters
    local function mkMapPosition(overload, bodyId, latitude, longitude, altitude)
        local systemId = overload -- Id or '::pos{...}' string
        
        if isString(overload) and not longitude and not altitude and not bodyId and not latitude then
            systemId, bodyId, latitude, longitude, altitude = stringmatch(overload, posPattern)
            assert(systemId, 'Argument 1 (position string) is malformed.')
        else
            assert(isSNumber(systemId), 'Argument 1 (systemId) must be a number:' .. type(systemId))
            assert(isSNumber(bodyId), 'Argument 2 (bodyId) must be a number:' .. type(bodyId))
            assert(isSNumber(latitude), 'Argument 3 (latitude) must be in degrees:' .. type(latitude))
            assert(isSNumber(longitude), 'Argument 4 (longitude) must be in degrees:' .. type(longitude))
            assert(isSNumber(altitude), 'Argument 5 (altitude) must be in meters:' .. type(altitude))
        end
        systemId = tonum(systemId)
        bodyId = tonum(bodyId)
        latitude = tonum(latitude)
        longitude = tonum(longitude)
        altitude = tonum(altitude)
        if bodyId == 0 then -- this is a hack to represent points in space
            return setmetatable({
                latitude = latitude,
                longitude = longitude,
                altitude = altitude,
                bodyId = bodyId,
                systemId = systemId
            }, MapPosition)
        end
        return setmetatable({
            latitude = deg2rad * uclamp(latitude, -90, 90),
            longitude = deg2rad * (longitude % 360),
            altitude = altitude,
            bodyId = bodyId,
            systemId = systemId
        }, MapPosition)
    end
    -- PlanetarySystem - map body IDs to BodyParameters
    local PlanetarySystem = {}
    PlanetarySystem.__index = PlanetarySystem
    PlanetarySystem.__tostring = function(obj, indent)
        local sep = indent and (indent .. '  ')
        local bdylist = {}
        local keys = {}
        for k in pairs(obj) do
            table.insert(keys, k)
        end
        table.sort(keys)
        for _, bi in ipairs(keys) do
            bdy = obj[bi]
            local bdys = BodyParameters.__tostring(bdy, sep)
            if indent then
                table.insert(bdylist, stringf('[%s]={\n%s\n%s}', bi, bdys, indent))
            else
                table.insert(bdylist, stringf('  [%s]=%s', bi, bdys))
            end
        end
        if indent then
            return stringf('\n%s%s%s', indent, table.concat(bdylist, ',\n' .. indent), indent)
        end
        return stringf('{\n%s\n}', table.concat(bdylist, ',\n'))
    end
    local function mkPlanetarySystem(referenceTable)
        local atlas = {}
        local pid
        for _, v in pairs(referenceTable) do
            local id = v.planetarySystemId
            if type(id) ~= 'number' then
                error('Invalid planetary system ID: ' .. tostring(id))
            elseif pid and id ~= pid then
                error('Mistringmatch planetary system IDs: ' .. id .. ' and ' .. pid)
            end
            local bid = v.bodyId
            if type(bid) ~= 'number' then
                error('Invalid body ID: ' .. tostring(bid))
            elseif atlas[bid] then
                error('Duplicate body ID: ' .. tostring(bid))
            end
            setmetatable(v.center, getmetatable(vec3.unit_x))
            atlas[bid] = setmetatable(v, BodyParameters)
            pid = id
        end
        return setmetatable(atlas, PlanetarySystem)
    end
    -- PlanetaryReference - map planetary system ID to PlanetarySystem
    PlanetaryReference = {}
    local function mkPlanetaryReference(referenceTable)
        return setmetatable({
            galaxyAtlas = referenceTable or {}
        }, PlanetaryReference)
    end
    PlanetaryReference.__index = function(t, i)
        if type(i) == 'number' then
            local system = t.galaxyAtlas[i]
            return mkPlanetarySystem(system)
        end
        return rawget(PlanetaryReference, i)
    end
    PlanetaryReference.__pairs = function(obj)
        return function(t, k)
            local nk, nv = next(t, k)
            return nk, nv and mkPlanetarySystem(nv)
        end, obj.galaxyAtlas, nil
    end
    PlanetaryReference.__tostring = function(obj)
        local pslist = {}
        for _, ps in pairs(obj or {}) do
            local psi = ps:getPlanetarySystemId()
            local pss = PlanetarySystem.__tostring(ps, '    ')
            table.insert(pslist, stringf('  [%s]={%s\n  }', psi, pss))
        end
        return stringf('{\n%s\n}\n', table.concat(pslist, ',\n'))
    end
    PlanetaryReference.BodyParameters = mkBodyParameters
    PlanetaryReference.MapPosition = mkMapPosition
    PlanetaryReference.PlanetarySystem = mkPlanetarySystem
    function PlanetaryReference.createBodyParameters(planetarySystemId, bodyId, surfaceArea, aPosition,
        verticalAtPosition, altitudeAtPosition, gravityAtPosition)
        assert(isSNumber(planetarySystemId),
            'Argument 1 (planetarySystemId) must be a number:' .. type(planetarySystemId))
        assert(isSNumber(bodyId), 'Argument 2 (bodyId) must be a number:' .. type(bodyId))
        assert(isSNumber(surfaceArea), 'Argument 3 (surfaceArea) must be a number:' .. type(surfaceArea))
        assert(isTable(aPosition), 'Argument 4 (aPosition) must be an array or vec3:' .. type(aPosition))
        assert(isTable(verticalAtPosition),
            'Argument 5 (verticalAtPosition) must be an array or vec3:' .. type(verticalAtPosition))
        assert(isSNumber(altitudeAtPosition),
            'Argument 6 (altitude) must be in meters:' .. type(altitudeAtPosition))
        assert(isSNumber(gravityAtPosition),
            'Argument 7 (gravityAtPosition) must be number:' .. type(gravityAtPosition))
        local radius = msqrt(surfaceArea / 4 / math.pi)
        local distance = radius + altitudeAtPosition
        local center = vec3(aPosition) + distance * vec3(verticalAtPosition)
        local GM = gravityAtPosition * distance * distance
        return mkBodyParameters(planetarySystemId, bodyId, radius, center, GM)
    end

    PlanetaryReference.isMapPosition = isMapPosition
    function PlanetaryReference:getPlanetarySystem(overload)
        -- if galaxyAtlas then
        if i == nil then i = 0 end
        if nv == nil then nv = 0 end
        local planetarySystemId = overload
        if isMapPosition(overload) then
            planetarySystemId = overload.systemId
        end
        if type(planetarySystemId) == 'number' then
            local system = self.galaxyAtlas[i]
            if system then
                if getmetatable(nv) ~= PlanetarySystem then
                    system = mkPlanetarySystem(system)
                end
                return system
            end
        end
        -- end
        -- return nil
    end

    function PlanetarySystem:sizeCalculator(body)
        return 1.05*body.radius
    end
     
    function PlanetarySystem:castIntersections(origin, direction, sizeCalculator, bodyIds, collection, sorted)
        local candidates = {}
        local selfie = collection or self
        -- Since we don't use bodyIds anywhere, got rid of them
        -- It was two tables doing basically the same thing
        
        -- Changed this to insert the body to candidates
        for _, body in pairs(selfie) do
            table.insert(candidates, body)
        end
        -- Added this because, your knownContacts list is already sorted, can skip an expensive re-sort
        if not sorted then
            table.sort(candidates, function (b1, b2)
                return (b1.center - origin):len() < (b2.center - origin):len()
            end)
        end
        local dir = direction:normalize()
        -- Use the body directly from the for loop instead of getting it with i
        for _, body in ipairs(candidates) do
            local c_oV3 = body.center - origin
            -- Changed to the new method.  IDK if this is how self works but I think so
            local radius = self:sizeCalculator(body)
            local dot = c_oV3:dot(dir)
            local desc = dot ^ 2 - (c_oV3:len2() - radius ^ 2)
            if desc >= 0 then
                local root = msqrt(desc)
                local farSide = dot + root
                local nearSide = dot - root
                if nearSide > 0 then
                    return body, farSide, nearSide
                elseif farSide > 0 then
                    return body, farSide, nil
                end
            end
        end
        return nil, nil, nil
    end

    function PlanetarySystem:closestBody(coordinates)
        assert(type(coordinates) == 'table', 'Invalid coordinates.')
        local minDistance2, body
        local coord = vec3(coordinates)
        for _, params in pairs(self) do
            local distance2 = (params.center - coord):len2()
            if (not body or distance2 < minDistance2) and params.name ~= "Space" then -- Never return space.  
                body = params
                minDistance2 = distance2
            end
        end
        return body
    end

    function PlanetarySystem:convertToBodyIdAndWorldCoordinates(overload)
        local mapPosition = overload
        if isString(overload) then
            mapPosition = mkMapPosition(overload)
        end
        if mapPosition.bodyId == 0 then
            return 0, vec3(mapPosition.latitude, mapPosition.longitude, mapPosition.altitude)
        end
        local params = self:getBodyParameters(mapPosition)
        if params then
            return mapPosition.bodyId, params:convertToWorldCoordinates(mapPosition)
        end
    end

    function PlanetarySystem:getBodyParameters(overload)
        local bodyId = overload
        if isMapPosition(overload) then
            bodyId = overload.bodyId
        end
        assert(isSNumber(bodyId), 'Argument 1 (bodyId) must be a number:' .. type(bodyId))
        return self[bodyId]
    end

    function PlanetarySystem:getPlanetarySystemId()
        local _, v = next(self)
        return v and v.planetarySystemId
    end

    function BodyParameters:convertToMapPosition(worldCoordinates)
        assert(isTable(worldCoordinates),
            'Argument 1 (worldCoordinates) must be an array or vec3:' .. type(worldCoordinates))
        local worldVec = vec3(worldCoordinates)
        if self.bodyId == 0 then
            return setmetatable({
                latitude = worldVec.x,
                longitude = worldVec.y,
                altitude = worldVec.z,
                bodyId = 0,
                systemId = self.planetarySystemId
            }, MapPosition)
        end
        local coords = worldVec - self.center
        local distance = coords:len()
        local altitude = distance - self.radius
        local latitude = 0
        local longitude = 0
        if not float_eq(distance, 0) then
            local phi = atan(coords.y, coords.x)
            longitude = phi >= 0 and phi or (2 * math.pi + phi)
            latitude = math.pi / 2 - math.acos(coords.z / distance)
        end
        return setmetatable({
            latitude = latitude,
            longitude = longitude,
            altitude = altitude,
            bodyId = self.bodyId,
            systemId = self.planetarySystemId
        }, MapPosition)
    end

    function BodyParameters:convertToWorldCoordinates(overload)
        local mapPosition = isString(overload) and mkMapPosition(overload) or overload
        if mapPosition.bodyId == 0 then -- support deep space map position
            return vec3(mapPosition.latitude, mapPosition.longitude, mapPosition.altitude)
        end
        assert(isMapPosition(mapPosition), 'Argument 1 (mapPosition) is not an instance of "MapPosition".')
        assert(mapPosition.systemId == self.planetarySystemId,
            'Argument 1 (mapPosition) has a different planetary system ID.')
        assert(mapPosition.bodyId == self.bodyId, 'Argument 1 (mapPosition) has a different planetary body ID.')
        local xproj = math.cos(mapPosition.latitude)
        return self.center + (self.radius + mapPosition.altitude) *
                vec3(xproj * math.cos(mapPosition.longitude), xproj * math.sin(mapPosition.longitude),
                    math.sin(mapPosition.latitude))
    end

    function BodyParameters:getAltitude(worldCoordinates)
        return (vec3(worldCoordinates) - self.center):len() - self.radius
    end

    function BodyParameters:getDistance(worldCoordinates)
        return (vec3(worldCoordinates) - self.center):len()
    end

    function BodyParameters:getGravity(worldCoordinates)
        local radial = self.center - vec3(worldCoordinates) -- directed towards body
        local len2 = radial:len2()
        return (self.GM / len2) * radial / msqrt(len2)
    end
    -- end of module
    return setmetatable(PlanetaryReference, {
        __call = function(_, ...)
            return mkPlanetaryReference(...)
        end
    })
end

PlanetaryReference = PlanetRef()
galaxyReference = PlanetaryReference(Atlas())
Helios = galaxyReference[0]

-- find my hubs
local hublist = { hub1, hub2, hub3, hub4, hub5, hub6, hub7, hub8 }
Hubs = {}
ItemsList = {}
ItemsPage = 1

for i,v in ipairs(hublist) do
    if hublist[i] then
        local t = { eId = hublist[i].getId(), storeAcq = false, hub = hublist[i] }
        table.insert(Hubs, t)
    end
end

-- base functions to be used later
function round2 (num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
  end

function maxForceForward ()
    local axisCRefDirection = vec3(core.getConstructOrientationForward())
    local longitudinalEngineTags = 'thrust analog longitudinal'
    local maxKPAlongAxis = core.getMaxKinematicsParametersAlongAxis(longitudinalEngineTags, {axisCRefDirection:unpack()})
    if unit.getAtmosphereDensity() == 0 then -- we are in space
        return maxKPAlongAxis[3]
    else
        return maxKPAlongAxis[1]
    end
end

function getKeysSortedByValue(tbl, sortFunction)
    local keys = {}
    for key in pairs(tbl) do
        table.insert(keys, key)
    end
    table.sort(keys, function(a, b)
        return sortFunction(tbl[a], tbl[b])
    end)
    return keys
end

function getItems (hubs)
    if DEBUG then system.print("Retreiving items from hubs") end
    local items = {}
    local itemList = {}
    for h, _ in ipairs(hubs) do
        local c = json.decode(hubs[h]["hub"].getItemsList())
        for i, _ in ipairs(c) do
            local item = c[i]
            local t = {}
            if itemList[item["name"]] ~= nil then
                local idx = itemList[item["name"]]
                items[idx]["qty"] = items[idx]["qty"] + round2(item["quantity"], 2)
            else
                itemList[item["name"]] = #items+1
                t["id"] = #items+1
                t["name"] = item["name"]
                t["qty"] = round2(item["quantity"], 2)
                t["unitv"] = round2(item["unitVolume"], 2)
                t["unitm"] = round2(item["unitMass"], 2)
            table.insert(items,t)
            end
        end
    end
    return items
end

function sortItems (items)
    if DEBUG then system.print("Sorting items from hubs") end
    local sorting = {}
    local sorted = {}
    for i,_ in ipairs(items) do
        local qty = items[i]["qty"]
        local unit = 0
        if SortByMass then
            unit = items[i]["unitm"]
        else 
            unit = items[i]["unitv"]
        end
        local calc = qty*unit
        table.insert(sorting, i, calc)
    end
    local sortedKeys = getKeysSortedByValue(sorting, function(a, b) return a > b end)
    sorting = nil
    for _, key in ipairs(sortedKeys) do
        local tt = items[key]
        tt["id"] = #sorted+1
        table.insert(sorted, tt)
    end
    return sorted
end

function createMessageList ()
    local t, core = {}, {}
    if Ship then
        core = getShip()
    elseif Land then
        core = getLand()
    elseif Space then
        core = getSpace()
    end
    if DEBUG then system.print("Processing messages") end
    table.insert(t, "START")
    local maxItems = ItemsPage*12
    local index = 1
    for i=(maxItems-11),maxItems do
        local tt = ItemsList[i]
        tt["id"] = index
        table.insert(t, tt)
        index = index+1
    end
    table.insert(t, core)
    table.insert(t, "DONE")

    return t
end

function sendOutput (message)
    if message ~= nil then
        message = json.encode(message)
        if DEBUG then system.print("Raw: "..rslib.toString(message)) end
        screen1.setScriptInput(message)
    end
end

function processOutput (messages)
    if DEBUG then system.print("Sending "..rslib.toString(messages[1])) end
    if messages[1] == "START" then
        sendOutput("START")
        table.remove(messages, 1)
        waitForAck()
        return messages
    elseif messages[1] == "DONE" then
        sendOutput("DONE")
        return false
    else
        sendOutput(messages[1])
        table.remove(messages, 1)
        waitForAck()
        return messages
    end
end

function waitForAck ()
    local ack = screen1.getScriptOutput() or false
    if ack and ack ~= "" then
        if DEBUG then system.print(ack.." received.") end
        if ack == "START" or ack == "ACKSYN" then
            DataStart = true
            ACK = true
            screen1.clearScriptOutput()
            ack = nil
        end
        if ack == "ACK" then
            sendOutput("SYN")
            screen1.clearScriptOutput()
            ack = nil
        end
        if ack == "RESET" or ack == "PREV" or ack == "NEXT" then
            DataStart = true
            MsgList = false
            screen1.clearScriptOutput()
            ack = nil
            if ack == "PREV" then
                if ItemsPage == 1 then
                    ItemsPage = TotalPages
                else
                    ItemsPage = ItemsPage - 1
                end
            elseif ack == "NEXT" then
                if ItemsPage == TotalPages then
                    ItemsPage = 1
                else
                    ItemsPage = ItemsPage + 1
                end
            end
        end
    end
end

function hubsItems (hubs)
    local m = 0
    local l = 0
    for i=1,#hubs do
        m = m + hubs[i]["hub"].getItemsMass()
        l = l + hubs[i]["hub"].getItemsVolume()
    end
    return m, l
end

function getShip ()
    local hM, hV = hubsItems(Hubs)
    local tM = core.getConstructMass()
    local g = core.g()
    local mt = maxForceForward()
    local t = {}
    local planet = Helios:closestBody(core.getConstructWorldPos())
    t["name"] = "ship"
    t["mass"] = round2(tM, 2)
    t["hmass"] = round2(hM, 2)
    t["hmaxvol"] = round2(MaxVolume, 2)
    t["hvol"] = round2(hV, 2)
    t["g"] = round2(g, 2)
    t["maxth"] = round2(mt, 2)
    t["pl"] = planet.name or "Helios"
    if DEBUG then system.print("Ship: "..rslib.toString(t)) end
    return t
end

function getLand ()
    local hM, hV = hubsItems(Hubs)
    local t = {}
    local planet = Helios:closestBody(core.getConstructWorldPos())
    t["name"] = "land"
    t["hmass"] = round2(hM, 2)
    t["hmaxvol"] = round2(MaxVolume, 2)
    t["hvol"] = round2(hV, 2)
    t["pl"] = planet.name or "Helios"
    if DEBUG then system.print("Land: "..rslib.toString(t)) end
    return t
end

function getSpace ()
    local hM, hV = hubsItems(Hubs)
    local tM = core.getConstructMass()
    local g = core.g()
    local t = {}
    local planet = Helios:closestBody(core.getConstructWorldPos())
    t["name"] = "space"
    t["mass"] = round2(tM, 2)
    t["hmass"] = round2(hM, 2)
    t["hmaxvol"] = round2(MaxVolume, 2)
    t["hvol"] = round2(hV, 2)
    t["g"] = round2(g, 5)
    t["pl"] = planet.name or "Helios"
    if DEBUG then system.print("Space: "..rslib.toString(t)) end
    return t
end

-- Initializations
if #Hubs == 0 or not core or not screen1 then
    system.print("Error: Elements not found. Please attach your screen, core, and/or hubs. Exiting.")
    unit.exit()
else
    screen1.clearScriptOutput()
    local coreData = json.decode(core.getData())
    if DEBUG then system.print("Core: "..rslib.toString(coreData)) end
    if coreData["name"]:find("Dynamic") then
        if DEBUG then system.print("Ship") end
        Ship = true
    elseif coreData["name"]:find("Static") then
        if DEBUG then system.print("Land") end
        Land = true
    elseif coreData["name"]:find("Space") then
        if DEBUG then system.print("Space") end
        Space = true
    end

    system.print("Acquiring Storage...")
    for i, v in ipairs(Hubs) do
        if DEBUG then system.print("Opening hub "..i) end
        v["hub"].acquireStorage()
    end

    -- Activate Timers
    StorageTimeout = 5
    unit.setTimer("storage",1)
end