function calib_3D

world_coord = [2, 2, 2; -2, 2, 2; -2, 2, -2; 2, 2, -2; 2, -2, 2; -2, -2, 2; -2, -2, -2; 2, -2, -2;];
image_coord = [422, 323; 178, 323; 118, 483; 482, 483; 438, 73; 162, 73; 78, 117; 522, 117;];

%Part 1 - Draw the image points
figure;
plot(image_coord(:, 1), image_coord(:, 2), 'o');
title('Image points of cube corners');

%Part 2 & 3 - Compute P
nPoints = size(world_coord, 1);
P = zeros(2 * nPoints, 12);
for index = 1:nPoints
worldP = world_coord(index, :)';
imageP = image_coord(index, :)';
Ai = gen3rows(worldP, imageP);
row = 2 * index - 1;
P(row:row + 1, :) = Ai;
end
P

%Part 4 - Compute M
[U, S, V] = svd(P);
nCol_V = size(V, 2);
P_col = V(:, nCol_V);
M = reshape(P_col, 4, 3)'

%Part 5 - Camera Center (Extrinsic Translational parameters)
[U2, S2, V2] = svd(M);
nCol_V2 = size(V2, 2);
C = V2(:, nCol_V2);
camera_center = C(1:3) ./ C(4)

%Part 6 - Print M'
Mp = M(:,1:3);
Mp = Mp ./ Mp(3, 3)

%Part 7 - Print Rx, Theta(x) and N
cosx = Mp(3, 3) / sqrt(Mp(3, 3) * Mp(3, 3) + Mp(3, 2) * Mp(3, 2));
sinx = -Mp(3, 2) / sqrt(Mp(3, 3) * Mp(3, 3) + Mp(3, 2) * Mp(3, 2));
Rx = [ 1, 0, 0; 0, cosx, -sinx; 0, sinx, cosx;]
ax = atan(sinx ./ cosx) * 180 / pi
disp('(in degree)');
N = Mp * Rx

%Part 8 - Print Rz and Theta(z)
cosz = N(2, 2) / sqrt(N(2, 1) * N(2, 1) + N(2, 2) * N(2, 2));
sinz = -N(2, 1) / sqrt(N(2, 1) * N(2, 1) + N(2, 2) * N(2, 2));
Rz = [ cosz, -sinz, 0; sinz, cosz, 0; 0, 0, 1;]
az = atan(sinz ./ cosz) * 180 / pi
disp('(in degree)');

%Part 9 - Print K, Focal Length and Camera Center
K = N * Rz;
K = K ./ K(3, 3)
disp('Focal lengths in pixels');
fx = K(1, 1)
fy = K(2, 2)

disp('Camera center in image (pixel coordinates)');
u0 = K(1, 3)
v0 = K(2, 3)
hold on;
plot(u0, v0, '*');
text(u0 - 70, v0 - 20, 'camera center in image');
print -djpeg calibration_3D_1;






