% wristInverseKinematics.m
% 2020-10-2
% A. Cornelius

% This function solves for the wrist angles given a requested tool
% orientation and an arm position/orientation. Both inputs should be 4x4
% position/orientation matrices

function solutions = wristInverseKinematics(requestedOrientation, armForwardKinematicMatrix)
    requiredWristRotation = [armForwardKinematicMatrix(1:3, 1:3)' * requestedOrientation(1:3, 1:3), [0 0 0]'; [0 0 0 1]];    
    solutions = [atan2(requiredWristRotation(2,3), requiredWristRotation(1,3)), ...
        atan2(((requiredWristRotation(1,3)).^2+(requiredWristRotation(2,3)).^2).^0.5, requiredWristRotation(3,3)), ...
        atan2(requiredWristRotation(3,2), -requiredWristRotation(3,1));
        atan2(-requiredWristRotation(2,3), -requiredWristRotation(1,3)), ...
        atan2(-((requiredWristRotation(1,3)).^2+(requiredWristRotation(2,3)).^2).^0.5, requiredWristRotation(3,3)), ...
        atan2(-requiredWristRotation(3,2), requiredWristRotation(3,1))];
end