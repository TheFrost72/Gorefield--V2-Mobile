import sys.FileSystem;
import funkin.options.type.TextOption;
import funkin.options.type.Checkbox;
import funkin.options.TreeMenuScreen;
import funkin.savedata.FunkinSave;
import funkin.backend.assets.ModsFolder;
import funkin.backend.utils.DiscordUtil;
import flixel.util.FlxColor;

function update(elapsed:Float)
{
    for (menu in tree)
    {
        if (menu.health != -1)
        {
            menu.health = -1;

            switch (menu.rawName)
            {
                case "optionsTree.gameplay-name":
                    var devCheckbox:Checkbox = new Checkbox(
                        "Developer Mode",
                        "Enables debug_tools.hx, allows for speeding up/slowing down the game.\n" +
                        "PRESS 1 - Skip Song\n" +
                        "PRESS 2 - Slows Game By 10% (Min Speed: 10%)\n" +
                        "PRESS 3 - Resets Game Speed To 100%\n" +
                        "PRESS 4 - Speeds Game By 10% (Max Speed: 200%)\n" +
                        "PRESS 5 - Hold To Speed Game By 2000%, Uses BOTPLAY\n" +
                        "PRESS 6 - Toggle For Botplay On Player Strums",
                        "dev",
                        null,
                        FlxG.save.data
                    );
                    devCheckbox.color = 0xFFD3D3D3;
                    menu.insert(8, devCheckbox);

                    FlxG.signals.postUpdate.add(() ->
                    {
                        for (m in tree)
                        {
                            if (m.rawName == "optionsTree.gameplay-name" && m.members.length > 12)
                            {
                                m.members.remove(m.members[12]);
                            }
                        }
                    });

                    var middlescrollCheckbox:Checkbox = new Checkbox(
                        "Middlescroll",
                        "Centers your note field on the screen.",
                        "middlescroll",
                        null,
                        FlxG.save.data
                    );
                    middlescrollCheckbox.color = 0xFFC9FEFF;
                    menu.insert(1, middlescrollCheckbox);

                    var babyCheckbox:Checkbox = new Checkbox(
                        "Baby Mode",
                        "Enable/Disable Mechanics.",
                        "baby",
                        null,
                        FlxG.save.data
                    );
                    babyCheckbox.color = 0xFFFFC9FE;
                    menu.insert(2, babyCheckbox);

                    var hardModeOption:TextOption = new TextOption(
                        "Hard Mode ",
                        "Add extra difficulty to mechanics. (FOR CHADS!)",
                        ">",
                        () ->
                        {
                            var hardTree = new TreeMenuScreen(
                                "Hard Mode",
                                "Choose Hard Mode options."
                            );

                            var psHard = new Checkbox(
                                "PS HARD MODE!!!",
                                "Start with only 2 PS instead of 4 / Take MORE Damage From PS Notes!",
                                "ps_hard",
                                null,
                                FlxG.save.data
                            );
                            psHard.color = 0xFFFFB3B3;

                            var scareHard = new Checkbox(
                                "SCREAMER HARD MODE!!!",
                                "Jump scares last 3x longer.",
                                "scare_hard",
                                null,
                                FlxG.save.data
                            );
                            scareHard.color = 0xFFFFD9B3;

                            var blueHard = new Checkbox(
                                "BLUE NOTE HARD MODE!!!",
                                "Bigger early hit window / INSTAKILL.",
                                "blue_hard",
                                null,
                                FlxG.save.data
                            );
                            blueHard.color = 0xFFB3D9FF;

                            var orangeHard = new Checkbox(
                                "ORANGE NOTE HARD MODE!!!",
                                "Smaller hit windows / INSTAKILL.",
                                "orange_hard",
                                null,
                                FlxG.save.data
                            );
                            orangeHard.color = 0xFFFFE0B3;

                            hardTree.add(psHard);
                            hardTree.add(scareHard);
                            hardTree.add(blueHard);
                            hardTree.add(orangeHard);

                            menu.parent.addMenu(hardTree);
                        }
                    );
                    menu.insert(3, hardModeOption);

                case "optionsTree.appearance-name":
                    for (member in menu.members.copy())
                    {
                        if (Std.isOfType(member, Checkbox))
                        {
                            menu.members.remove(member);
                        }
                    }

                    var trailsCheckbox = new Checkbox(
                        "Sprite Trails",
                        "Enable/Disable Trails On Sprites.",
                        "trails",
                        null,
                        FlxG.save.data
                    );
                    trailsCheckbox.color = 0xFFC9FEFF;

                    var flashingCheckbox = new Checkbox(
                        "Camera Flashing",
                        "Disable Camera Flashing.",
                        "flashing",
                        null,
                        FlxG.save.data
                    );
                    flashingCheckbox.color = 0xFFC9FEFF;

                    menu.insert(1, trailsCheckbox);
                    menu.insert(2, flashingCheckbox);

                case "optionsMenu.advanced":
                    if (menu.members.length > 3)
                    {
                        menu.members.remove(menu.members[3]);
                    }

                    menu.add(new TextOption(
                        "Gorefield Shaders ",
                        "Enable or disable individual shader effects.",
                        ">",
                        () ->
                        {
                            var shaderTree = new TreeMenuScreen(
                                "Shaders",
                                "Enable or disable shaders based on performance cost."
                            );

                            var bloom = new Checkbox("Glow Shaders", "Very intensive", "bloom", null, FlxG.save.data);
                            var particles = new Checkbox("Particle Effects", "Very intensive", "particles", null, FlxG.save.data);

                            var intShadersTree = new TreeMenuScreen("INT", "");
                            intShadersTree.add(bloom);
                            intShadersTree.add(particles);

                            for (i in 0...intShadersTree.members.length)
                            {
                                var member = intShadersTree.members[i];
                                member.color = FlxColor.interpolate(0xFFFE2323, 0xFFFFE3E3, i / intShadersTree.members.length);
                                shaderTree.add(member);
                            }

                            var glitch = new Checkbox("Glitch Shaders", "Medium intensive", "glitch", null, FlxG.save.data);
                            var warp = new Checkbox("Warp Shaders", "Medium intensive", "warp", null, FlxG.save.data);
                            var heat = new Checkbox("Heat Shader", "Medium intensive", "heatwave", null, FlxG.save.data);
                            var wrath = new Checkbox("Wrath Shader", "Medium intensive", "wrath", null, FlxG.save.data);

                            var medShadersTree = new TreeMenuScreen("MED", "");
                            medShadersTree.add(glitch);
                            medShadersTree.add(warp);
                            medShadersTree.add(heat);
                            medShadersTree.add(wrath);

                            for (i in 0...medShadersTree.members.length)
                            {
                                var member = medShadersTree.members[i];
                                member.color = FlxColor.interpolate(0xFFFFF97D, 0xFFFFFFFF, i / medShadersTree.members.length);
                                shaderTree.add(member);
                            }

                            var stat = new Checkbox("Static Shaders", "Low intensive", "static", null, FlxG.save.data);
                            var sat = new Checkbox("Saturation Shaders", "Low intensive", "saturation", null, FlxG.save.data);
                            var drunk = new Checkbox("Drunk Shaders", "Low intensive", "drunk", null, FlxG.save.data);
                            var vhs = new Checkbox("VHS Shader", "Low intensive", "vhs", null, FlxG.save.data);

                            var lowShadersTree = new TreeMenuScreen("LOW", "");
                            lowShadersTree.add(stat);
                            lowShadersTree.add(sat);
                            lowShadersTree.add(drunk);
                            lowShadersTree.add(vhs);

                            for (i in 0...lowShadersTree.members.length)
                            {
                                var member = lowShadersTree.members[i];
                                member.color = FlxColor.interpolate(0xFF88FF5D, 0xFFFFFFFF, i / lowShadersTree.members.length);
                                shaderTree.add(member);
                            }

                            menu.parent.addMenu(shaderTree);
                        }
                    ));
            }
        }
    }
}

function postCreate()
{
    var logoBl:FlxSprite = new FlxSprite(1020, 6);
    logoBl.frames = Paths.getSparrowAtlas('menus/logoMod');
    logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
    logoBl.animation.play('bump');
    logoBl.scale.set(0.3, 0.3);
    logoBl.scrollFactor.set(0, 0);
    logoBl.updateHitbox();
    logoBl.antialiasing = true;
    add(logoBl);

    var vignette:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menus/black_vignette"));
    vignette.alpha = 0.25;
    vignette.scrollFactor.set(0, 0);
    add(vignette);

    DiscordUtil.changePresence("Scrolling Through Menus...", "Settings");
}
