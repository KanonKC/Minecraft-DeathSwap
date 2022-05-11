import 'package:objd/core.dart';

class Swap extends Widget {
  @override
  generate(Context context) {
    Entity player1 = Entity.Player(tags: ["player1"]);
    Entity player2 = Entity.Player(tags: ["player2"]);

    Entity armor1 = Entity(tags: ["player1-token"],limit: 1).sort(Sort.nearest);
    Entity armor2 = Entity(tags: ["player2-token"],limit: 1).sort(Sort.nearest);


    return For.of([
      Execute.at(
        player1,
        children: [
          Summon(
            Entities.armor_stand,
            tags: ["player-token","player1-token"]
          )
        ]
      ),
      Execute.at(
        player2,
        children: [
          Summon(
            Entities.armor_stand,
            tags: ["player-token","player2-token"]
          )
        ]
      ),
      Teleport.entity(player1,to: armor2),
      Teleport.entity(player2,to: armor1),
      Kill(Entity(tags: ["player-token"]))
    ]);
  }
}