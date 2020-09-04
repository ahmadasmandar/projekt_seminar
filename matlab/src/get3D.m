function [profile] = get3D(D,Threshold,ps,alpha,a,b)
    % 'get 3D' functiof for the LEGO Eisenbahn

    dim = size(D);      % dim = [y,x,?,#images]
    poi = zeros(dim(4),dim(1));
    profile = zeros(size(poi));
    x = 1:1:dim(1);
    y = 1:1:dim(2);
    ref_plane = a + b*x;

    for l = 1:dim(4)
        % img = imrotate(D(:,:,1,l),theta,'crop');

        img = imrotate(D(:,:,1,l),-90);
        img = double(img);

        for j = 1:dim(1)
            cm = NaN;
            if max(img(:,j))>= Threshold
                for k=1:dim(2)
                    if img(k,j)<Threshold
                        img(k,j)=0;
                    end
                end
                mr = sum(y'.*img(:,j));
                M  = sum(img(:,j));
                cm = mr/M;
            end
            poi(l,j) = cm;
        end
    end

    for k = 1:1:size(poi,1)
        profile(k,:)=-ps*((poi(k,:)-ref_plane)/sin(alpha*pi/180));
    end
end

