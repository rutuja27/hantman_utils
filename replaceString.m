function replaceString(output_dir,txt_file_name)

    exp_list = importdata(fullfile(output_dir,txt_file_name));
    numexp = size(exp_list,1);
    new_exp_list = cell(numexp,1);
    for i=1:numexp
       new_exp_list(i) = strrep(exp_list(i),'\','\\');

    end
    disp(new_exp_list)
    writecell(new_exp_list, fullfile(output_dir,'hantman_list_modified.txt'))
end
