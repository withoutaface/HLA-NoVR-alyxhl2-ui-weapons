-- Mod support, by Hypercycle

-- TODO implement addon list ids checking?
local addonMaps = {
	-- Extra-Ordinary Value
	"youreawake",
	"seweroutskirts",
	"facilityredux",
	"helloagain",
	-- Levitation
	"01_intro",
	"02_notimelikenow",
	"03_metrodynamo",
	"04_hehungers",
	"05_pleasantville",
	"06_digdeep",
	"07_sectorx",
	"08_burningquestions",
	-- GoldenEye Alyx 007
	"goldeneye64_damver051",
	"goldeneye64dampart2_ver052_master",
	-- Single good maps
	"mc1_higgue",
	"belomorskaya",
	"red_dust",
	-- Misc
	"back_alley",
	"e3_ship",
}

local function IsValueInList(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function ModSupport_IsAddonMap(mapName)
    if IsValueInList(addonMaps, mapName) then
		return true
	else
		return false
	end
end