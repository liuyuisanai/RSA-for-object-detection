function out = get_subset_of_struct(in, range, field)
    for i = 1 : length(field)
        if isfield(in, field{i});
            out.(field{i}) = in.(field{i})(range);
        end
    end
end