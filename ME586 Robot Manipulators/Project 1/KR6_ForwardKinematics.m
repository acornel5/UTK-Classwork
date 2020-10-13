function transformationMatrix = robotForwardKinematics(config)
    % (a, alpha, d, theta)
    dhTable = [
        260     pi/2       675   config(1);
        680      0               0       config(2);
        35      3*pi/2     0       config(3);
        0       0               670    0;    
        0       -pi/2      0       config(4);
        0       pi/2       0       config(5);
        0       0               0   config(6);
        0       pi/4            305+115   0
    ];

    for i =1:size(dhTable,1)
        dhvals = dhTable(i,:);  
        transMatrices{i}=dhTransformLiteral(dhvals(1), dhvals(2), dhvals(3), dhvals(4));
    end
    
    transformationMatrix = eye(4);
    
    for i = 1:size(dhTable,1)
        transformationMatrix = transformationMatrix * transMatrices{i};
    end
end