function [Gx,Gy] = mygradient(f)

    ndims = size(f);
    disp(ndims(1))
    disp(ndims(2))
    Gx = zeros(ndims);
    Gy = zeros(ndims);

    if(ndims > 2)

        n = ndims(2);
        %gradient along first dimension
        % Take forward differences on left and right edges
        Gx(:,1) = (f(:,2) - f(:,1));
        Gx(:,n) = (f(:,n) - f(:,n-1));

        % Take centered differences on interior points
        Gx(:,2:n-1) = (f(:,3:n) - f(:,1:n-2)) ./ 2;
        
        n = ndims(1);
        %gradient along second dimension
        Gy(1,:) = (f(2,:) - f(1,:));
        Gy(n,:) = (f(n,:) - f(n-1,:));
        Gy(2:n-1,:) = (f(3:n,:) - f(1:n-2,:)) ./ 2;

    end

end