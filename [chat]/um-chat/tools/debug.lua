local debugStatus = require('config.chat').debug

function Debug(msg, level)
   if not debugStatus then return end
   lib.print[level or 'info'](msg)
end