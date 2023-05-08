
vid_obj = VideoReader('Y:\patilr\realtime_classifier_test\movie_comb.avi');
numFrames=vid_obj.NumFrames;
trx = load('Y:\patilr\realtime_classifier_test\BIASJAABA_movies\trx.mat');

trx_obj = trx.trx;
newtrx_obj = trx;
numtrxpts = numel(trx.trx);

for i=1:numtrxpts

    newtrx_obj.trx(i).x = ones(1,numFrames).*trx_obj(i).x(1);
    newtrx_obj.trx(i).y = ones(1,numFrames).*trx_obj(i).y(1);
    newtrx_obj.trx(i).a = ones(1,numFrames).*trx_obj(i).a(1);
    newtrx_obj.trx(i).b = ones(1,numFrames).*trx_obj(i).b(1);
    newtrx_obj.trx(i).theta = ones(1,numFrames).*trx_obj(i).theta(1);
    newtrx_obj.trx(i).x_mm = ones(1,numFrames).*trx_obj(i).x_mm(1);
    newtrx_obj.trx(i).y_mm = ones(1,numFrames).*trx_obj(i).y_mm(1);
    newtrx_obj.trx(i).a_mm = ones(1,numFrames).*trx_obj(i).a_mm(1);
    newtrx_obj.trx(i).b_mm = ones(1,numFrames).*trx_obj(i).b_mm(1);
    newtrx_obj.trx(i).theta_mm = ones(1,numFrames).*trx_obj(i).theta_mm(1);
    newtrx_obj.trx(i).dt = ones(1,numFrames).*trx_obj(i).dt(1);
    newtrx_obj.trx(i).timestamps = ones(1,numFrames).*trx_obj(i).dt(1);
    for j=2:numFrames
        newtrx_obj.trx(i).timestamps(j) = newtrx_obj.trx(i).timestamps(j-1) + newtrx_obj.trx(i).dt(1);
    end
    newtrx_obj.trx(i).nframes = numFrames;
    newtrx_obj.trx(i).endframe = numFrames;
    disp(numel(newtrx_obj.trx(i).x))
    
end   

save('Y:\patilr\realtime_classifier_test\BIASJAABA_movies\trx_modified.mat', '-struct', 'newtrx_obj');


