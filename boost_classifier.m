function scr = boost_classifier(cls,feat,exp_dir)

numWkCls = size(cls.dim,2);
dim = cls.dim;
tr = cls.tr;
alpha = cls.alpha;
dir = cls.dir;
scr=0;
scores=zeros(1,numWkCls); 

for i=1:numWkCls
    if i==73
        fprintf("Dir : %d, thres : %f, " + ...
            "alpha : %f, dim : %d , scr before : %f , feat val : %f", ...
            dir(i), tr(i), alpha(i), dim(i), scr, feat(dim(i)))
    end
    if(dir(i) > 0)
        if feat(dim(i)) > tr(i)
           addscores = 1;
        else
            addscores = -1;
        end
        if i==73
            fprintf("*%.7f: %.7f scr intermediate" ,addscores,scr);cuda
        end   
        addscores = addscores * alpha(i);
        scr = scr + addscores;
    else
        if feat(dim(i)) <= tr(i)
           addscores = 1;
        else
            addscores = -1;
        end
        if i==73
            fprintf("%.7f: %.7f scr intermediate" ,addscores,scr);
        end   
        addscores = addscores * alpha(i);
        scr = scr + addscores;
    end
    if i == 73
        fprintf(" Scr after : %f", scr)
    end
    scores(i) = scr;
end
save(fullfile(exp_dir,"scores.mat"), 'scores');
