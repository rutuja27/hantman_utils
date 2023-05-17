function test_feat_score(exp_dir,frm)

classifier = load(exp_dir + "/json_files/multiclassifier.mat");
hoghof_side_file  = fullfile(exp_dir,"hoghof_avg_side_biasjaaba.csv");
hoghof_front_file = fullfile(exp_dir,"hoghof_avg_front_biasjaaba.csv");

feat_cuda = concatenate_cudafeatures(hoghof_side_file, hoghof_front_file);
feat_matlab = load(fullfile(exp_dir, "features.mat"));
feat_matlab = feat_matlab.curFeatures;

diff = feat_cuda(:,:) - feat_matlab(:,:);
min_diff = min(min(diff));
max_diff = max(max(diff));
fprintf("%.7f\n", min_diff);
fprintf("%.7f\n", max_diff);

feat_cuda = feat_cuda(frm,:);
feat_matlab = feat_matlab(frm,:);

lift = classifier.Lift;

%scr_cuda = boost_classifier(lift, feat_cuda);
scr_matlab = boost_classifier(lift, feat_matlab, exp_dir);
fprintf('Score matlab %f', scr_matlab)
%fprintf('Score cuda %f', scr_cuda)



