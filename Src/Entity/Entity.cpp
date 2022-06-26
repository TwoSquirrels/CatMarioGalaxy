#include "Entity.hpp"

Entity::Entity(Vec2 location, Vec2 velocity, Vec2 acceleration)
	: location{ location }
	, velocity{ velocity }
	, acceleration{ acceleration } {}

void Entity::move() {
	this->velocity += this->acceleration;
	this->location += this->velocity;
}
