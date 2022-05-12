import 'package:objd/core.dart';

class LoadFile extends Widget {
    LoadFile();
    
    @override
    generate(Context context) {
        return For.of([
            Team.add(
                "ingame",
                display: TextComponent("In-Game"),
                friendlyFire: false,
                collision: ModifyTeam.never
            )
        ]);
    }
}