
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false

local bomb = Material( "mlg/mlg3.png" )

function ENT:Draw()
	local vel = self:GetVelocity()
	if ( vel:Length() < 0.5 ) then vel = self:GetAngles():Forward() end
	
	vel:Normalize()
	
	local vz = vel:Angle().p

	vel:Rotate( Angle( 0, 90, 0 ) )
	vel.z = 0
	
	surface.SetDrawColor( color_white )
	
	render.SetMaterial( bomb )
	render.DrawQuadEasy( self:GetPos(), vel , 64, 64, color_white, -90 + vz )

	render.SetMaterial( bomb )
	render.DrawQuadEasy( self:GetPos(), -vel, 64, 64, color_white, -90 - vz )

end

if ( CLIENT ) then killicon.Add( "ent_illuminati_confirmed", "mlg/killicon_illuminati", color_white ) return end

function ENT:Initialize()
	self:SetModel( "models/props_c17/SuitCase001a.mdl" )
	self:PhysicsInitSphere( 6, "metal" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	timer.Simple(10, function() 
		local ent = ents.Create( "env_explosion" )
		ent:SetPos( self:GetPos() )
		ent:SetOwner( self:GetOwner() )
		ent:SetPhysicsAttacker( self )
		ent:Spawn()
		ent:SetKeyValue( "iMagnitude", "0" )
		ent:Fire( "Explode", 0, 0 )
		
		util.BlastDamage( self, self:GetOwner(), self:GetPos(), 512, 200 )
		self:Remove()
		end)
	
	local sw = 16
	local ew = 0
end

function ENT:PhysicsCollide( data, physobj )
	
		
end
