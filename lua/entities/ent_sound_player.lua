
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false

function ENT:PlaySound()
	self:EmitSound( "annoying/annoy".. math.random(1,2) ..".wav", 100, math.random( 95, 105 ) )
end

function ENT:Initialize()
		
		self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
		self:PhysicsInitSphere( 6, "metal" )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PlaySound()
		timer.Simple(20, function() if(self:IsValid()) then self:Remove() end end)
end
