all: example.d64 exampleef.crt examplegmod2.crt

clean:
	del *.prg
	del *.pak
	del *.tbl
	del *sym.s
	del *.d64
	del *.d81
	del pagecross.txt

example.d64: example.seq boot.prg loader.prg main.pak music00.pak level00.pak charset00.pak
	maked64 example.d64 example.seq EXAMPLE_GAME______EG_2A 10

exampleef.crt: example.d64 example.seq main.pak loadsym.s mainsymcart.s efboot.s
	dasm efboot.s -oefboot.bin -f3
	makeef efboot.bin example.seq exampleef.bin
	cartconv -p -i exampleef.bin -o exampleef.crt -t easy

examplegmod2.crt: example.d64 example.seq main.pak loadsym.s mainsymcart.s gmod2boot.s
	dasm gmod2boot.s -ogmod2boot.bin -f3
	makegmod2 gmod2boot.bin example.seq examplegmod2.bin
	cartconv -p -i examplegmod2.bin -o examplegmod2.crt -t gmod2

loader.prg: kernal.s loader.s ldepack.s exomizer.s macros.s memory.s loadsym.txt ldepacksym.txt
	dasm ldepack.s -oldepack.prg -sldepack.tbl -f3
	symbols ldepack.tbl ldepacksym.s ldepacksym.txt
	dasm loader.s -oloader.bin -sloader.tbl -f3
	symbols loader.tbl loadsym.s loadsym.txt
	pack2 loader.bin loader.pak
	dasm ldepack.s -oloader.prg -sldepack.tbl -f3
	symbols ldepack.tbl ldepacksym.s ldepacksym.txt

boot.prg: boot.s loader.prg
	dasm boot.s -oboot.prg

main.pak: loadsym.s ldepacksym.s memory.s defines.s main.s init.s input.s file.s screen.s raster.s level.s ai.s \
	panel.s actor.s sprite.s physics.s sound.s \
	actordata.s sounddata.s aligneddata.s playroutinedata.s \
	bg/worldinfo.s bg/scorescr.chr
	dasm main.s -omain.bin -smain.tbl -f3
	symbols main.tbl mainsym.s
	symbols main.tbl mainsymcart.s mainsymcart.txt
	pack2 main.bin main.pak

music00.pak: music/example.sng
	gt2mini music/example.sng music00.s -ed000
	dasm music00.s -omusic00.prg -p3
	exomizer208 level -M255 -c -f -omusic00.pak music00.prg

level00.pak: bg/world00.map bg/world00.lvo bg/world00.lva level00.s
	dasm level00.s -olevel00.bin -f3
	pack2 level00.bin level00data.pak
	filejoin bg/world00.map+level00data.pak level00.pak

charset00.pak: charset00.s mainsym.s memory.s bg/world00.blk bg/world00.bli bg/world00.chr bg/world00.oba
	dasm charset00.s -ocharset00.bin -f3
	pack2 charset00.bin charset00.pak

