-- Sherry: shairport utilities
-- v1.0.0 @inkering
-- llllllll.co/t/22222
-- 
-- turn any enc to select patch
-- press k1 or k2 to activate
-- activating a patch deactivates
-- the others

UI = require("ui")

patches = {'input','nothing'}

scroll = {}

scroll[1] = UI.ScrollingList.new(55,8,1,patches)

message = {}

function init()
   -- initialization
   os.execute 'jack_connect shairport-sync:out_L crone:input_1'
   os.execute 'jack_connect shairport-sync:out_R crone:input_2'
end

function redraw()
   screen.clear()
   screen.font_size(8)
   scroll[1]:redraw()
   screen.move(0,34)
   screen.level(15)
   screen.text('patched to')
   screen.update()
end

function key(n,z)
  if n == 2 and z == 1 then
    if scroll[1].index == 1 then
        os.execute 'jack_connect shairport-sync:out_L crone:input_1'
        os.execute 'jack_connect shairport-sync:out_R crone:input_2'
    elseif scroll[1].index == 2 then
       os.execute 'jack_disconnect shairport-sync:out_L crone:input_1'
       os.execute 'jack_disconnect shairport-sync:out_R crone:input_2'
    end
  end
    if n == 3 and z == 1 then
    if scroll[1].index == 1 then
        os.execute 'jack_connect shairport-sync:out_L crone:input_1'
        os.execute 'jack_connect shairport-sync:out_R crone:input_2'
    elseif scroll[1].index == 2 then
       os.execute 'jack_disconnect shairport-sync:out_L crone:input_1'
       os.execute 'jack_disconnect shairport-sync:out_R crone:input_2'
    end
  end

  redraw()
end

function enc(n,d)
   if n == 1 then
      scroll[1]:set_index_delta(d,false) -- sets index according to delta of E1, no wrapping
   elseif n == 2 then
      scroll[1]:set_index_delta(d,false) -- sets index according to delta of E2, with wrapping
   elseif n == 3 then
      scroll[1]:set_index_delta(d,false) -- sets index according to delta of E2, with no wrapping
   end
   redraw()
end

function cleanup()
  -- deinitialization
end
