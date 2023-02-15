function GetRaModData()
    local mod_data = getPlayer():getModData()

    if mod_data.RA == nil then
        mod_data.RA = {
            is_zed = false,
        }
    end

    return mod_data.RA
end