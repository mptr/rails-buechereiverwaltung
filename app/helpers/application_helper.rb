module ApplicationHelper
    protected
        def td_date(date, time = true)
            tag.td(date&.strftime(time ? "%d.%m.%y %H:%M" : "%d.%m.%Y"), data: { sort: date })
        end
end
