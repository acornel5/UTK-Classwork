% getWristAngles.m
% A. Cornelius
% 2020-10-2

% Calculates the wrist angles for a given transformation matrix

function solutions = getWristAngles(transformationMatrix)
    solutions = [atan2(transformationMatrix(2,3), transformationMatrix(1,3)), ...
    atan2(((transformationMatrix(1,3)).^2+(transformationMatrix(2,3)).^2).^0.5, transformationMatrix(3,3)), ...
    atan2(transformationMatrix(3,2), -transformationMatrix(3,1));
    atan2(-transformationMatrix(2,3), -transformationMatrix(1,3)), ...
    atan2(-((transformationMatrix(1,3)).^2+(transformationMatrix(2,3)).^2).^0.5, transformationMatrix(3,3)), ...
    atan2(-transformationMatrix(3,2), transformationMatrix(3,1))];
end