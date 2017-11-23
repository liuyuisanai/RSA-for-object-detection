function plot_result( list, parsed, gt, param, topk )
    assert(length(list) == length(parsed));
    if ~exist('topk', 'var')
        topk = 300;
    end
    for i = 1 : length(list)
        close all;
        clear annotation annotation_gt;
        fprintf('%d...', i);
        if ischar(list{i})
            I = imread(fullfile(param.dataset_root, list{i}));
        else
            I = list{i};
        end
        box = round(parsed(i).box);
        box_t = [box(:, 1:2) box(:, 3)-box(:, 1) box(:, 4)-box(:, 2)];
        score = parsed(i).cls_score;
        [~, it_t] = sort(score, 'descend');
        it_t = it_t(1:min(numel(it_t), topk));
        box = box(it_t,:);
        box_t = box_t(it_t, :);
        
        score = score(it_t, :);
%         for j = 1 : size(box, 1)
%             annotation{j} = ['Score:' num2str(score(j))];
%         end
%         I = insertObjectAnnotation(I, 'rectangle', box_t, annotation, 'TextBoxOpacity',0.4,'FontSize',12, 'Color', 'red');
        imshow(I);
        if nargin > 2
            % for box
            box_gt = round(gt.bbox{i});
            if ~isempty(box_gt)
                box_gt_t = [box_gt(:, 1:2) box_gt(:, 3)-box_gt(:, 1) box_gt(:, 4)-box_gt(:, 2)];
            else
                box_gt_t = [];
            end
%             for j = 1 : size(box_gt, 1)
%                 annotation_gt{j} = ['GT'];
%             end
%             I = insertObjectAnnotation(I, 'rectangle', box_gt_t, annotation_gt, 'TextBoxOpacity',0.6,'FontSize',12, 'Color', 'green');
            imshow(I);
           
            % draw my rects
            rects_t = box_t;
            for t = 1 : size(rects_t, 1)
                rectangle('Position', rects_t(t,:), 'EdgeColor', 'y', 'LineWidth', 1);
            end
                
            % draw gt rects
            for j = 1 : size(box_gt_t, 1)
                rectangle('Position', box_gt_t(j,:), 'EdgeColor', 'g', 'LineWidth', 1);
            end
        end
        
        waitforbuttonpress;
    end
end

