local mouse_tracker_frame = CreateFrame("Frame", nil, UIParent)
mouse_tracker_frame:Hide()
mouse_tracker_frame:EnableMouse()

function ModernUI_FlexButton_Initialize(button)
	button.TextureLeft.aspectRatio = button.TextureLeft:GetWidth() / button.TextureLeft:GetHeight()
	button.TextureRight.aspectRatio = button.TextureRight:GetWidth() / button.TextureRight:GetHeight()
	button.TexturePushedLeft.aspectRatio = button.TexturePushedLeft:GetWidth() / button.TexturePushedLeft:GetHeight()
	button.TexturePushedRight.aspectRatio = button.TexturePushedRight:GetWidth() / button.TexturePushedRight:GetHeight()
	button.TextureDisabledLeft.aspectRatio = button.TextureDisabledLeft:GetWidth() / button.TextureDisabledLeft:GetHeight()
	button.TextureDisabledRight.aspectRatio = button.TextureDisabledRight:GetWidth() / button.TextureDisabledRight:GetHeight()

	button.TextureCenter:SetPoint("TOPLEFT", button.TextureLeft, "TOPRIGHT")
	button.TextureCenter:SetPoint("BOTTOMRIGHT", button.TextureRight, "BOTTOMLEFT")
	button.TexturePushedCenter:SetPoint("TOPLEFT", button.TexturePushedLeft, "TOPRIGHT")
	button.TexturePushedCenter:SetPoint("BOTTOMRIGHT", button.TexturePushedRight, "BOTTOMLEFT")
	button.TextureDisabledCenter:SetPoint("TOPLEFT", button.TextureDisabledLeft, "TOPRIGHT")
	button.TextureDisabledCenter:SetPoint("BOTTOMRIGHT", button.TextureDisabledRight, "BOTTOMLEFT")

	button.isPushed = false

	ModernUI_FlexButton_UpdateScale(button);
	ModernUI_FlexButton_UpdateState(button, "NORMAL");
end

function ModernUI_FlexButton_UpdateScale(button)
	if button.isPushed == nil then
		-- Not initialized yet
		return
	end

	local height = button:GetHeight()

	button.TextureLeft:SetHeight(height)
	button.TextureLeft:SetWidth(height * button.TextureLeft.aspectRatio)
	button.TextureRight:SetHeight(height)
	button.TextureRight:SetWidth(height * button.TextureRight.aspectRatio)
	button.TexturePushedLeft:SetHeight(height)
	button.TexturePushedLeft:SetWidth(height * button.TexturePushedLeft.aspectRatio)
	button.TexturePushedRight:SetHeight(height)
	button.TexturePushedRight:SetWidth(height * button.TexturePushedRight.aspectRatio)
	button.TextureDisabledLeft:SetHeight(height)
	button.TextureDisabledLeft:SetWidth(height * button.TextureDisabledLeft.aspectRatio)
	button.TextureDisabledRight:SetHeight(height)
	button.TextureDisabledRight:SetWidth(height * button.TextureDisabledRight.aspectRatio)
end

local function getNewState(button, event)
	if event == "DISABLE" then
		button.isPushed = false
		return "DISABLED"
	end

	if event == "MOUSE_DOWN" then
		button.isPushed = true
		return "PUSHED"
	end

	if event == "MOUSE_UP" then
		button.isPushed = false
		return "NORMAL"
	end

	if event == "LEAVE" then
		if button.isPushed then
			mouse_tracker_frame:Show()
			mouse_tracker_frame:Raise()
			mouse_tracker_frame:SetScript("OnMouseUp", function(self, elapsed)
				button.isPushed = false
				mouse_tracker_frame:SetScript("OnMouseUp", nil)
			end)
		end

		return "NORMAL"
	end

	if event == "ENTER" then
		mouse_tracker_frame:SetScript("OnMouseUp", nil)

		if button.isPushed then
			return "PUSHED"
		end

		return "NORMAL"
	end

	return "NORMAL"
end

function ModernUI_FlexButton_OnEvent(button, event)
	if button.isPushed == nil then
		-- Not initialized yet
		return
	end

	if button:IsEnabled() == 0 then
		event = "DISABLE"
	end

	local new_state = getNewState(button, event)

	ModernUI_FlexButton_UpdateState(button, new_state)
end

function ModernUI_FlexButton_UpdateState(button, new_state)
	if button.isPushed == nil then
		-- Not initialized yet
		return
	end

	if button.currentState == new_state then
		return
	end

	button.currentState = new_state

	button.TextureLeft:SetAlpha(0)
	button.TextureCenter:SetAlpha(0)
	button.TextureRight:SetAlpha(0)

	button.TexturePushedLeft:SetAlpha(0)
	button.TexturePushedCenter:SetAlpha(0)
	button.TexturePushedRight:SetAlpha(0)

	button.TextureDisabledLeft:SetAlpha(0)
	button.TextureDisabledCenter:SetAlpha(0)
	button.TextureDisabledRight:SetAlpha(0)

	if new_state == "DISABLED" then
		button.TextureDisabledLeft:SetAlpha(1)
		button.TextureDisabledCenter:SetAlpha(1)
		button.TextureDisabledRight:SetAlpha(1)
		button.Text:SetPoint("CENTER", 0, 0)

		return
	end

	if new_state == "PUSHED" then
		button.TexturePushedLeft:SetAlpha(1)
		button.TexturePushedCenter:SetAlpha(1)
		button.TexturePushedRight:SetAlpha(1)
		button.Text:SetPoint("CENTER", 2, -1)

		return
	end

	button.TextureLeft:SetAlpha(1)
	button.TextureCenter:SetAlpha(1)
	button.TextureRight:SetAlpha(1)
	button.Text:SetPoint("CENTER", 0, 0)
end
