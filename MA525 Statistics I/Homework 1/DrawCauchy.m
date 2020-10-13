% DrawCategorical.m
% 2020-9-6
% A. Cornelius

% This function draws a desired number of samples from a Cauchy
% distribution.

% Inputs:
% categories: The list of categories to draw from. This should be a two
%   column matrix. Each row defines one output category. The first column 
%   contains the output values for the category, the second defines the
%   relative probability. The probabilities do not have to be normalized
%   (i.e., they do not have to sum to 1.)
% sampleCount: the number of samples to draw

% Outputs:
% outputVals: the desired outputs drawn from the categorical distribution


function outputVals = DrawCauchy(mu, sigma, sampleCount)    
    % Draw the CDF values from the 0:1 uniform distribution
    cdfValues = rand(sampleCount,1);
    
    % Transform the values to give the output distribution:
    outputVals = mu + sigma.*tan(pi*(cdfValues - 0.5));
end