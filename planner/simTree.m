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
                f_x = NaN(size(self.frontier));
                for i = 1:length(self.frontier)
                    f_x(i) = self.frontier(i).f_x;
                end
                
                [~,ind] = min(f_x);
                
                if numExpand ~= 0
                   self.frontier(ind).state.update(delta);
                end
                
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
            h = [self.frontier.heuristic];

            if isempty(iss)  
                [~,ind] = min(h);
            else
                h(~iss) = inf;
                [~,ind] = min(h);
            end
            
            child = self.frontier(ind);
            
        end
    end
end