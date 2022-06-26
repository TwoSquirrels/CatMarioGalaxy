#include <Siv3D.hpp> // OpenSiv3D v0.6.4

#include "Entity/Entity.hpp"

void Main() {
	Entity entityA(Vec2(120.0, 240.0), Vec2(0.0, 4.0));
	while (System::Update()) {
		entityA.acceleration = (Vec2(320.0, 240.0) - entityA.location) / 240.0;
		entityA.move();
		Circle{ entityA.location, 8.0 }.draw();
	}
}
