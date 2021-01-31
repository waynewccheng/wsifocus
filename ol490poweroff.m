r = rs232Class('COM15')
r.send(sprintf('%c%c%c',255,2,0))
r.close
