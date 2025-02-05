local algo = require("a-tools.algo")
local graphic = require("texture-wrapper").code
local api = require("api")

return function(object)
    local term = object.canvas.term_object
    local draw_map = {}
    local x_map = {}
    local visited = api.tables.createNDarray(2)
    if object.filled then
        local points = algo.get_elipse_points(
            object.positioning.radius,
            math.ceil(object.positioning.radius-object.positioning.radius/3)+0.5,
            object.positioning.x,
            object.positioning.y,
            true
        )
        for k,v in ipairs(points) do
            if visited[v.x][v.y] ~= true then
                draw_map[v.y] = (draw_map[v.y] or "").."*"
                x_map[v.y] = math.min(x_map[v.y] or math.huge,v.x)
                visited[v.x][v.y] = true
            end
        end
        for y,data in pairs(draw_map) do
            term.setCursorPos(x_map[y],y)
            term.blit(
                data:gsub("%*",object.symbol),
                data:gsub("%*",graphic.to_blit[object.fg]),
                data:gsub("%*",graphic.to_blit[object.bg])
            )
        end
    else
        local points = algo.get_elipse_points(
            object.positioning.radius,
            math.ceil(object.positioning.radius-object.positioning.radius/3)+0.5,
            object.positioning.x,
            object.positioning.y
        )
        for k,v in pairs(points) do
            term.setCursorPos(v.x,v.y)
            term.blit(
                object.symbol,
                graphic.to_blit[object.fg],
                graphic.to_blit[object.bg]
            )
        end
    end
end