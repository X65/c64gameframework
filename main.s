SHOW_PLAYROUTINE_TIME   = 0
SHOW_CHARSETANIM_TIME   = 0
SHOW_SPRITEIRQ_TIME     = 0
SHOW_SCROLLWORK_TIME    = 0
SHOW_SKIPPED_FRAME      = 0
SHOW_FREE_TIME          = 0
SHOW_DEBUG_VARS         = 0

                include memory.s
                include loadsym.s

                org loaderCodeEnd

EntryPoint:     ldx #$ff                        ;Init stack pointer to top
                txs
                jsr InitAll                     ;Call to disposable init code
                lda #1
                jsr PlaySong
                lda #0
                jsr ChangeLevel
                lda #0
                jsr ChangeZone
                jsr RedrawScreen
                lda #4
                sta scrollSX
                lda #<txtWelcome
                ldx #>txtWelcome
                jsr PrintPanelTextIndefinite

MainLoop:       jsr ScrollLogic
                jsr DrawActors
                jsr UpdateFrame
                jsr GetControls
                jsr ScrollLogic
                jsr UpdateActors
                jsr UpdateFrame
                jsr UpdateLevelObjects
                jmp MainLoop

randomAreaStart:
                include raster.s
                include sound.s
                include input.s
                include screen.s
                include sprite.s
                include math.s
                include file.s
                include panel.s
                include actor.s
                include physics.s
                include ai.s
                include level.s
randomAreaEnd:

txtWelcome:     dc.b "C64GAMEFRAMEWORK EXAMPLE",0

                include playroutinedata.s
                include sounddata.s
                include actordata.s
                include miscdata.s
                include aligneddata.s
                
        ; Dynamic allocation area begin

fileAreaStart:
                include init.s