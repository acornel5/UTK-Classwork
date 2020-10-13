function fig = robotGraphFunction(axisPositions)

% Map joint positions to the actual moving joints, since there are fixed
% transformations
axisPositionMap = [1 2 3 5 6 7];

% a, alpha, d, theta (theta is ignored because it's set by the joint
% position.)
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

bodyNames = ["base", "body1", "body2", "body3", "body4", "body5", "body6", "body7", "body8", "body9"];

jointTypes = ["revolute", "revolute", "revolute", "fixed", "revolute", "revolute", "revolute", "fixed", "fixed"];

robot = rigidBodyTree;

for i = 1:size(dhparams,1)
    jointArray{i,1} = rigidBody(bodyNames(i+1));
    jointArray{i,2} = rigidBodyJoint(['jnt' num2str(i)], 'revolute');
    setFixedTransform(jointArray{i,2}, dhparams(i,:),'dh');
    jointArray{i,1}.Joint = jointArray{i,2};
    addBody(robot, jointArray{i,1}, bodyNames(i));
end

% Define the configuration
clear config;
for i = 1:size(dhparams,1)
    config(i).JointName = jointArray{i,2}.Name;
    if ~isempty(find(axisPositionMap==i))
        config(i).JointPosition = axisPositions(find(axisPositionMap==i));
    else
        config(i).JointPosition = 0;
    end
end


fig = figure%('visible', 'off')
clf

show(robot, config, 'Frames', 'on');
grid on

%axis([0 1 -1 1 -1 1]);
% axis off
% 
xlim([-1 1])
ylim([-1 1])
zlim([0 2])
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')

zoom on

axisPositions = axisPositions * 180/pi;
axisPositionText = [ '\vartheta_1 = ' num2str(axisPositions(1),3) '°' newline ...
    '\vartheta_2 = ' num2str(axisPositions(2),3) '°' newline ...
    '\vartheta_3 = ' num2str(axisPositions(3),3) '°' newline ...
    '\vartheta_4 = ' num2str(axisPositions(4),3) '°' newline ...
    '\vartheta_5 = ' num2str(axisPositions(5),3) '°' newline ...
    '\vartheta_6 = ' num2str(axisPositions(6),3) '°'];

annotation('textbox',[.8 .5 .2 .2],'String',axisPositionText,'EdgeColor','none')