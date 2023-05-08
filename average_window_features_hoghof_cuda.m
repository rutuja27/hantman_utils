flow_sidec = hdf5read('C:\Users\27rut\BIAS\misc\classifier_trials\gnd_truth\hoghof_features_gnd\hoghof','hof_side');
hog_sidec = hdf5read('C:\Users\27rut\BIAS\misc\classifier_trials\gnd_truth\hoghof_features_gnd\hoghof','hog_side');
flow_frontc = hdf5read('C:\Users\27rut\BIAS\misc\classifier_trials\gnd_truth\hoghof_features_gnd\hoghof','hof_front');
hog_frontc = hdf5read('C:\Users\27rut\BIAS\misc\classifier_trials\gnd_truth\hoghof_features_gnd\hoghof','hog_front');

wsize=5;
psize = 40;
ncells = 10;
nbins = 8;
npatches_side = 3;
npatches_front=2;
npatches=npatches_side+npatches_front;

sz = size(flow_frontc);
numFrames = sz(2);
hog_dim = ((ncells*psize/psize)*((ncells*psize*npatches)/psize)*nbins);
hof_dim = ((ncells*psize/psize)*((ncells*psize*npatches)/psize)*nbins);
feat_size = hog_dim + hof_dim;

f1 = zeros([numFrames feat_size]); %% original features
f2 = zeros([numFrames feat_size]); %% averaged features

side_hist_shape = [((ncells*psize*npatches_side)/psize) (ncells*psize/psize) nbins];
front_hist_shape = [((ncells*psize*npatches_front)/psize) (ncells*psize/psize) nbins];

for nfrm = 1:numFrames

    %transpose the bins from c style to matlab 
    fsc = flow_sidec(:,nfrm);
    fsc = reshape(fsc,side_hist_shape);
    fsc = permute(fsc,[2 1 3]);
    
    hsc = hog_sidec(:,nfrm);
    hsc =  reshape(hsc,side_hist_shape);
    hsc = permute(hsc,[2 1 3]);
    
    ffc = flow_frontc(:,nfrm);
    ffc = reshape(ffc,front_hist_shape);
    ffc = permute(ffc,[2 1 3]);
    
    hfc = hog_frontc(:,nfrm);
    hfc = reshape(hfc,front_hist_shape);
    hfc = permute(hfc,[2 1 3]);
    
    Fc = [fsc ffc];
    Hc = [hsc hfc];
    
    Fc = reshape(Fc,[1 hof_dim]);
    Hc = reshape(Hc,[1 hog_dim]);

    f1(nfrm, :) = [Fc Hc];
end

%average window features
for nfrm=1:numFrames

    if nfrm < 3
           
      Hall = sum(f1(1:nfrm+2,hog_dim+1:feat_size))/(nfrm+2);
      Fall = sum(f1(1:nfrm+2,1:hof_dim))/(nfrm+2);    
        
    elseif nfrm >= numFrames -1 
        
      avg_factor = numFrames - (nfrm-3);
      Hall = sum(f1(nfrm-2:numFrames,hog_dim+1:feat_size))/avg_factor;
      Fall = sum(f1(nfrm-2:numFrames,1:hof_dim))/avg_factor;
        
    else
        
      Hall = sum(f1(nfrm-2:nfrm+2,hog_dim+1:feat_size))/wsize;
      Fall = sum(f1(nfrm-2:nfrm+2,1:hof_dim))/wsize; 
        
    end
    f2(nfrm,:) = [Fall Hall];
end
 curFeatures = f2;
 save('C:\Users\27rut\BIAS\misc\classifier_trials\gnd_truth\hoghof_features_gnd\features_cuda_averaged.mat' ,'curFeatures');

