-- Spline chair v3 (matches reference photos) - 3ds Max 2025
-- BLUE  = backrest: tapered inverted U (narrower at top), small rounded top corners, open at bottom, upright
-- GREEN = ONE continuous spline: front-left leg -> bend -> seat rail going back -> rounded back corner
--         -> crossbar behind the seat -> rounded back corner -> seat rail forward -> bend -> front-right leg
-- The blue legs pass exactly through the back corners of the green frame.
-- Run: Scripting > Run Script...  then File > Save As .max

(
    -- ===== Parameters (cm) =====
    local seatH   = 45.0     -- height of seat frame
    local seatD   = 40.0     -- depth of seat (back crossbar to front legs)
    local rFront  = 7.0      -- bend radius at front of seat (leg -> rail)
    local rBack   = 6.0      -- corner radius at back of seat (rail -> crossbar)

    local backH        = 95.0
    local backBotHalfW = 22.0
    local backTopHalfW = 15.5
    local backR        = 6.0  -- top corner radius

    local tubeOn  = true      -- thick tube look like the photos (false = thin lines)
    local tubeThk = 1.5
    local steps   = 8

    fn hx z h hb ht = (hb - (hb - ht) * z / h)

    local blueCol  = color 40 150 235
    local greenCol = color 140 225 30

    -- ===== BLUE backrest (plane y = 0) =====
    local bk = SplineShape name:"Chair_Back" wirecolor:blueCol
    local sp = addNewSpline bk
    local zc = backH - backR
    local xc = hx zc backH backBotHalfW backTopHalfW

    addKnot bk sp #corner #line [-backBotHalfW, 0, 0]
    addKnot bk sp #corner #line [-xc, 0, zc]
    for i = 1 to (steps - 1) do
    (
        local a = 180.0 - (90.0 * i / steps)
        addKnot bk sp #smooth #curve [(-xc + backR) + backR * cos a, 0, zc + backR * sin a]
    )
    addKnot bk sp #corner #line [-xc + backR, 0, backH]
    addKnot bk sp #corner #line [ xc - backR, 0, backH]
    for i = 1 to (steps - 1) do
    (
        local a = 90.0 - (90.0 * i / steps)
        addKnot bk sp #smooth #curve [(xc - backR) + backR * cos a, 0, zc + backR * sin a]
    )
    addKnot bk sp #corner #line [xc, 0, zc]
    addKnot bk sp #corner #line [backBotHalfW, 0, 0]
    updateShape bk

    -- ===== GREEN seat frame (one continuous spline) =====
    local hw = hx seatH backH backBotHalfW backTopHalfW   -- same half-width as backrest at seat height
    local D  = seatD
    local H  = seatH
    local gr = SplineShape name:"Chair_Seat" wirecolor:greenCol
    local p  = addNewSpline gr

    -- front-left leg up
    addKnot gr p #corner #line [-hw, D, 0]
    addKnot gr p #corner #line [-hw, D, H - rFront]
    -- bend leg -> seat rail (going back)
    for i = 1 to (steps - 1) do
    (
        local a = 90.0 * i / steps
        addKnot gr p #smooth #curve [-hw, (D - rFront) + rFront * cos a, (H - rFront) + rFront * sin a]
    )
    addKnot gr p #corner #line [-hw, D - rFront, H]
    -- left rail to back
    addKnot gr p #corner #line [-hw, rBack, H]
    -- back-left corner
    for i = 1 to (steps - 1) do
    (
        local a = 180.0 + 90.0 * i / steps
        addKnot gr p #smooth #curve [(-hw + rBack) + rBack * cos a, rBack + rBack * sin a, H]
    )
    addKnot gr p #corner #line [-hw + rBack, 0, H]
    -- back crossbar
    addKnot gr p #corner #line [hw - rBack, 0, H]
    -- back-right corner
    for i = 1 to (steps - 1) do
    (
        local a = 270.0 + 90.0 * i / steps
        addKnot gr p #smooth #curve [(hw - rBack) + rBack * cos a, rBack + rBack * sin a, H]
    )
    addKnot gr p #corner #line [hw, rBack, H]
    -- right rail forward
    addKnot gr p #corner #line [hw, D - rFront, H]
    -- bend rail -> front-right leg
    for i = 1 to (steps - 1) do
    (
        local a = 90.0 - 90.0 * i / steps
        addKnot gr p #smooth #curve [hw, (D - rFront) + rFront * cos a, (H - rFront) + rFront * sin a]
    )
    addKnot gr p #corner #line [hw, D, H - rFront]
    addKnot gr p #corner #line [hw, D, 0]
    updateShape gr

    -- ===== Thickness like the photos =====
    if tubeOn do
    (
        for o in #(bk, gr) do
        (
            o.render_displayRenderMesh = true
            o.render_thickness = tubeThk
            o.render_sides = 12
        )
    )

    -- ===== Group =====
    local grp = group #(bk, gr) name:"Spline_Chair"
    grp.pivot = [0, 0, seatH]
    select grp
    max zoomext sel all
    format "Spline chair created.\n"
)
