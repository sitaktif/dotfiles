local naughty = require("naughty")

local sita_battery = {}
function sita_battery.batteryInfo(widget, adapter)
    spacer = " "
    local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")
    local fcur = io.open("/sys/class/power_supply/"..adapter.."/energy_now")
    local fcap = io.open("/sys/class/power_supply/"..adapter.."/energy_full")
    local sta, cur, cap, battery
    if fsta and fcur and fcap then
        sta = fsta:read()
        cur = fcur:read()
        cap = fcap:read()
        battery = math.floor(cur * 100 / cap)
    else
        sta = "Unknown"
        battery = 0
    end
    if sta:match("Unknown") then
        dir = "?"
    elseif sta:match("Charging") then
        dir = "<span color='green'>^</span>"
    elseif sta:match("Discharging") then
        dir = "<span color='orange'>v</span>"
        if tonumber(battery) > 25 and tonumber(battery) < 75 then
            battery = battery
        elseif tonumber(battery) < 25 then
            if tonumber(battery) < 10 then
                naughty.notify({ title      = "Battery Warning"
                               , text       = "Battery low!"..spacer..battery.."%"..spacer.."left!"
                               , timeout    = 5
                               , position   = "top_right"
                               , fg         = beautiful.fg_focus
                               , bg         = beautiful.bg_focus
                               })
            end
            battery = battery
        else
            battery = battery
        end
    else
        dir = "="
        battery = "A/C"
    end
    widget:set_markup(spacer.."Bat:"..spacer..dir..battery..dir..spacer)
    fcur:close()
    fcap:close()
    fsta:close()
end

return sita_battery
