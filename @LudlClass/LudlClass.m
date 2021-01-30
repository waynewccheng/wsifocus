% 1-29-2021: setXY, type, int32
% 9-21-2015
% added Z-stage control
classdef LudlClass
    properties
        comPort
    end
    
    methods
        %% Open the port
        function obj = LudlClass (portname)
            obj.comPort = rs232Class2stopbits(portname);
        end
        
        %% Exit remote mode
        function close (obj)
            % close RS232
            obj.comPort.close;
        end
        
        %%
        function ST_answer = sendCom (obj, CommandStr)
            % char by char
            try
                CommandStr;
                
                obj.comPort.send([CommandStr 13]);
                ST_answer = obj.comPort.get;
                
                if strcmp('N: -1',ST_answer)
                    disp('Unknown command');
                end
                
                if strcmp('N: -2',ST_answer)
                    disp('Illegal point type or axis, or module not installed');
                end
                
                if strcmp('N: -3',ST_answer)
                    disp('Not enough parameters (e.g. move r=)');
                end
                
                if strcmp('N: -4',ST_answer)
                    disp('Parameter out of range');
                end
                
                if strcmp('N: -21',ST_answer)
                    disp('Process aborted by HALT command');
                end
                
            catch
                disp('Error in send_com (S, CommandStr)');
                ST_answer=-1;
            end
        end
        
        %%
        function REMRES = reset(obj)
            str_RESET = obj.sendCom ('Remres');
            REMRES=str2num(strrep(str_RESET,':A ',''));
        end
        
        %%
        function Home = setHome(obj)
            str_Home = obj.sendCom ('HOME x y Z');
            Home=str2num(strrep(str_Home,':A ',''));
        end
        
        %%
        function success = getStatus(obj)
            success = obj.sendCom ('Status');
        end
        
        %%
        function success = rdStatX(obj)
            success = obj.sendCom ('Rdstat X');
        end
        
        %%
        function success = rdStatY(obj)
            success = obj.sendCom ('Rdstat Y');
        end
        
        %%
        function suceess = setXY_block (obj, xy)
            
            % theta
            theta = 3;
            
            % go to the location
            obj.setXY(xy);
            
            % wait until it stabilizes
            diff = [inf inf];
            xy_new = [inf inf];
            while max(diff) > theta
                xy_old = xy_new;
                xy_new = obj.getXY;
                diff = abs(xy_new - xy_old)
            end
            
            % need more time to stabile; don't know why
            pause(1);
            
            %xy
            %obj.getXY
        end
        
        %%
        function suceess = setXY (obj, xy)
            
            %             success = obj.sendCom ('STSPEED X=10000 Y=10000');
            %             success = obj.sendCom ('STSPEED X Y');
            %             success = obj.sendCom ('SPEED X=20000 Y=20000');
            %             success = obj.sendCom ('SPEED X Y');
            %             success = obj.sendCom ('ACCEL X=50 Y=50');
            %             success = obj.sendCom ('ACCEL X Y');
            
            xy = int32(xy);
            command_str=char(strcat('move',' x=',num2str(xy(1)),...
                ' y=',num2str(xy(2))));
            success = obj.sendCom (command_str);
            
        end
        
        %%
        function xy = getXY (obj)
            
            current_X = obj.sendCom ('where x');
            current_X = str2num(strrep(current_X,':A ',''));
            
            current_Y = obj.sendCom ('where y');
            current_Y = str2num(strrep(current_Y,':A ',''));
            
            xy = [current_X current_Y];
        end
        
        %%
        function setZ (obj, z)
            command_str=char(strcat('move',' B=',num2str(z)));
            success = obj.sendCom (command_str);
        end
        
        %%
        function z = getZ (obj)
            
            z = obj.sendCom ('where B');
            z = str2num(strrep(z,':A ',''));
        end
    end
end
