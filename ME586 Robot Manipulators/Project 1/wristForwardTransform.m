% wristForwardTransform.m
% 2020-10-2
% A. Cornelius

% This function generates the forward transformation matrix for a given set
% of wrist angles

function transformMatrix = wristForwardTransform(axisAngles)
t34 = dhTransform(0, -pi/2, 0, axisAngles(1));
t45 = dhTransform(0, pi/2, 0, axisAngles(2));
t56 = dhTransform(0, 0, 0, axisAngles(3));

transformMatrix = t34 * t45 * t56;
end