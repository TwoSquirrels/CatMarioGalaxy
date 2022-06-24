# include <Siv3D.hpp> // OpenSiv3D v0.6.4

void Main() {
	Scene::SetBackground(ColorF{ 0.8, 0.9, 1.0 });
	const Font font{ 60 };
	const Font emojiFont{ 60, Typeface::ColorEmoji };
	font.addFallback(emojiFont);
	const Texture texture{ U"example/windmill.png" };
	const Texture emoji{ U"🐈"_emoji };
	Vec2 emojiPos{ 300, 150 };
	Print << U"Push [A] key";
	while (System::Update()) {
		texture.draw(200, 200);
		font(U"Hello, Siv3D!🚀").drawAt(Scene::Center(), Palette::Black);
		emoji.resized(100 + Periodic::Sine0_1(1s) * 20).drawAt(emojiPos);
		Circle{ Cursor::Pos(), 40 }.draw(ColorF{ 1, 0, 0, 0.5 });
		if (KeyA.down()) Print << Sample({ U"Hello!", U"こんにちは", U"你好", U"안녕하세요?" });
		if (SimpleGUI::Button(U"Button", Vec2{ 640, 40 })) emojiPos = RandomVec2(Scene::Rect());
	}
}
