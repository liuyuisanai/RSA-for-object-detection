function dump_error(list, errimg, errdet, misimg, misdet, gt, root)
% dump_error(list, error_img, err_detail, miss_image, miss_detail, 'error_dump/')
    if nargin < 7
        dump = false;
    else
        dump = true;
    end
    all_neg = errimg; %union(errimg, misimg);
    for i = 1 : length(all_neg)
        id = all_neg(i);
        fprintf('%d...\n', id);
        img = imread(list{id});
        gtt = gt{i};
        gtt = [gtt(:,[1 2]) gtt(:,3)-gtt(:,1) gtt(:,4)-gtt(:,2)];
        img = insertShape(img, 'rectangle', gtt, 'Color', 'yellow', 'LineWidth', 2);
        if(any(errimg==id))
            err = errdet{id};
            err = [err(:,[1 2]) err(:,3)-err(:,1) err(:,4)-err(:,2)];
            img = insertShape(img, 'rectangle', err, 'Color', 'yellow', 'LineWidth', 2);
        end
        if(any(misimg==id))
            err = misdet{id};
            err = [err(:,[1 2]) err(:,3)-err(:,1) err(:,4)-err(:,2)];
            img = insertShape(img, 'rectangle', err, 'Color', 'red', 'LineWidth', 2);
        end
        hold off;
        imshow(img);
        if dump
            imwrite(img, fullfile(root, [num2str(id) '.jpg']));
        end
        waitforbuttonpress;
    end

end