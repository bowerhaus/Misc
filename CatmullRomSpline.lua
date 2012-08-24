
CatmullRomSpline = Core.class()

--local modf = math.modf
--local int = function(a, b) 
--	local n, _ = modf(a/b) 
--	return n 
--end

--[[
	ctrlPoints: Array of control points
	numCtrl: 	Number of control points (must be at least 4)
	step: 		Path precision (fraction < 1) the lower the value, the more points between control points
	endPath:	Whether to add extra control point at end of path, may change this and always add extra control point
				unless this is set and use it to retuen to the start of the path.
]]

function CatmullRomSpline:generateCRS(p1, p2, p3, p4, start, step, ctrl)
	local u = start
	local u2, u3
	
	local p1x, p1y, p2x, p2y, p3x, p3y, p4x, p4y, ox, oy
	local t
	
	t = (p1*2)-1 p1x = ctrl[t] p1y = ctrl[t+1]
	t = (p2*2)-1 p2x = ctrl[t] p2y = ctrl[t+1]
	t = (p3*2)-1 p3x = ctrl[t] p3y = ctrl[t+1]
	t = (p4*2)-1 p4x = ctrl[t] p4y = ctrl[t+1]
	local isCtrl = true
	
	while u <= 1 do
		u2 = u * u
		u3 = u2 * u
		
		ox = p1x * ((-0.5 * u3) +        (u2) - (0.5 * u)) + 
		     p2x * (( 1.5 * u3) + (-2.5 * u2) + (1.0)) +
			 p3x * ((-1.5 * u3) +  (2.0 * u2) + (0.5 * u)) +
			 p4x * (( 0.5 * u3) -  (0.5 * u2))
		
		oy = p1y * ((-0.5 * u3) +        (u2) - (0.5 * u)) + 
		     p2y * (( 1.5 * u3) + (-2.5 * u2) + (1.0)) +
			 p3y * ((-1.5 * u3) +  (2.0 * u2) + (0.5 * u)) +
			 p4y * (( 0.5 * u3) -  (0.5 * u2))
		
		local point = { x = ox, y = oy, bIsCtrl = isCtrl, img = nil }
		self.path[#self.path+1] = point
		isCtrl = false
		
		u = u + step
	end
	
	return u - 1
end

function CatmullRomSpline:init(ctrlPoints, numCtrl, uStep, endPath)
	-- Cannot have less than 4 control points
	if numCtrl < 4 then 
		print("ERROR : Spline paths require at least 4 control points")
		return nil 
	end
	
--	print("Create catmullRomSpline with "..numCtrl.." ctrlPoints")
	-- Start with empty path
	self.path = {}
	
	local u = 0
	local p1, p2, p3, p4 = 1, 1, 2, 3
	
	for i=1, numCtrl-1 do
		u = self:generateCRS(p1, p2, p3, p4, u, uStep, ctrlPoints)
		p1 = p2
		p2 = p3
		p3 = p4
		p4 = p4 + 1
		if p4 > numCtrl then p4 = numCtrl end
	end
	
	local idx
	if endPath then
		idx = (numCtrl*2)-1
		local point = { x=ctrlPoints[idx], y=ctrlPoints[idx+1], bIsCtrl=true, img=nil }
		self.path[#self.path+1] = point
	end
	
end

function CatmullRomSpline:getNumPoints() return #self.path end
function CatmullRomSpline:getImage(idx)
	if idx > #self.path then
		print("ERROR: "..idx.." > "..#self.path)
		return nil
	end
	
	return self.path[idx].img
end

function CatmullRomSpline:setImage(idx, img)
	if idx > #self.path then
		print("ERROR: "..idx.." > "..#self.path)
		return nil
	end
	
	self.path[idx].img = img
end


function CatmullRomSpline:getPoint(idx)
	if idx > #self.path then
		print("ERROR: "..idx.." > "..#self.path)
		return nil
	end
	
	return self.path[idx]
end


