addpath 'C:/Users/27rut/JAABA/spaceTime/'

jd = loadAnonymous('Y:\hantman_data\jab_experiments\STA14\STA14\20230503\multibeh_STA14_20230503.jab');
nexp = numel(jd.expDirNames);

for i=1:nexp
    exp = jd.expDirNames{i};
    disp(fullfile(exp,'features.mat'))
    if exist(fullfile(exp,'features.mat'),'file')
        delete(fullfile(exp,'features.mat'))
    end
    cuda2matlab_features('indir',exp);
end

%% check if cuda features match matlab features.mat 
for i=1:nexp
    exp_dir = jd.expDirNames{i};
    disp(exp_dir)
    feat_front = readtable(fullfile(exp_dir,'hoghof_avg_front_biasjaaba.csv'));
    feat_side = readtable(fullfile(exp_dir, 'hoghof_avg_side_biasjaaba.csv'));
    featsz_side = size(feat_side,2);
    featsz_front = size(feat_front,2);
    fprintf('Features size front %d\n',featsz_front);
    fprintf('Features size side %d\n',featsz_side);
    matfeat = load(fullfile(exp_dir,"features.mat"));
    matfeat = matfeat.curFeatures;
    fprintf('Feature size matlab %d\n',size(matfeat,2));
    assert(size(matfeat,2) == (featsz_side + featsz_front));

    % side hoghof
    side_hofm = matfeat(:,1:featsz_side/2);
    side_hofc = feat_side{:,featsz_side/2+1:featsz_side}; 
    side_hogm = matfeat(:,(featsz_side/2 + featsz_front/2)+1:(featsz_side/2 + featsz_front/2)+featsz_side/2);
    side_hogc = feat_side{:,1:featsz_side/2};

    % front hoghof
    front_hogm=matfeat(:,(featsz_side+featsz_front/2)+1:(featsz_side+featsz_front));
    front_hofm=matfeat(:,featsz_side/2+1:(featsz_side/2 + featsz_front/2));
    front_hofc=feat_front{:,featsz_front/2+1:featsz_front}; 
    front_hogc=feat_front{:,1:featsz_front/2};


    subplot(2,2,1)
    plot(side_hogc,side_hogm);
    subplot(2,2,2)
    plot(side_hofc,side_hofm);
    subplot(2,2,3)
    plot(front_hofc,front_hofm);
    subplot(2,2,4)
    plot(front_hogc,front_hogm);
    disp('Stop');
end
