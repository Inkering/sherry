-- Sherry: shairport utilities
-- v1.0.0 @inkering
-- llllllll.co/t/22222
-- 
-- Requires 
-- shairport-sync-metadata-reader
-- from Github for now.
-- 
-- turn any enc to select patch
-- press k1 or k2 to activate
-- activating a patch deactivates
-- the others
UI = require("ui")

-- DATA FORMAT, 18 lines post decode
-- 1 - "ssnc" "pfls": "3216497574".
-- 2 - "ssnc" "pffr": "".
-- 3 - "ssnc" "mdst": "3216497574".
-- 4 - Album Name: "The Dream".
-- 5 - Artist: "alt-J".
-- 6 - Comment: "".
-- 7 - Composer: "Gus Unger-Hamilton, Joe Newman & Thom Sonny Green".
-- 8 - Genre: "Alternative".
-- 9 - File kind: "Apple Music AAC audio file".
--10 - Title: "The Actor".
--11 - Persistent ID: "bc374e9feef416a7".
--12 - Sort as: "Actor".
--13 - "ssnc" "mden": "3216497574".
--14 - "ssnc" "pcst": "3216497574".
--15 - Picture received, length 544616 bytes.
--16 - "ssnc" "pcen": "3216497574".
--17 - "ssnc" "prgr": "3216485286/3216497574/3227108682".
--18 - "ssnc" "prsm": "".

patches = {'input','nothing'}

scroll = {}

scroll[1] = UI.ScrollingList.new(55,8,1,patches)

local message = "K3 to get song title"

-- for now, requiring shairport-sync-metadata-reader
-- TODO internalize base64 decode

function init()
   -- initialization
   os.execute 'jack_connect shairport-sync:out_L crone:input_1'
   os.execute 'jack_connect shairport-sync:out_R crone:input_2'
   os.execute 'shairport-sync-metadata-reader < /tmp/shairport-sync-metadata | tee /tmp/output.txt &'
end

function magiclines(s)
        if s:sub(-1)~="\n" then s=s.."\n" end
        return s:gmatch("(.-)\n")
end

function redraw()
   screen.clear()
   screen.font_size(8)
   screen.level(15)
   screen.move(0,8)
   screen.text("Song")
   screen.move(0,16)
   -- the title from shairplay meta tmp file
   screen.text(message)
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
      local f = assert(io.open('/tmp/output.txt', "r"))
      local content = f:read("*all")
      f:close()
      for line in magiclines(content) do
        if line:sub(1, 5) == "Title" then
          message = line 
        end
      end
      -- empty the file when we're done
      io.open('/tmp/output.txt',"w"):close()
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
   -- kill the tracker for the metadata
   os.execute('pkill -f "shairport-sync-metadata-reader"')
end
