function configurations = anthroArmInverse(X,Y,Z)
    d0 = 675; % mm
    a0 = 260; % mm
    a1 = 680; % mm
    a2 = sqrt(35^2+670^2); % mm
    
    ry = Z-d0;
    % Accounting for multiple solutions
    rx(1) = sqrt((Y^2)+(X^2)) - a0;
    rx(2) = sqrt((Y^2)+(X^2)) + a0;
    
    L = sqrt(rx.^2+ry^2);
    phi1 = atan2(35/670,1).*180/pi;
    phi2 = acos((L.^2-a1^2-a2^2)./(-2*a1*a2)).*180/pi;
    phi3 = atan2(ry./rx,1).*180/pi;
    phi4 = acos((a2^2-a1^2-L.^2)./(-2*a1.*L)).*180/pi;
    
    % Handling shoulder pointing toward or away from wrist
    theta0(1) = atan2(Y/X,1).*180/pi;
    theta0(2) = theta0(1)+180;
    theta0(3) = theta0(1);
    theta0(4) = theta0(2);
    
    % Handling elbow pointing upward or downward
    theta1(1) = phi3(1)+phi4(1);
    theta1(2) = 180-phi3(2)-phi4(2);
    theta1(3) = 360+phi3(1)-phi4(1);
    theta1(4) = 180-phi3(2)+phi4(2);
    
    theta2(1) = 180+phi2(1)+phi1;
    theta2(2) = 180+phi1-phi2(2);
    theta2(3) = 180-phi2(1)+phi1;
    theta2(4) = 180+phi1+phi2(2);
    
    flag = 0;
    sols = 0;
    sing = 0;
    for i = 1:length(theta0)  
        if mod(i,2) == 1
            sho = "forward";
        else
            sho = "backward";
        end
        if i<3
            elb = "up";
        else
            elb = "down";
        end
        fprintf('Option %d: shoulder %s elbow %s:\n', i, sho, elb)
        
        % If solution isn't real, output Inf
        if ~isreal(theta0(i)) || ~isreal(theta1(i)) || ~isreal(theta2(i))
            theta0(i) = Inf;
            theta1(i) = Inf;
            theta2(i) = Inf;
            flag = 1;
            fprintf('No solution found\n\n')
        % Coerce theta2 [0,2pi)
        else
            if isnan(theta0(i)) || isnan(theta1(i)) || isnan(theta2(i))
                sing = 1;
                sols = Inf;
            else
                sols = sols + 1;
            end
            
            theta2(i) = theta2(i)-90;
            if theta1(i) >= 360
                theta1(i) = theta1(i)-360;
            end

            if theta2(i) >= 360
                theta2(i) = theta2(i)-360;
            end
        end
        
        if flag == 0
            fprintf('theta0 = %4.4f deg\n', theta0(i))
            fprintf('theta1 = %4.4f deg\n', theta1(i))
            fprintf('theta2 = %4.4f deg\n\n', theta2(i))
        end
        flag = 0;
    end
    
    fprintf('Found %d arm solutions\n', sols)
    if (sols == 0)
        fprintf('Point not in workspace\n')
    elseif sing == 1
        fprintf('This point is a singularity\n')
    end
    
    configurations = [theta0' theta1' theta2'];
    invalidRows = isinf(configurations(:,1));
    configurations(invalidRows,:)=[];
    
end