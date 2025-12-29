function update(elapsed){
    if (health >= 0){
        switch (PlayState.instance.boyfriend.curCharacter){
            case 'jon-player', 'bf-apoc', 'bf-ultra':
                lossSFX = "gameOverSFX2";

            case 'bf-bw':
                lossSFX = "gameOverSFXhijon";

            case 'nermal-cry', 'nermal-cry-pov':
                lossSFX = "gameOverSFXnermal";

            case 'god-nermal':
                lossSFX = "gameOverSFXgod";

            case 'garfield-prision', 'garfield-prision2', 'garfield-prision3':
                lossSFX = "gameOverSFXcaptive";

            case 'bf-sky', 'bf-fall':
                lossSFX = "gameOverSFXterror";

            case 'bf-black', 'bf-black2', 'bf-sb':
                lossSFX = "gameOverSFXsansfield";
        }
    }
}
function onGameOver(){
    // Reset camera effects safely
    if (FlxG.cameras != null && FlxG.cameras.list != null){
        for (camera in FlxG.cameras.list){
            if (camera != null){
                camera.setFilters([]);
                camera.stopFX();
            }
        }
    }

    // Reset time safely
    curSpeed = 1;
    FlxG.timeScale = 1;

    // Cancel camera tweens safely
    if (FlxG.camera != null){
        FlxTween.cancelTweensOf(FlxG.camera);
        FlxG.camera.setScrollBoundsRect(
            Math.NEGATIVE_INFINITY,
            Math.NEGATIVE_INFINITY,
            Math.POSITIVE_INFINITY,
            Math.POSITIVE_INFINITY,
            false
        );
    }
}
