function plot_detected(rect, ptss, th, root, list)
    for i = 1 : length(rect)
        img = imread(fullfile(root, list{i}));
        s = rect{i}(:,5);
        it = find(s>th);
        s = s(it);
        box = rect{i}(it,:);
        pts = reshape(ptss{i}(it,:)', [], 1);
        box = [box(:,1) box(:,2) box(:,3)-box(:,1) box(:,4)-box(:,2)];
%         img = insertShape(img, 'rectangle', box);
        close all;
        fprintf('Showing %d...', i)
        imshow(img);
        hold on
        plot(pts(1:2:end), pts(2:2:end), 'r+');
        for iii = 1 : size(box, 1)
            rectangle('Position', box(iii,:), 'EdgeColor', 'y');
            ts = sprintf('%.2f',s(iii)); 
            text(double(box(iii,1)-5),double(box(iii,2)-5), ts, 'FontSize',10,'Color','g','FontWeight','bold')
        end
        waitforbuttonpress;
        fprintf('down\n');
    end
end