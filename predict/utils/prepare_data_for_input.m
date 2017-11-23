function input = prepare_data_for_input(root, list_pos, box_pos, pts_pos, list_neg, box_neg, ignore_neg, param)
    input = cell(length(param.gpu_id), 1);
    input(1:length(param.pos_gpu)) = prepare_pos_data_for_input( root, list_pos, box_pos, pts_pos, param );
    input(length(param.pos_gpu)+1:end) = prepare_neg_data_for_input( root, list_neg, box_neg, ignore_neg, param );
end