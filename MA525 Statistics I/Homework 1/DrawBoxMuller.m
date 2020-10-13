function outputVals = DrawBoxMuller(mean, stdDev, sampleCount)
    drawCount = ceil(sampleCount/2);
    
    randVals = rand(drawCount, 2);
    
    xVals = mean + stdDev * (-2*log(randVals(:,1))).^0.5 .* cos(2*pi*randVals(:,2));
    yVals = mean + stdDev * (-2*log(randVals(:,1))).^0.5 .* sin(2*pi*randVals(:,2));

    outputVals = [xVals; yVals(1:sampleCount - size(xVals,1))];
end