function test_feat_score(exp_dir,classifier_filename, frm)

classifier = load(exp_dir + "/json_files/" + classifier_filename);
hoghof_side_file  = fullfile(exp_dir,"hoghof_avg_side_biasjaaba.csv");
hoghof_front_file = fullfile(exp_dir,"hoghof_avg_front_biasjaaba.csv");

feat_cuda = concatenate_cudafeatures(hoghof_side_file, hoghof_front_file);
feat_matlab = load(fullfile(exp_dir, "features.mat"));
feat_matlab = feat_matlab.curFeatures;

diff = feat_cuda(:,:) - feat_matlab(:,:);
min_diff = min(min(diff));
max_diff = max(max(diff));
fprintf("Min difference between cuda and matlab feat %.16f\n", min_diff);
fprintf("Max difference between cuda and matlab feat %.16f\n", max_diff);

feat_cuda = feat_cuda(frm,:);
feat_matlab = feat_matlab(frm,:);

lift = classifier.led1;

%scr_cuda = boost_classifier(lift, feat_cuda, exp_dir);
%fprintf('Score cuda %f', scr_cuda)

scr_matlab = boost_classifier(lift, feat_matlab, exp_dir,frm);
fprintf('Score matlab %f', scr_matlab)




