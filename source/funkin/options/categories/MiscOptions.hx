package funkin.options.categories;

import funkin.savedata.FunkinSave;
import funkin.options.TreeMenuScreen;
import funkin.options.type.TextOption;
import funkin.options.type.Separator;
import flixel.FlxG;

class MiscOptions extends TreeMenuScreen {
    public function new() {
        // Keep the Miscellaneous tab visible
        super('optionsTree.miscellaneous-name', 'optionsTree.miscellaneous-desc', 'MiscOptions.', ['UP_DOWN', 'A_B']);

        // Only keep the Reset Save Data option
        add(new Separator());

        add(new TextOption(getNameID('resetSaveData'), getDescID('resetSaveData'), () -> {
            FunkinSave.save.erase();
            FunkinSave.highscores.clear();
            FunkinSave.flush();
        }));
    }
}
