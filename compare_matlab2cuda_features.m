addpath 'C:/Users/27rut/JAABA/spaceTime/'

exp_dir_matlab = 'Y:\hantman_data\jab_experiments\STA14\STA14\20230503_matlab\STA14_20230503_142341\';
exp_dir_cuda = 'Y:\hantman_data\jab_experiments\STA14\STA14\20230503\STA14_20230503_142341\';
mat_feat = load(fullfile(exp_dir_matlab, "features.mat"));
cuda_feat = load(fullfile(exp_dir_cuda, "features.mat"));

%%
mat_feat = mat_feat.curFeatures;
cuda_feat = cuda_feat.curFeatures;

feat_size = size(mat_feat,2);

figure(1)
diff_hof = abs(cuda_feat(:,1:feat_size/2)-mat_feat(:,1:feat_size/2));
min_val_hof = min(min(diff_hof));
max_val_hof = max(max(diff_hof));
clims_hof = [min_val_hof,max_val_hof];
imagesc(diff_hof', clims_hof)
colorbar
set(gca, 'YDir','normal')
xlabel('Frames')
ylabel('Feature differences')

figure(2)
diff_hog = abs(cuda_feat(:,feat_size/2:feat_size)-mat_feat(:,feat_size/2:feat_size));
min_val_hog = min(min(diff_hog));
max_val_hog = max(max(diff_hog));
clims_hog = [min_val_hog,max_val_hog];
imagesc(diff_hog', clims_hog)
colorbar
set(gca, 'YDir','normal')
xlabel('Frames')
ylabel('Feature differences')