function Rotating_Model(omega1, omega2, omega3, L1, L2, L3)
    %shape vertices
    a = [-4 -2 -2;
        -4 2 -2;
        4 2 -2;
        4 -2 -2;
        -4 -2 2;
        -4 2 2;
        4 2 2;
        4 -2 2];
    %shape faces (numbers in each row repersents vertices of face)
    b = [1 2 6 5;
        2 3 7 6;
        3 4 8 7;
        4 1 5 8;
        1 2 3 4;
        5 6 7 8];

    %create cube patch
    p1 = patch('faces',b,...
            'vertices',a,...
            'facecolor',[.5 .5 .5],...
            'edgecolor',[1,1,1],...
            'facealpha',0.5);
    
    view(2)
    axis([-5 5 -5 5 -5 5])
    grid on
    patch('faces', [1,2], 'vertices', [-5 0 0; 5 0 0], 'edgecolor', 'b');
    i = 1;

    xAxis = patch('faces', [1,2], 'vertices', [getXAxis(p1)-[5 0 0]; getXAxis(p1)+[5 0 0]], 'edgecolor', 'r');
    while true
       finalTime = datenum(clock + [0, 0, 0, 0, 0, 0.001]); 
       
       rotAxis = [L1(i) L2(i) L3(i)];
       rotAxisW = toWorld(rotAxis, p1);
       disp(getYAxis(p1) + getXAxis(p1));
       disp(toWorld([1 1 0], p1));
       if mod(i, 100) == 0
           patch('faces', [1,2], 'vertices', [0 0 0; rotAxisW(1) rotAxisW(2) rotAxisW(3)], 'edgecolor', 'b');
       end
       
       v1 = omega1(i)*0.01 * getXAxis(p1);
       v2 = omega2(i)*0.01 * getYAxis(p1);
       v3 = omega3(i)*0.01 * getZAxis(p1);
       v = v1+v2+v3;
       mag = sqrt(v(1)*v(1) + v(2)*v(2) + v(3)*v(3));
       
       rotate(p1,v,mag,[0 0 0]);
       rotate(xAxis,v,mag,[0 0 0]);
       
%        rotate(p1,getXAxis(p1),omega1(i)*0.01,[0 0 0]);
%        rotate(p1,getYAxis(p1),omega2(i)*0.01,[0 0 0]);
%        rotate(p1,getZAxis(p1),omega3(i)*0.01,[0 0 0]);
       while datenum(clock) < finalTime
            drawnow
       end
       i = i + 1;
    end
end

function [pos] = getXAxis(p1)
    a = p1.Vertices(8,:);
    b = p1.Vertices(5,:);
    pos = (b - a) / 8;
end

function [pos] = getYAxis(p1)
    a = p1.Vertices(1,:);
    b = p1.Vertices(2,:);
    pos = (b - a) / 4;
end

function [pos] = getZAxis(p1)
    a = p1.Vertices(5,:);
    b = p1.Vertices(1,:);
    pos = (b - a) / 4;
end

function v2 = toWorld(v1, p)
    pX = getXAxis(p);
    pY = getYAxis(p);
    pZ = getZAxis(p);
    T = [pX(1) pY(1) pZ(1); pX(2) pY(2) pZ(2); pX(3) pY(3) pZ(3)];
    v2 = T * transpose(v1);
end

% TODO: Calculate axis of nutation

   