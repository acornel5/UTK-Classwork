% a, alpha, d, theta (theta is ignored because it's set by the joint
% position.)
% dhparams = [...
%     675/1000     pi/2    260/1000     0; ...
%     0       0       680/1000       0; ...
%     0     3*pi/2    35/1000       0; ...
%     670/1000     -pi/2   0     0; ...
%     0       pi/2    0       0; ...
%     115/1000       0       0     0; ...
%    % 0       0       304.8/1000     0; ...
%     ];
dhparams = [...
    260/1000     pi/2    675/1000     0; ... % Joint 1
    680/1000       0       0       0; ... % Joint 2
    35/1000     3*pi/2    0       0; ... % Joint 3
    0       0       0.67    0; % Transform from joint 3 to center of wrist
    0     -pi/2    0    0; ... % Joint 4
    0       pi/2    0       0; ... % Joint 5
    0       0       115/1000   0; ... % Joint 6
    0       0       0.115       0; ... % Transform from center of wrist to coupling plate
    0       pi/4       305/1000     0; ... % Transform from coupling plate to tool frame
    ];
%swapping a and d from what we thought they were to what they actually are
%holdvals = dhparams(:,1);
%dhparams(:,1)=dhparams(:,3);
%dhparams(:,3)=holdvals;

% home = [ ...
%  0      0;
%  pi/2      pi/2;
%  pi      pi;
%  0      0
%  pi      pi;
%  0      0;
%  0      0;
%  -pi/2      -pi/2;
% ];

home = [ ...
 0      0;
0 0;
0 0;%3*pi/2      3*pi/2;
 0      0
 0 0;%pi      pi;
 0      0;
 0      0;
 0 0;%-pi/2      -pi/2;
];



motionMatrix = [ ...
 0      0;
 0      0;
 0      0;
 0      0;
 0      0;
 0      0;
 0      0;
 0      0;
];

motionMatrix=motionMatrix+home;
names = ["base", "body1", "body2", "body3", "body4", "body5", "body6", "body7"];

robot = rigidBodyTree;

% Column 1 is bodies, column 2 is joints
jointArray = cell(size(dhparams,1),2);


for i = 1:size(dhparams,1)
    jointArray{i,1} = rigidBody(['body' num2str(i)]);
    jointArray{i,2} = rigidBodyJoint(['jnt' num2str(i)], 'revolute');
    setFixedTransform(jointArray{i,2}, dhparams(i,:),'dh');
    jointArray{i,1}.Joint = jointArray{i,2};
    addBody(robot, jointArray{i,1}, names(i));
end

% Define axis config
% Generate a linspace that animates the joint motion
motionArray = zeros(size(dhparams,1), 100);
for i = 1:size(dhparams,1)
    motionArray(i,:) =  linspace(motionMatrix(i,1), motionMatrix(i,2), 100);
end    


figure(1)
clf
hold on

for motion = 1:size(motionArray,2)
    for i = 1:size(jointArray,1)
        config(i).JointName = jointArray{i,2}.Name;
        config(i).JointPosition = motionArray(i,motion);
    end
    show(robot, config, 'Frames', 'on');
    grid on
end

%axis([0 1 -1 1 -1 1]);
% axis off
% 
% xlim([0 1000])
% ylim([-1000 1000])
% zlim([-1000 1000])
