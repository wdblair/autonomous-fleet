function [singlePath cost] = pathFinder(bw1, bw2, mask, ifPlot, ac, ap)

if ~exist('ifPlot','var')
    ifPlot = 0;
end

D1 = bwdistgeodesic(mask, bw1, 'quasi-euclidean');
D2 = bwdistgeodesic(mask, bw2, 'quasi-euclidean');

D = D1 + D2;
D = round(D * 8) / 8;

D(isnan(D)) = inf;
paths = imregionalmin(D);

singlePath = bwmorph(paths, 'thin', inf);
cost = sum(singlePath(:));

% test for a truly infinite cost:
badStart = sum(sum((bw1==1) & (mask==0)));
badEnd = sum(sum((bw2==1) & (mask==0)));

if ((badStart + badEnd) > 0)
    cost = Inf;
end

if ifPlot == 1
    figure
    %subplot(2,2,1)
    imagesc(D1)
    title('Distance from Start')
    %subplot(2,2,2)
    figure
    imagesc(D2)
    title('Distance from Goal')
    %subplot(2,2,3)
    figure
    imagesc(D)
    title('Distance from Optimal Path')
    
    %subplot(2,2,4)
    figure
    plotMe = zeros(size(mask));
    plotMe = plotMe + double(mask) + 2*double(paths) + 4*double(singlePath);
    imagesc(plotMe)
    
    hold on
    
    sp = ind2sub(find(bw1),size(bw1));
    ep = ind2sub(find(bw2),size(bw2));
    
    plot(ac(1), ac(2),'go','MarkerFaceColor','g');
    plot(ap(1), ap(2),'ro','MarkerFaceColor','r');
    
    title(['Path cost=' num2str(cost)])
end

end