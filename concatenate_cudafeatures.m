function feat = concatenate_cudafeatures(infile_side, infile_front)

    hoghof_side = readtable(infile_side);
    hoghof_front = readtable(infile_front);

    feat_size_side = size(hoghof_side,2);
    feat_size_front = size(hoghof_front,2);

    hogs = hoghof_side{:,1:feat_size_side/2};
    hofs = hoghof_side{:,(feat_size_side/2)+1:feat_size_side};

    hogf = hoghof_front{:,1:feat_size_front/2};
    hoff = hoghof_front{:,(feat_size_front/2)+1:feat_size_front};

    feat = [hofs, hoff, hogs, hogf];
end