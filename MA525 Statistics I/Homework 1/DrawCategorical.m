% DrawCategorical.m
% 2020-9-6
% A. Cornelius

% This function draws a desired number of samples from discrete probablity
% categories.

% Inputs:
% categories: The list of categories to draw from. This should be a two
%   column matrix. Each row defines one output category. The first column 
%   contains the output values for the category, the second defines the
%   relative probability. The probabilities do not have to be normalized
%   (i.e., they do not have to sum to 1.)
% sampleCount: the number of samples to draw

% Outputs:
% outputVals: the desired outputs drawn from the categorical distribution


function outputVals = DrawCategorical(categories, sampleCount)    
    % Add a zero-category to the top with 0 probability. This is not
    % necessary, but makes the for-loops later more elegant
    categories = [zeros(1,2); categories]; 
    
    % Normalize the probabilities of each category
    categories(:,2) = categories(:,2)./(sum(categories(:,2)));
    
    % Calculate the CDF of each category, appended in a third column
    categoryCount = size(categories,1);
    categories(:,3) = zeros(categoryCount,1);
    for i = 2:categoryCount
        categories(i,3)=categories(i-1,3)+categories(i,2);
    end
    
    % Draw random vals from the uniform 0:1 distribution and initialize the
    % output array
    randVals = rand(sampleCount,1);
    outputVals = zeros(size(randVals));
    
    % For each category, determine which randVals fall into that category
    % and transfer those to the output array
    for i = 2:categoryCount
        indices = (randVals <= categories(i,3) ) & (randVals > categories(i-1,3));
        outputVals(indices) = categories(i,1);
    end
end