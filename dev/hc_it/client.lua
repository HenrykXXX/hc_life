-- Define a list of interiors with their coordinates and optional IPLs
local interiors = {
    {
        name = "LA",
        x = 300.23,
        y = -998.55,
        z = -99.5,
        ipl = "apa_v_mp_h_01_a"
    },
    {
        name = "MB",
        x = -141.1987,
        y = -620.913,
        z = 168.8205,
        ipl = "ex_dt1_02_office_02b"
    },
    {
        name = "1",
        ipl = "gr_case10_bunkerclosed",
        x = -3058.714,
        y = 3329.19,
        z = 12.5844
    },
    -- Example of a Modern Apartment Interior
    {
        name = "2",
        ipl = "apa_v_mp_h_01_a",
        x = -786.8663,
        y = 315.7642,
        z = 217.6385
    },
    -- Example of a Mody Apartment Interior
    {
        name = "3",
        ipl = "apa_v_mp_h_02_a",
        x = -787.0749,
        y = 315.8198,
        z = 217.6386
    },
    -- Example of a Vibrant Apartment Interior
    {
        name = "4",
        ipl = "apa_v_mp_h_03_a",
        x = -786.6245,
        y = 315.6175,
        z = 217.6385
    },
    -- Example of a Sharp Apartment Interior
    {
        name = "5",
        ipl = "apa_v_mp_h_04_a",
        x = -787.0902,
        y = 315.7039,
        z = 217.6384
    },
    -- Example of a Monochrome Apartment Interior
    {
        name = "6",
        ipl = "apa_v_mp_h_05_a",
        x = -786.9887,
        y = 315.7393,
        z = 217.6386
    },
    -- Example of a Seductive Apartment Interior
    {
        name = "7",
        ipl = "apa_v_mp_h_06_a",
        x = -787.1423,
        y = 315.6943,
        z = 217.6386
    }
}

-- Function to load IPL if it's not already loaded
local function loadIPL(ipl)
    if ipl and not IsIplActive(ipl) then
        RequestIpl(ipl)
        while not IsIplActive(ipl) do
            Wait(100)
        end
    end
end

-- Teleport function
local function teleportToInterior(interior)
    loadIPL(interior.ipl)
    local ped = PlayerPedId()
    SetEntityCoords(ped, interior.x, interior.y, interior.z, 0, 0, 0, false)
end

-- Command to teleport, choose interior by name
RegisterCommand("tpi", function(source, args)
    local interiorName = table.concat(args, " ")
    for _, interior in ipairs(interiors) do
        if interior.name == interiorName then
            teleportToInterior(interior)
            return
        end
    end
    print("Interior not found.")
end, false)