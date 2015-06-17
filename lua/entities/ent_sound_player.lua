
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false

function ENT:Initialize()
	self:SetModel( "models/props_c17/SuitCase001a.mdl" )
	self:PhysicsInitSphere( 6, "metal" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:EmitSound( "annoying/annoy".. math.random(1,2) ..".wav", 100, math.random( 95, 105 ) )
	timer.Simple(20, function() self:Remove() end)
end
