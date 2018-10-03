class PetActor : CompositeActorBehavior
{
	PlayerBase@ m_owner;

	bool m_ignoreTargets;

	PetActor(UnitPtr unit, SValue& params)
	{
		super(unit, params);

		m_ignoreTargets = GetParamBool(unit, params, "ignore-targets", false);
	}

	void Update(int dt) override
	{
		CompositeActorBehavior::Update(dt);

		float distance = dist(m_unit.GetPosition(), m_owner.m_unit.GetPosition());
		if (distance > m_aggroRange)
			@m_target = null;
	}

	bool IsFollowingPlayer()
	{
		if (m_ignoreTargets)
			return true;

		return (m_target is null);
	}

	bool IsImmortal(bool ignoreBuffs = false) override
	{
		return true;
	}
}
