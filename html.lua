--[[
   Translate video webpages URLs to the corresponding
   video URL

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
--]]

-- Probe function.
function probe()
    return vlc.access == "http"
end

-- Parse function.
function parse()
    p = {}
    while true
    do
        line = vlc.readline()
        if not line then break end
        local exts = { "avi", "mpg" }
        local domain = vlc.path:sub(0, vlc.path:find('/'))
        for _,ext in pairs(exts) do
            r = string.match( line, 'href="((.*).' .. ext .. ')"' )
            if r then
                path = vlc.access .. '://' .. domain .. vlc.strings.decode_uri( r )
                table.insert( p, { path = path; url = vlc.path;} )
            end
        end
    end
    return p
end
