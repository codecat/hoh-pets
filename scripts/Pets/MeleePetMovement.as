class MeleePetMovement : MeleeMovement
{
	float m_stopDistanceSq;

	MeleePetMovement(UnitPtr unit, SValue& params)
	{
		super(unit, params);

		m_stopDistanceSq = GetParamFloat(unit, params, "stop-distance", false, 30.0f);
		m_stopDistanceSq *= m_stopDistanceSq;
	}

	void Update(int dt, bool isCasting) override
	{
		if (!m_enabled || isCasting)
			return;

		auto pet = cast<PetActor>(m_behavior);
		if (pet is null || !pet.IsFollowingPlayer())
		{
			MeleeMovement::Update(dt, isCasting);
			return;
		}

		vec2 petPos = xy(pet.m_unit.GetPosition());
		vec2 playerPos = xy(pet.m_owner.m_unit.GetPosition());

		auto body = m_unit.GetPhysicsBody();

		float distance = distsq(playerPos, petPos);
		if (distance < m_stopDistanceSq)
			body.SetLinearVelocity(vec2());
		else
		{
			vec2 dir = m_pathFollower.FollowPath(petPos, playerPos);
			m_dir = atan(dir.y, dir.x);

			body.SetLinearVelocity(dir * m_speed);
		}

		SetWalkingAnimation();
	}
}
