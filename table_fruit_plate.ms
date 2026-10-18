-- Simple low-poly table with a plate of fruits (same style as the monitor and chair)
-- BROWN  = table top + legs
-- WHITE  = plate
-- Fruits = apple (red), orange, banana (yellow), 3 grapes (purple)
-- Run: Scripting > Run Script...   then File > Save As .max
-- Press F4 in the viewport to see Edged Faces.

(
    -- ===== Parameters (cm) =====
    local tx = 160.0         -- table position X (moved to the side so it doesn't overlap the monitor/chair)
    local ty = 0.0           -- table position Y
    local topW = 100.0       -- table top width (X)
    local topD = 60.0        -- table top depth (Y)
    local topT = 4.0         -- table top thickness
    local tableH = 72.0      -- height of the top surface
    local legS = 5.0         -- leg thickness
    local legInset = 4.0     -- leg distance from the edges

    fn finish o col nm =
    (
        o.name = nm
        o.wirecolor = col
        o.material = StandardMaterial diffuse:col name:(nm + "_mat")
        convertToPoly o
        o
    )

    local topC    = color 170 115 60
    local legC    = color 125 80 40
    local plateC  = color 240 240 240
    local appleC  = color 225 40 40
    local orangeC = color 255 150 20
    local bananaC = color 250 220 40
    local grapeC  = color 130 50 170

    local parts = #()

    -- ===== Table =====
    local tabTop = Box width:topW length:topD height:topT widthsegs:1 lengthsegs:1 heightsegs:1 pos:[tx, ty, tableH - topT]
    finish tabTop topC "Table_Top"
    append parts tabTop

    local legH = tableH - topT
    local lx = topW / 2.0 - legInset - legS / 2.0
    local ly = topD / 2.0 - legInset - legS / 2.0
    local i = 0
    for sx in #(-1, 1) do
    (
        for sy in #(-1, 1) do
        (
            i += 1
            local lg = Box width:legS length:legS height:legH pos:[tx + sx * lx, ty + sy * ly, 0]
            finish lg legC ("Table_Leg_" + (i as string))
            append parts lg
        )
    )

    -- ===== Plate (low-poly dish) =====
    local plateH = 2.5
    local plate = Cone radius1:9 radius2:14 height:plateH sides:16 heightsegs:1 capsegs:1 pos:[tx, ty, tableH]
    finish plate plateC "Plate"
    append parts plate

    local zTop = tableH + plateH - 0.5    -- fruits sit slightly inside the dish

    -- ===== Fruits =====
    local apple = Sphere radius:4.5 segments:8 pos:[tx - 4.0, ty + 2.0, zTop + 3.6]
    finish apple appleC "Fruit_Apple"
    append parts apple

    local orng = Sphere radius:4.5 segments:8 pos:[tx + 5.0, ty - 3.0, zTop + 3.6]
    finish orng orangeC "Fruit_Orange"
    append parts orng

    -- banana: bent capsule lying on the plate
    local ban = Capsule radius:1.8 height:15 sides:6 heightsegs:4
    addModifier ban (Bend angle:70 bendAxis:2)
    finish ban bananaC "Fruit_Banana"
    ban.rotation = (eulerAngles 90 0 15)
    ban.pos = [tx - 9.0, ty - 9.0, zTop + 1.8]
    append parts ban

    -- grapes: three small spheres
    local gp = #([tx + 8.0, ty + 6.0], [tx + 11.0, ty + 6.5], [tx + 9.5, ty + 9.5])
    for k = 1 to 3 do
    (
        local g = Sphere radius:2.2 segments:6 pos:[gp[k].x, gp[k].y, zTop + 1.8]
        finish g grapeC ("Fruit_Grape_" + (k as string))
        append parts g
    )

    -- ===== Group =====
    local grp = group parts name:"Table_With_Fruits"
    grp.pivot = [tx, ty, 0]
    select grp
    max zoomext sel all
    format "Table with fruit plate created.\n"
)
