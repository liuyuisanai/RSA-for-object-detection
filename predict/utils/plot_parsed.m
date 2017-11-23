function plot_parsed(parsed, th, root, list, dumproot)
    for i = 1 : length(parsed)
        if isfield(parsed(i), 'img')
            img = parsed(i).img;
        else
            img = imread(fullfile(root, list{i}));
        end
        s = parsed(i).cls_score;
        it = find(s>th);
        s = s(it);
        box = parsed(i).box(it,:);
        pts = reshape(parsed(i).point(it,:)', [], 1);
        box = [box(:,1) box(:,2) box(:,3)-box(:,1) box(:,4)-box(:,2)];
%         img = insertShape(img, 'rectangle', box);
        close all;
        fprintf('Showing %d...', i)
        imshow(img);
        hold on
        plot(pts(1:2:end), pts(2:2:end), 'r.', 'markers',15);
        for iii = 1 : size(box, 1)
            rectangle('Position', box(iii,:), 'EdgeColor', 'y', 'LineWidth', 2);
            ts = sprintf('%.2f',s(iii)); 
            text(double(box(iii,1)-5),double(box(iii,2)-5), ts, 'FontSize',10,'Color','g','FontWeight','bold')
        end
        drawnow;
        if exist('dumproot', 'var')
            saveas(gcf,fullfile(dumproot,[ num2str(i) '.jpg']));
        end
        waitforbuttonpress;
        fprintf('down\n');
    end
end