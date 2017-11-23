function rects = get_rect_from_pts(allpoints)
%from 5 points to rect -- l, t, r, b
if false
    rects = fast_get_rect_from_pts(allpoints);
else
    std_points = [
        0.2 0.2
        0.8 0.2
        0.5 0.5
        0.3 0.75
        0.7 0.75];

    rects = nan(size(allpoints, 1), 4);

    tic;
    for i = 1:size(allpoints, 1)
        try
            points = allpoints(i, :);
            points = reshape(points, 2, [])';
            points = points(1:5, :);
            t = cp2tform(double(points), std_points, 'similarity');

            [xc, yc] = tforminv(t, 0.5, 0.5);
            [xtl, ytl] = tforminv(t, 0, 0);
            [xtr, ytr] = tforminv(t, 1, 0);

            w = sqrt((xtl-xtr).^2+(ytl-ytr).^2);
            rect = [xc-w/2, yc-w/2, xc+w/2, yc+w/2];
            rect = round(rect);
            rects(i, :) = rect;
            if (mod(i, 10000) == 0)
                fprintf('%d/%d... ', i, size(allpoints, 1));
                toc;
            end
        catch
            fprintf('Fail to process: %d!\n', i);
            continue;
        end
    end
end

end

