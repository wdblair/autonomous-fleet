function [map, cost, path] = makeMap(locs)

%% Weather stuff:

% Get weather
load weathermap.mat
weather = wmsread(weathermap,'ImageFormat','image/png');

% Convert weather image to the correct size:
weather = imresize(weather,[1000,1000]);
for i = 1:3
    weather(:,:,i) = flipud(weather(:,:,i));
end
xd = weathermap.Lonlim(1):(weathermap.Lonlim(2) - weathermap.Lonlim(1))/1000:weathermap.Lonlim(2);
yd = weathermap.Latlim(1):(weathermap.Latlim(2) - weathermap.Latlim(1))/1000:weathermap.Latlim(2);

map.weather = weather;
map.xd = xd;
map.yd = yd;

%% Shortest path planner:
weatherd = mean(weather,3)<255;                
weatherRegions = regionprops(weatherd,'Area','PixelList','Image','PixelList','PixelIdxList');
inds = [weatherRegions.Area] > 500;
weatherRegions(inds==0) = [];

weatherBin = true(size(weatherd,1),size(weatherd,2));

for i = 1:length(weatherRegions)
    weatherBin(weatherRegions(i).PixelIdxList) = false;
end

cost = Inf(length(locs),length(locs));
path = cell(size(cost));
for i = 1:length(locs)
    a1 = [locs(i).x locs(i).y];
    
    [~,a1(1)] = histc(a1(:,1),yd);
    [~,a1(2)] = histc(a1(:,2),xd);
    
    parfor k = 1:length(locs)
        a2 = [locs(k).x locs(k).y];
        [~,a2(1)] = histc(a2(:,1),yd);
        [~,a2(2)] = histc(a2(:,2),xd);

        goals = false(size(weatherBin)); starts = goals;
        goals(a2(2),a2(1)) = true;
        starts(a1(2), a1(1)) = true;

        [path{i,k}, cost(i,k)] = pathFinder(goals, starts, weatherBin, 0, a1, a2);

    end
end

end
