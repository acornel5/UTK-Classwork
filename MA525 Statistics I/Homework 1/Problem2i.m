% Problem2i.m
% 2020-9-6
% A. Cornelius

% This script solves problem 2 i from the first homework set. It returns a
% figure which compares the expected to actual histogram for the
% categorical distribution. This function can be run as a stand-alone, or
% will return the figure for display.

function f = Problem2i()
    % Define a categorical distribution. The first column is the
    % categories, and the second column is their relative weights. The
    % weights do not need to be normalized: the DrawCategorical function
    % will normalize them automatically. This distribution is intended to
    % show a weighted 6 sided die with a higher probability of rolling a 6.
    categoricalDistribution = [1 1; 2 1; 3 1; 4 1; 5 1; 6 2];
    sampleCount = 100000;
    
    % Calculate the number of expected values for each category
    expectedCounts = categoricalDistribution(:,2) .* sampleCount ./ (sum(categoricalDistribution(:,2)));
    
    % Draw values
    drawnVals = DrawCategorical(categoricalDistribution, sampleCount);
    
    % Create figure
    f = figure(1);
    clf
    h = histogram(drawnVals);
    xlabel('Value')
    ylabel('# of samples')
    hold on
    for i = 1:size(categoricalDistribution,1)
        plot([h.BinEdges(i) h.BinEdges(i+1)], [expectedCounts(i) expectedCounts(i)], 'color', 'red', 'LineWidth', 2)
    end
    hold off
    legend(["Sampled histogram", 'Expected'], 'Location', 'northwest')
    chi2gof(drawnVals, 'Edges', h.BinEdges, 'Expected', expectedCounts')
%     chiSquared = sum((expectedCounts - h.Values').^2./expectedCounts)
%     degreesOfFreedom = sampleCount - 1;
%     chiSquarePDF = chi2pdf(chiSquared, degreesOfFreedom);
end