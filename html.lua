--[[
 Find all video links in a webpage and build a playlist.

 © Copyright 2012 @tuxcanfly

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

local url = require("socket.url")

local exts = {
    "3g2",
    "3gp",
    "asf",
    "asx",
    "avi",
    "flv",
    "mov",
    "mp4",
    "mpg",
    "mpeg",
    "mpeg4",
    "ogv",
    "mkv",
    "rm",
    "webm",
    "wmv"
}

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
        local base = vlc.access .. '://' .. vlc.path
        for _,ext in pairs(exts) do
            r = string.match( line, 'href="((.-).' .. ext .. ')"' )
            if r then
                if r:sub(0, 7) == 'http://' then
                    path = r
                else
                    path = url.absolute(base, vlc.strings.decode_uri( r ))
                end
                table.insert( p, { path = path; url = vlc.path; } )
            end
        end
    end
    return p
end
