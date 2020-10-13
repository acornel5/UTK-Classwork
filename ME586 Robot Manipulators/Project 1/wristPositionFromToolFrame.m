% wristPositionFromToolFrame.m
% 2020-10-2
% A. Cornelius

% This function takes a requested 4x4 toolframe (including position vector 
% and orientation matrix) and calculates the required position of the wrist
% center

% Inputs:
% toolFrame: a 4x4 toolframe including position vector and orientation
% matrix

% Outputs:
% wristPosition: a 4x1 position vector specifying the required position of
% the center of the wrist

function wristPosition = wristPositionFromToolFrame(toolFrame)
    wristToToolTransform = dhTransformLiteral(0, pi/4, 305+115, 0);
    toolToWristTransform = inv(wristToToolTransform);
    wristPosition = toolFrame * toolToWristTransform;
end