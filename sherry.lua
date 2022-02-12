-- Sherry: shairport utilities
-- v1.0.0 @inkering
-- llllllll.co/t/22222

engine.name = 'PolySub'

function init()
   -- initialization
   os.execute 'jack_connect shairport-sync:out_L crone:input_1'
   os.execute 'jack_connect shairport-sync:out_R crone:input_2'
end

function key(n,z)
  -- key actions: n = number, z = state
end

function enc(n,d)
  -- encoder actions: n = number, d = delta
end

function redraw()
   -- screen redraw
   screen.clear()
   screen.move(0,8)
   screen.font_size(8)
   screen.level(15)
   screen.text("Shairport now routing")
   screen.move(0, 16)
   screen.text("to input")
   screen.update()
end


function cleanup()
  -- deinitialization
end
