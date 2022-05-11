import 'package:objd/core.dart';

class Start extends Widget {
  @override
  generate(Context context) {
    return For.of([
      Tag("player",entity: Entity.Player().not(tags: ["spectator","player"])).add(),
      Tag("player1",entity: Entity.Player().not(tags: ["spectator"])).add(),

      Tag("player",entity: Entity.Player().not(tags: ["spectator","player"])).add(),
      Tag("player2",entity: Entity.Player().not(tags: ["spectator","player1"])).add(),

    ]);
  }
}