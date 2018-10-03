namespace Pets
{
	[Hook]
	void GameModeSpawnPlayer(BaseGameMode@ gm, PlayerRecord@ record)
	{
		auto prod = Resources::GetUnitProducer("actors/pets/pet_blob.unit");
		if (prod is null)
		{
			PrintError("Oh no we have no pet wisp oh well");
			return;
		}

		auto player = cast<PlayerBase>(record.actor);
		vec3 playerPos = player.m_unit.GetPosition();

		float angle = randf() * (3.1415926f * 2.0f);
		vec3 petSpawnPos = playerPos + vec3(
			cos(angle) * 20.0f,
			sin(angle) * 20.0f,
			0
		);

		UnitPtr u = prod.Produce(g_scene, petSpawnPos);

		auto pet = cast<PetActor>(u.GetScriptBehavior());
		if (pet is null)
			return;

		@pet.m_owner = player;
	}
}
