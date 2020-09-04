    function img = normalize_adjust(img)
        img = double(img);
        minv = min(img(:));
        maxv = max(img(:));
        diff = maxv - minv;
        img = (img - minv) ./ diff;
    end