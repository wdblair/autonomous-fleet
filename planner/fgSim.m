classdef fgSim
    
    properties
        state
    end
    
    methods
       
        %% constructor:
        function self = fgSim(varargin)
            close all
            
            ip = inputParser;
            ip.addParamValue('ifSim', 1,  @(x) (x==0)||(x==1));
            ip.addParamValue('numAgents',  30, @(x) isnumeric(x));
            ip.addParamValue('speed',    1,  @(x) isnumeric(x));
            ip.addParamValue('plannerMethod',   'real',   @(x) isstr(x));
            ip.addParamValue('initOrders',  400,    @(x) floor(x)==(x))
            ip.addParamValue('howLong', 10*60, @(x) isnumeric(x))
            ip.addParamValue('planTime', 5*60, @(x) isnumeric(x))
            ip.parse(varargin{:});
            
            ifSim = ip.Results.ifSim;
            numAgents = ip.Results.numAgents;
            plannerMethod = ip.Results.plannerMethod;
            initOrders = ip.Results.initOrders;
            howLong = ip.Results.howLong;            
            speed = ip.Results.speed;
            planTime = ip.Results.planTime;
            
            load loc.mat

            % Initalize aircraft
            if ifSim==0
                for i = 1:numAgents
                    agents(i) = aircraft(5000+i,airports(mod(i,length(airports)))); 
                end
                
            else
                for i = 1:numAgents
                    agents(i) = simAgent(50000+i,loc(mod(i,length(loc))),speed);
                end
            end
            
            self.state = simState('locations',   loc(:), ...
                             'agents',           agents(:), ...
                             'map',              [], ...
                             'distances',        [], ...
                             'orders',           self.simOrders(loc, initOrders), ...
                             'time',             0);
             
             % ----------------- Run the Simuation -----------------------%
             tStart = now;
             tEnd = tStart + howLong;
             ifExit = 0;
             tUpdate = 0;
             while ifExit==0
                 if (now-tUpdate)/(25*60) > 5
                     self = self.update;
                 end
                 
                 self = self.iterate();
                 
                 if now > tEnd
                     ifExit = 1;
                 end
                 
             end
        end
        
        %% Simulate Orders:
        function self = simOrders(self,num)
            
            indsOrig = randi(length(self.state.locations),num,1);
            indsDest = randi(length(self.state.locations),num,1);
            
            for i = 1:num
                self.state.orders(end+1).origin = self.state.locations(indsOrig(i));
                self.state.orders(end).dest = self.state.locations(indsDest(i));
                try
                    self.state.orders(end).ind = self.state.orders(end-1).ind + 1;
                catch
                    self.state.orders(end).ind = 1;
                end
                self.state.orders(end).location = self.state.locations(indsOrig(i));
                self.state.orders(end).time = self.state.time + (2*24*60*60);
            end
        end
        
        %% Update Maps:
        function self = update(self)
           [self.state.map, self.state.distances, self.state.paths] = makeMap(self.state.locations);
        end
        
        %% Iterate:
        function self = iterate(self, timeLimit)
            % This function passes the object and relevant information to
            % the planner, receives goals back, and then sends commands to
            % all of the agents
            
            % decide
            tree = simTree(node(self.state,[],0), timeLimit);
            child = tree.search();
            
            % execute
            
            % decide
            self.state.visualize(1);
            
            keyboard
        end
        
        
    end
    
end