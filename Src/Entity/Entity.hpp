#pragma once

#include <Siv3D.hpp>

/**
 * 座標平面上に実在する物体
 */
class Entity {
public:

	/**
	 * @param location 初期座標
	 * @param velocity 初期速度
	 * @param acceleration 初期加速度
	 */
	Entity(Vec2 location, Vec2 velocity = Vec2(0.0, 0.0), Vec2 acceleration = Vec2(0.0, 0.0));

	/**
	 * 物体を動かす
	 * TODO: 速度が一定以上の時に分割して動かす
	 */
	void move();

	// 座標
	Vec2 location;
	// 速度
	Vec2 velocity;
	// 加速度
	Vec2 acceleration;
};
