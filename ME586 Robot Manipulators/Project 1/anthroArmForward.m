function armMatrix = anthroArmForward(config)
    % (a, alpha, d, theta)
    subTable = [
        0.26    pi/2       0.675   config(1);
        0.68    0               0       config(2);
        0.035   3*pi/2     0       config(3);
        0       0               0.67    0
        ];

    for i =1:size(subTable,1)
        dhvals = subTable(i,:);  
        transMatrices{i}=dhTransformLiteral(dhvals(1), dhvals(2), dhvals(3), dhvals(4));
    end
    
    armMatrix = transMatrices{1} * transMatrices{2} * transMatrices{3} * transMatrices{4};
end