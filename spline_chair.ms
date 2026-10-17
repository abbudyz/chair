-- Spline chair (matches screenshot) - 3ds Max 2025
-- WHITE  = tapered backrest frame, rounded top, open at bottom, leaning back
-- YELLOW = two side profiles (L/R): front leg -> rounded bend -> seat rail going back
-- Pure splines (no thickness), as seen in the screenshot.
-- Run: Scripting > Run Script...  then File > Save As .max

(
    -- ===== Parameters (cm) =====
    local seatH    = 45.0
    local seatD    = 42.0     -- seat depth (front leg to backrest)
    local frontHalfW = 22.0   -- half distance between the two side profiles
    local sideR    = 8.0      -- bend radius at front of seat

    local backH    = 95.0
    local backBotHalfW = 21.0
    local backTopHalfW = 18.0
    local backR    = 12.0
    local backTilt = 8.0      -- degrees
    local steps    = 8

    local frontY = seatD / 2.0
    local backY  = -seatD / 2.0

    -- ===== WHITE backrest (tapered, rounded top, open bottom) =====
    fn hx z h hb ht = (hb - (hb - ht) * z / h)

    local bk = SplineShape name:"Chair_Back" wirecolor:white
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

    bk.pos = [0, backY, 0]
    rotate bk (angleaxis (-backTilt) [1, 0, 0])

    -- ===== YELLOW side profiles =====
    local backYatSeat = backY - seatH * tan backTilt
    local halfWSeat = hx seatH backH backBotHalfW backTopHalfW

    local sides = #()
    for s in #(-1, 1) do
    (
        local nm = if s < 0 then "Chair_Side_L" else "Chair_Side_R"
        local sd = SplineShape name:nm wirecolor:yellow
        local p = addNewSpline sd
        local x = s * frontHalfW

        addKnot sd p #corner #line [x, frontY, 0]
        addKnot sd p #corner #line [x, frontY, seatH - sideR]
        -- bend: front leg (going up) -> seat rail (going back)
        for i = 1 to (steps - 1) do
        (
            local a = 90.0 * i / steps
            addKnot sd p #smooth #curve [x, (frontY - sideR) + sideR * cos a, (seatH - sideR) + sideR * sin a]
        )
        addKnot sd p #corner #line [x, frontY - sideR, seatH]
        -- seat rail ends at the backrest leg
        addKnot sd p #corner #line [s * halfWSeat, backYatSeat, seatH]
        updateShape sd
        append sides sd
    )

    -- ===== Group, pivot at seat/back junction (gizmo location in screenshot) =====
    local grp = group #(bk, sides[1], sides[2]) name:"Spline_Chair"
    grp.pivot = [0, backYatSeat, seatH]

    select grp
    max zoomext sel all
    format "Spline chair created.\n"
)
