function franksw(relay_1_2, state_off_on)
port_no = 'COM15';
r = rs232Class(port_no)
r.send(sprintf('%c%c%c',255,relay_1_2,state_off_on))
r.close
end


