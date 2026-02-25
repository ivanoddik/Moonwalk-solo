local NavigationConfig = {
    camera = {
        fieldOfViewIdle = 70,
        fieldOfViewMoving = 74,
        fovLerpSpeed = 6,
        minZoomDistance = 10,
        maxZoomDistance = 40,
    },
    base = {
        anchorName = "BaseAnchor",
        hudLabelName = "BaseDirectionLabel",
        hudOffset = UDim2.fromOffset(0, 80),
    },
}

return NavigationConfig
