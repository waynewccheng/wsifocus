r = rs232Class('COM18')
r.send(sprintf('%c%c%c',255,2,0))
r.close
