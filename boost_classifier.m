function scr = boost_classifier(cls,feat,exp_dir, frm)

numWkCls = size(cls.dim,2);
dim = cls.dim;
tr = cls.tr;
alpha = cls.alpha;
dir = cls.dir;
scr=0;
scores=zeros(1,numWkCls); 

for i=1:numWkCls

    if(dir(i) > 0)
        
        if feat(dim(i)) > tr(i)
           addscores = 1;
        else
            addscores = -1;
        end 
        addscores = addscores * alpha(i);
        scr = scr + addscores;
    else
        if feat(dim(i)) <= tr(i)
           addscores = 1;
        else
            addscores = -1;
        end 

        addscores = addscores * alpha(i);
        scr = scr + addscores;

    end
    fprintf("Dir : %d, thres : %.16f, " + ...
    "alpha : %.16f, dim : %d , scr after : %.16f , feat val : %.16f, cls id: %d \n", ...
    dir(i), tr(i), alpha(i), dim(i), scr, feat(dim(i)), i)
end
scores(i) = scr;
save(fullfile(exp_dir,"scores_" + int2str(frm) + ".mat"), 'scores');
end

