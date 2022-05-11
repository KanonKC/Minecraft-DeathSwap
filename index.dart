import "package:objd/core.dart";
import './main.dart';
import './load.dart';
import './module/swap.dart';
import './module/start.dart';


void main(List<String> args){
	createProject(
		Project(
			name:"Death Swap",
			target:"../", // path for where to generate the project
            version: 18,
			generate: CustomWidget() // The starting point of generation
		),
		args
	);
}

class CustomWidget extends Widget {
    @override
    Widget generate(Context context){
        return Pack(
            name:"deathswap",
            main: File( // optional
                'main',
                child: MainFile()
            ),
            load: File(
                'load',
                child: LoadFile()
            ),
            files: [
              File("swap",child: Swap()),
              File("start",child: Start())
            ],        
            modules: [
            ]
        );
    }
}