classdef simTree
    
    properties
        root
        frontier
        timeLimit %seconds
    end
    
    methods
        function self = simTree(root,timeLimit)
            self.root = root;
            self.timeLimit = timeLimit;
            self.frontier = root;
        end
        
        function child = search(self)
            numExpand = 0;
            startTime = now;
            endTime = now+(self.timeLimit/(24*60*60));
            
            ifExit = 0;
            % Expand:
            while ifExit==0
                % Each expansion seems to take about 7-10 seconds (@3 GHz, single compthread)
                f_x = [self.frontier.f_x];
                
                [~,ind] = min(f_x);
                
                %if numExpand ~= 0
                %   self.frontier(ind).state.update(delta);
                %end
                
                ch = self.frontier(ind).getChildren;
                self.frontier(ind) = [];
                self.frontier = [self.frontier;ch(:)];                
                
                t = now;
                
                numExpand = numExpand + 1;
                
                sv = ['Number Expansions: ' num2str(numExpand)];
                sv = [sv ' Elapsed Time: ' num2str((now-startTime)*(24*60*60))];
                sv = [sv ' FrontierSize: ' num2str(length(self.frontier))];
                disp(sv)
                
                if sum([self.frontier.isSuccess]) || (t > endTime)
                    ifExit = 1;
                end
            end
            
            % Make a choice
            iss = [self.frontier.isSuccess];
            f_x = [self.frontier.f_x];

            if sum(iss)==0  
                [~,ind] = min(f_x);
            else
                f_x(~iss) = inf;
                [~,ind] = min(f_x);
            end
            
            % Now reduce this simply to the next step, & return
            child = self.frontier(ind);
            while ~isempty(child.parent.parent)
                child = child.parent;
            end
            
        end
    end
end