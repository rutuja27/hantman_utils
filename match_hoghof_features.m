psize = 40;
ncells = 10;
nbins = 8;
w = 352;
h = 260;

npatches_side = 3;
npatches_front=2;
npatches=npatches_side+npatches_front;


side_dim = ((ncells*psize/psize)*((ncells*psize*npatches_side)/psize)*nbins);
front_dim = ((ncells*psize/psize)*((ncells*psize*npatches_front)/psize)*nbins);
hog_dim = ((ncells*psize/psize)*((ncells*psize*npatches)/psize)*nbins);
hof_dim = ((ncells*psize/psize)*((ncells*psize*npatches)/psize)*nbins);

side_hist_shape = [((ncells*psize*npatches_side)/psize) (ncells*psize/psize) nbins];
front_hist_shape = [((ncells*psize*npatches_front)/psize) (ncells*psize/psize) nbins];

num_frame=2;

%%  matlab hoghof M274

feat = load('U:\hantman_data\jab_experiments\M274Vglue2_Gtacr2_TH\20180814\M274_20180814_v002\features.mat');
featm = feat.curFeatures;

featm_frm1 = featm(num_frame,:);
Fm = featm_frm1(1:hof_dim);
Hm = featm_frm1(hog_dim+1: 2*hog_dim);

%% cuda offline c++ hoghof features

flow_sidec = hdf5read('C:\Users\27rut\BIAS\misc\classifier_trials\gnd_truth\hoghof_features_gnd\hoghof_org','hof_side');
hog_sidec = hdf5read('C:\Users\27rut\BIAS\misc\classifier_trials\gnd_truth\hoghof_features_gnd\hoghof_org','hog_side');
flow_frontc = hdf5read('C:\Users\27rut\BIAS\misc\classifier_trials\gnd_truth\hoghof_features_gnd\hoghof_org','hof_front');
hog_frontc = hdf5read('C:\Users\27rut\BIAS\misc\classifier_trials\gnd_truth\hoghof_features_gnd\hoghof_org','hog_front');


%transpose the bins
flow_sidec = flow_sidec(:,num_frame);
flow_sidec = reshape(flow_sidec,side_hist_shape);
flow_sidec = permute(flow_sidec,[2 1 3]);

hog_sidec = hog_sidec(:,num_frame);
hog_sidec =  reshape(hog_sidec,side_hist_shape);
hog_sidec = permute(hog_sidec,[2 1 3]);

flow_frontc = flow_frontc(:,num_frame);
flow_frontc = reshape(flow_frontc,front_hist_shape);
flow_frontc = permute(flow_frontc,[2 1 3]);

hog_frontc = hog_frontc(:,num_frame);
hog_frontc = reshape(hog_frontc,front_hist_shape);
hog_frontc = permute(hog_frontc,[2 1 3]);

Fc = [flow_sidec flow_frontc];
Hc = [hog_sidec hog_frontc];

Fc = reshape(Fc,[1 hof_dim]);
Hc = reshape(Hc,[1 hog_dim]);

%% cuda offline window averaged hoghof features

featc = load('C:\Users\27rut\BIAS\misc\classifier_trials\gnd_truth\hoghof_features_gnd\features_cuda_averaged.mat');
featc_avg = featc.curFeatures;

featc_frm1 = featc_avg(2,:);
Fc_avg = featc_frm1(1:hof_dim);
Hc_avg = featc_frm1(hog_dim+1: 2*hog_dim);

%%

subplot(2,1,1)
plot(Fm, Fc_avg, '.')
xlabel('MATLAB')
ylabel('CUDA')
title('HOF')

subplot(2,1,2)
plot(Hm,Hc_avg,'.')
title('HOG')
xlabel('MATLAB')
ylabel('CUDA')
