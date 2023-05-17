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


