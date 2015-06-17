
AddCSLuaFile()

SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.DrawWeaponInfoBox = false

SWEP.Base = "weapon_base"
SWEP.PrintName = "Illuminati Pistol"
SWEP.Category = "Elemental's weapons"
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.ViewModelFOV = 54
SWEP.UseHands = true
SWEP.DrawAmmo = false
SWEP.HoldType = "pistol"

SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 5
SWEP.Primary.Damage = 20
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.Delay = 5
SWEP.Secondary.Damage = 8
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false

SWEP.DefaultMode = true

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 1, "NextIdle" )
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
		
		local pos = self.Owner:GetEyeTrace().HitPos
		
		if ( SERVER ) then
			local ang = self.Owner:EyeAngles()
			local ent = ents.Create( "ent_illuminati_confirmed" )
			if ( IsValid( ent ) ) then
				ent:SetPos(pos)
				ent:SetAngles( ang + Angle(0,90,0) )
				ent:SetOwner( self.Owner )
				ent:Spawn()
				ent:Activate()
				
				local phys = ent:GetPhysicsObject()
				if ( IsValid( phys ) ) then 
				phys:Wake() 
				phys:EnableMotion(false)
				end
			end
		end
		
		self:EmitSound( "weapons/illuminati/illuminati.wav", 100, math.random( 95, 105 ) )
		
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay+3 )
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay+3 )
		
	self:Idle()
end

function SWEP:SecondaryAttack()
	if ( !self:CanSecondaryAttack() ) then return end
		
		if ( SERVER ) then
			for k, ply in pairs( player.GetAll() ) do
				ply:ChatPrint( "Illuminati Incoming!!" )
			end
			local plyPos = self.Owner:GetPos()
			for i=0, math.random( 10, 35 )+1, 1 do
				timer.Simple((1+i)/4, function()
						if ( SERVER ) then
							local ang = self.Owner:EyeAngles()
							local ent = ents.Create( "ent_illuminati_incoming" )
							if ( IsValid( ent ) ) then
								ent:SetPos(plyPos+Vector(math.random( 0, 2000 )-1000,math.random( 0, 2000 )-1000,200+math.random( 50, 500 )))
								ent:SetAngles( ang )
								ent:SetOwner( self.Owner )
								ent:Spawn()
								ent:Activate()
								
								local phys = ent:GetPhysicsObject()
								if ( IsValid( phys ) ) then 
									phys:Wake() 
									phys:AddVelocity( ent:GetUp() ) 
								end
							end
							self:EmitSound( "weapons/illuminati/horn_long.wav", 100, math.random( 60, 80 ) )
						end
					end)
			end
		
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay+7 )
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay+7 )
	end

	

	self:Idle()
end

function SWEP:Reload()
	if ( !self.Owner:KeyPressed( IN_RELOAD ) ) then return end
	if ( self:GetNextPrimaryFire() > CurTime() ) then return end
	
	return
end

function SWEP:DoImpactEffect( trace, damageType )
	local effectdata = EffectData()
	effectdata:SetStart( trace.HitPos )
	effectdata:SetOrigin( trace.HitNormal + Vector( math.Rand( -0.5, 0.5 ), math.Rand( -0.5, 0.5 ), math.Rand( -0.5, 0.5 ) ) )
	util.Effect( "mighty_mlg_bounce", effectdata )

	return true
end

function SWEP:FireAnimationEvent( pos, ang, event )
	return true
end

function SWEP:KillSounds()
	if ( self.BeatSound ) then self.BeatSound:Stop() self.BeatSound = nil end
	if ( self.LoopSound ) then self.LoopSound:Stop() self.LoopSound = nil end
end

function SWEP:OnRemove()
	self:KillSounds()
end

function SWEP:OnDrop()
	self:KillSounds()
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )

	if ( CLIENT ) then return true end

	self:Idle()

	return true
end

function SWEP:Holster()
	self:KillSounds()
	return true
end

function SWEP:Think()

	if ( self:GetNextIdle() > 0 && CurTime() > self:GetNextIdle() ) then

		self:DoIdleAnimation()
		self:Idle()

	end

	if ( self.Owner:IsPlayer() && ( self.Owner:KeyReleased( IN_ATTACK ) || !self.Owner:KeyDown( IN_ATTACK ) ) ) then
		if ( self.LoopSound ) then self.LoopSound:ChangeVolume( 0, 0.1 ) end
		if ( self.BeatSound ) then self.BeatSound:ChangeVolume( 1, 0.1 ) end
	end
end

function SWEP:DoIdleAnimation()
	self:SendWeaponAnim( ACT_VM_IDLE )
end

function SWEP:Idle()

	self:SetNextIdle( CurTime() + self:GetAnimationTime() )

end

function SWEP:GetAnimationTime()
	local time = self:SequenceDuration()
	if ( time == 0 && IsValid( self.Owner ) && !self.Owner:IsNPC() && IsValid( self.Owner:GetViewModel() ) ) then time = self.Owner:GetViewModel():SequenceDuration() end
	return time
end

if ( SERVER ) then return end

killicon.Add( "weapon_mlgsmg", "mlg/killicon", color_white )

SWEP.WepSelectIcon = Material( "mlg/selection.png" )

function SWEP:DrawWeaponSelection( x, y, w, h, a )
	surface.SetDrawColor( 255, 255, 255, a )
	surface.SetMaterial( self.WepSelectIcon )

	local size = math.min( w, h )
	surface.DrawTexturedRect( x + w / 2 - size / 2, y, size, size )
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {} 
 
	self.AmmoDisplay.Draw = false

	return self.AmmoDisplay
end
