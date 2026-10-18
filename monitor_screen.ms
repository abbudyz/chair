-- Monitor / screen with green stand (matches reference photos) - 3ds Max 2025
-- PINK   = front screen panel (wide, thin, 3x3 segments)
-- PURPLE = back housing slab
-- RED    = mounting plate on the back
-- GREEN  = stand: hexagonal neck, rounded head, flat base with two angled feet
-- Run: Scripting > Run Script...   then File > Save As .max
-- Tip: press F4 in the viewport to see Edged Faces like in the photos.

(
    -- ===== Parameters (cm) =====
    local scrW   = 120.0     -- screen width
    local scrH   = 65.0      -- screen height
    local scrZ   = 24.0      -- height of screen bottom above floor
    local frontT = 1.2       -- pink front panel thickness
    local backT  = 4.0       -- purple housing thickness

    fn finish o col nm =
    (
        o.name = nm
        o.wirecolor = col
        o.material = StandardMaterial diffuse:col name:(nm + "_mat")
        convertToPoly o
        o
    )

    local pinkC   = color 235 150 235
    local purpleC = color 150 90 190
    local redC    = color 235 30 85
    local greenC  = color 100 230 80

    -- ===== Screen (faces -Y, front panel at y<0, housing at y>0) =====
    local front = Box width:scrW length:frontT height:scrH widthsegs:3 lengthsegs:1 heightsegs:3 pos:[0, -frontT, scrZ]
    finish front pinkC "Screen_Front"

    local back = Box width:scrW length:backT height:scrH widthsegs:1 lengthsegs:1 heightsegs:1 pos:[0, 0, scrZ]
    finish back purpleC "Screen_Housing"

    -- ===== Red mounting plate on the back =====
    local plateW = 66.0
    local plateH = 30.0
    local plate = Box width:plateW length:1.0 height:plateH widthsegs:3 lengthsegs:1 heightsegs:1 pos:[0, backT, scrZ + (scrH - plateH) / 2.0]
    finish plate redC "Mount_Plate"

    -- ===== Green stand =====
    local sy = backT + 1.0 + 4.0   -- stand centre Y (head touches the red plate)
    -- base centre
    local baseC = Box width:20 length:16 height:2 pos:[0, sy, 0]
    finish baseC greenC "Stand_BaseCenter"

    -- two feet, angled forward like a V
    local footL = Box width:34 length:8 height:2 pos:[-27.0 * cos 20, sy - 27.0 * sin 20, 0]
    footL.rotation = (eulerAngles 0 0 20)
    finish footL greenC "Stand_FootL"

    local footR = Box width:34 length:8 height:2 pos:[27.0 * cos 20, sy - 27.0 * sin 20, 0]
    footR.rotation = (eulerAngles 0 0 -20)
    finish footR greenC "Stand_FootR"

    -- hexagonal neck
    local neck = Cylinder radius:4.5 height:32 sides:6 heightsegs:1 pos:[0, sy, 2]
    finish neck greenC "Stand_Neck"

    -- rounded head behind the red plate
    local head = ChamferBox width:12 length:8 height:26 fillet:3 filletsegs:2 pos:[0, sy, 32]
    finish head greenC "Stand_Head"

    -- ===== Group =====
    local grp = group #(front, back, plate, baseC, footL, footR, neck, head) name:"Monitor"
    grp.pivot = [0, sy, 0]
    select grp
    max zoomext sel all
    format "Monitor created.\n"
)
