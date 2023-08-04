-- Pepsi Was Here [Some imperfect constraint templates]
-- Creates a new ghost part that goes through walls and locks onto another part. Typically used for one-way forces.
local function CreateProxy(Part)
	local AttachmentPart = Instance.new("Attachment")
	local Proxy = Instance.new("Part", AttachmentPart)
	Proxy.Archivable = false
	Proxy.CanCollide = false
	Proxy.CanQuery = false
	Proxy.CanTouch = false
	Proxy.Massless = true
	Proxy.Size = Vector3.zero
	Proxy.Transparency = 1
	local AlignPosition = Instance.new("AlignPosition", Proxy)
	AlignPosition.Archivable = false -- Please note that when Archivable is disabled, the instance cannot be cloned, and WONT save when you close studio. Feel free to set to true (its default value)
	AlignPosition.Attachment0 = Instance.new("Attachment", Proxy)
	AlignPosition.Attachment1 = AttachmentPart
	AlignPosition.MaxForce, AlignPosition.Responsiveness = math.huge, 200
	AttachmentPart.Parent = Part
	return Proxy, AttachmentPart
end

-- https://create.roblox.com/docs/reference/engine/classes/AlignPosition
-- Applies force to Part in the direction to Goal.
local function AlignTo(Part, Goal, Rate, Responsiveness)
	local AttachmentPart = Instance.new("Attachment")
	local AlignPosition = Instance.new("AlignPosition", AttachmentPart)
	AlignPosition.Archivable = false
	AlignPosition.MaxForce = math.huge
	AlignPosition.Responsiveness = Responsiveness or 200
	AlignPosition.MaxVelocity = Rate or 20
	AlignPosition.Attachment0 = AttachmentPart
	AlignPosition.Attachment1 = Instance.new("Attachment", Goal)
	AttachmentPart.Parent = Part
	return AlignPosition
end

-- https://create.roblox.com/docs/reference/engine/classes/RodConstraint
-- Creates a rod constraint and locks the distance between Part1 and Part2.
local function ConnectRod(Part1, Part2, Length) -- Wish there was a winch setting for rods, too. :(
	local Attachment1 = Instance.new("Attachment")
	Attachment1.Archivable = false
	
	local Attachment2 = Instance.new("Attachment")
	Attachment2.Archivable = false
	Attachment1.Parent, Attachment2.Parent = Part2, Part1
	
	local Rod = Instance.new("RodConstraint")
	Rod.Archivable = false
	--Rod.Visible = true -- Used for visually seeing the rope
	Rod.Thickness = 0.1
	Rod.Length = Length or 10
	Rod.Attachment0, Rod.Attachment1 = Attachment1, Attachment2
	Rod.Parent = Attachment1
	return Rod
end

-- https://create.roblox.com/docs/reference/engine/classes/RopeConstraint
-- Creates a rope constraint that uses less forceful means to keep a distance. Unlock the rod, a rope's distance can be less than it's length. While a rod will not let you go further nor closer.
local function ConnectRope(Part1, Part2, Length, Speed, Slack) -- Tip: This could be used as a tween without TweenService!
	local Attachment1 = Instance.new("Attachment")
	Attachment1.Archivable = false
	
	local Attachment2 = Instance.new("Attachment")
	Attachment2.Archivable = false
	Attachment1.Parent, Attachment2.Parent = Part2, Part1
	
	local Rope = Instance.new("RopeConstraint")
	Rope.Archivable = false
	-- Rope.Visible = true -- Again used to visually see the rope.
	Rope.Thickness = 0.1
	Rope.Length = Slack or 40
	Rope.WinchEnabled = true -- Set to false if you JUST want a rope that doesn't try to pull anything in.
	Rope.WinchTarget = Length
	Rope.WinchForce = math.huge
	Rope.WinchSpeed = Speed or 25
	--Rope.Restitution = ? -- may help with going trough walls at high speeds. Set to what ever is best for your use
	Rope.Attachment0, Rope.Attachment1 = Attachment1, Attachment2
	Rope.Parent = Attachment1
	return Rope
end