import 'package:objd/core.dart';

int TIMER = 180; // Seconds

Entity player1 = Entity.Player(tags: ["player1"]);
Entity player2 = Entity.Player(tags: ["player2"]);

Entity armor1 = Entity(tags: ["player1-token"],limit: 1).sort(Sort.nearest);
Entity armor2 = Entity(tags: ["player2-token"],limit: 1).sort(Sort.nearest);

class Start extends Widget {
  @override
  generate(Context context) {
    return For.of([
        Execute.asat(
            Entity.Player().not(tags: ["spectator","player"]),
            children: [
                Log(Entity.Player()),
                Tag("player",entity: Entity.Player()).add(),
                Log(Entity.Player()),
                Tag("player1",entity: Entity.Player()).add(),
                Log(Entity.Player()),
            ]
        ),
        Execute.asat(
            Entity.Player().not(tags: ["spectator","player"]),
            children: [
                Log(Entity.Player()),
                Tag("player",entity: Entity.Player()).add(),
                Log(Entity.Player()),
                Tag("player2",entity: Entity.Player()).add(),
                Log(Entity.Player()),
            ]
        ),
        Team.join("ingame",Entity.All(tags: ["player"])),
        Tp(Entity.Player(tags: ["player1"]), to: Location.rel(x: 10,y: 5)),
        Tp(Entity.Player(tags: ["player2"]), to: Location.rel(x: -10,y: 5)),
        TimeStart(),
        CheckWinner()
        // Timeout(
        //     "start_check",
        //     children: [
        //         CheckWinner()
        //     ],
        //     ticks: 20
        // )
        
        
    //   Tag("player",entity: Entity.Player().not(tags: ["spectator","player"])).add(),
    //   Tag("player1",entity: Entity.Player().not(tags: ["spectator"])).add(),

    //   Tag("player",entity: Entity.Player().not(tags: ["spectator","player"])).add(),
    //   Tag("player2",entity: Entity.Player().not(tags: ["spectator","player1"])).add(),

    ]);
  }
}

class Swap extends Widget {
  @override
  generate(Context context) {
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

class Terminate extends Widget {
    @override
    generate(Context context) {
        return For.of([
            // Log("TERMINATED"),
            Team.leave(Entity.All(tags: ["player"])),
            Tag("player1",entity: Entity.All()).remove(),
            Tag("player2",entity: Entity.All()).remove(),
            Tag("player",entity: Entity.All()).remove(),
            // Execute.asat(
            //     Entity.Player(tags: ["player1"]),
            //     children: [
            //         Tag("player",entity: Entity.Player()).remove(),
            //         Tag("player1",entity: Entity.Player()).remove()
            //     ]
            // ),
            // Execute.asat(
            //     Entity.Player(tags: ["player2"]),
            //     children: [
            //         Tag("player",entity: Entity.Player()).remove(),
            //         Tag("player2",entity: Entity.Player()).remove()
            //     ]
            // ),
            TimeStop(),
            Timer.stop("check_winner")
            // Timer.stop("swap_time")
        ]);
    }
}

class TimeStart extends Widget {
    @override
    generate(Context context) {
        return Timer(
            "time_control",
            infinite: false,
            children: [
                Countdown()
            ],
            ticks: TIMER*20
        );
    }
}

class TimeStop extends Widget {
    @override
    generate(Context context) {
        return Timer.stop("swap_time");
    }
}

class Countdown extends Widget {
    @override
    generate(Context context) {
        return For.of([
            For(
                from: 1,
                to: 10,
                create: (i) => Timeout(
                    "countdown${i}",
                    children: [
                        Tellraw(Entity.All(team: Team("ingame")), show: [TextComponent("${i} Seconds Before Swapping!",color: Color("#ffa033"))])
                        // Execute.at(
                        //     Entity(tags: ["player"]),
                        //     children: [
                        //         Tellraw(Entity.All(team: Team("in-game")), show: [TextComponent("${i} Before Swapping!")])
                        //     ]
                        // )
                    ],
                    ticks: (TIMER-i)*20
                )
            ),
            For(
                from: 1,
                to: TIMER~/60,
                create: (i) => Timeout(
                    "countdown_minute${i}",
                    children: [
                        Tellraw(Entity.All(team: Team("ingame")), show: [TextComponent("${i} Minutes Before Swapping!",color: Color.Red)])
                        // Execute.at(
                        //     Entity(tags: ["player"]),
                        //     children: [
                        //         Tellraw(Entity.All(team: Team("in-game")), show: [TextComponent("${i} Before Swapping!")])
                        //     ]
                        // )
                    ],
                    ticks: (TIMER-(i*60))*20
                )
            ),
            Timeout(
                "swap_time",
                children: [
                    Swap()
                ]
                , ticks: TIMER*20)
        ]);
    }
}

class CheckWinner extends Widget {
    @override
    generate(Context context) {

        return Timer(
            "check_winner",
            infinite: false,
            children: [
                // Log("Ticking"),
                If(Condition.and([Condition.not(Condition.entity(Entity(tags: ["player2"]))),Condition.entity(Entity(tags: ["player1"]))]),then: [
                    Tellraw(Entity.All(team: Team("ingame")), show: [TextComponent("Player 1 Win!",bold: true,color: Color.Yellow)]),
                    // Log("Player 1 Win!"),
                    Terminate()
                    // Timer.stop("check_winner")
                ]),
                If(Condition.and([Condition.not(Condition.entity(Entity(tags: ["player1"]))),Condition.entity(Entity(tags: ["player2"]))]),then: [
                    Tellraw(Entity.All(team: Team("ingame")), show: [TextComponent("Player 2 Win!",bold: true,color: Color.Yellow)]),
                    // Log("Player 2 Win!"),
                    Terminate()
                    // Timer.stop("check_winner")
                ])
                ],
            ticks: 20
        );
    }
}