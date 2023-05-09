flow_side1 = hdf5read('C:\Users\27rut\BIAS\build\Release\hoghof_old','hof_side');
hog_side1 = hdf5read('C:\Users\27rut\BIAS\build\Release\hoghof_old','hog_side');
flow_front1 = hdf5read('C:\Users\27rut\BIAS\build\Release\hoghof_old','hof_front');
hog_front1 = hdf5read('C:\Users\27rut\BIAS\build\Release\hoghof_old','hog_front');

flow_side2 = hdf5read('C:\Users\27rut\BIAS\build\Release\hoghof','hof_side');
hog_side2 = hdf5read('C:\Users\27rut\BIAS\build\Release\hoghof','hog_side');
flow_front2 = hdf5read('C:\Users\27rut\BIAS\build\Release\hoghof','hof_front');
hog_front2 = hdf5read('C:\Users\27rut\BIAS\build\Release\hoghof','hog_front');

subplot(2,2,1)
plot(flow_side1, flow_side2,'.')
title('Flow side')
subplot(2,2,2)
plot(hog_side1, hog_side2,'.')
title('Hog side')
subplot(2,2,3)
plot(flow_front1, flow_front2,'.')
title('flow front')
subplot(2,2,4)
plot(hog_front1, hog_front2,'.')
title('hog front')