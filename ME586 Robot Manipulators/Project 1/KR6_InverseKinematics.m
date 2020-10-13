% KR6_Inverse_Kinematics.m
% 2020-10-3
%
% This function calculates the required joint angles for a given 4x4
% position/orientation matrix. The input matrix should use the same
% orientation as the base. The output angles will be in radians.

function robotConfigurations = KR6_Inverse_Kinematics(requestedPosition)
    % Calculate required wrist position
    wristToToolTransform = dhTransformLiteral(0, pi/4, 420, 0);
    toolToWristTransform = inv(wristToToolTransform);
    wristPosition = requestedPosition * toolToWristTransform;
    
    % Perform IK on the anthropomorphic arm
    armConfigurations = anthroArmInverse(wristPosition(1,4), wristPosition(2,4), wristPosition(3,4))*pi/180;
    
    % Run IK on each arm configuration
    robotConfigurations = zeros(size(armConfigurations,1)*2, 6);
    for i = 1:size(armConfigurations,1)
        % Run forward kinematics to get the orientation at the end of joints 1-3
        armConfig = armConfigurations(i,:);
        armTransform = anthroArmForward(armConfig);
        
        % Calculate the required wrist transformation and wrist angles
        wristTransform = [armTransform(1:3, 1:3)' * wristPosition(1:3, 1:3), [0 0 0]'; [0 0 0 1]];
        if wristTransform(1,3)~=wristTransform(2,3) % Check for wrist singularity
            % Non-singular
            wristConfig = [atan2(wristTransform(2,3), wristTransform(1,3)), ...
                atan2(((wristTransform(1,3)).^2+(wristTransform(2,3)).^2).^0.5, wristTransform(3,3)), ...
                atan2(wristTransform(3,2), -wristTransform(3,1));
                atan2(-wristTransform(2,3), -wristTransform(1,3)), ...
                atan2(-((wristTransform(1,3)).^2+(wristTransform(2,3)).^2).^0.5, wristTransform(3,3)), ...
                atan2(-wristTransform(3,2), wristTransform(3,1))];
        else
            % Singularity. Find two solutions where either vartheta_4 or
            % vartheta_5 is set to 0. There are actually infinite
            % solutions, though.
            wristConfig = [atan2(wristTransform(2,1),wristTransform(1,1)), 0, 0; 0, 0, atan2(wristTransform(2,1),wristTransform(1,1))]; 
            fprintf('The wrist for configurations %s, %s are singular. Some possible positions are returned, but positioning there is not a good idea.', i, i+1)
        end
        % Save the solutions
        robotConfigurations(i*2-1:i*2,:)=[[armConfig; armConfig], wristConfig];
    end
end