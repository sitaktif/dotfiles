    local calendar = nil
    local offset = 0

    function remove_calendar()
        if calendar ~= nil then
            naughty.destroy(calendar)
            calendar = nil
            offset = 0
        end
    end

    function add_calendar(inc_offset)
        local save_offset = offset
        remove_calendar()
        offset = save_offset + inc_offset
        local datespec = os.date("*t")
        datespec = datespec.year * 12 + datespec.month - 1 + offset
        datespec = (datespec % 12 + 1) .. " " .. math.floor(datespec / 12)
        local cal = awful.util.pread("cal -m " .. datespec)
        cal = string.gsub(cal, "^%s*(.-)%s*$", "%1")
        calendar = naughty.notify({
            text = string.format('<span font_desc="%s">%s</span>', "monospace", os.date("%a, %d %B %Y") .. "\n" .. cal),
            timeout = 0, hover_timeout = 0.5,
            width = 160,
        })
    end

-- change clockbox for your clock widget (e.g. mytextclock)
    mytextclock:add_signal("mouse::enter", function()
      add_calendar(0)
    end)
    mytextclock:add_signal("mouse::leave", remove_calendar)
 
    mytextclock:buttons(awful.util.table.join(
        button({ }, 4, function()
            add_calendar(-1)
        end),
        button({ }, 5, function()
            add_calendar(1)
        end)
    ))
