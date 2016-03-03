function calib_2D

im1 = imread('C:\Users\J.Suresh kumar\Desktop\2nd sem\Vision\assign 3\Assignment 3\images2.png');
im2 = imread('C:\Users\J.Suresh kumar\Desktop\2nd sem\Vision\assign 3\Assignment 3\images9.png');
im3 = imread('C:\Users\J.Suresh kumar\Desktop\2nd sem\Vision\assign 3\Assignment 3\images12.png');
im4 = imread('C:\Users\J.Suresh kumar\Desktop\2nd sem\Vision\assign 3\Assignment 3\images20.png');

x1 = [0, 270, 0 270;
      210, 210, 0, 0;
      1, 1, 1, 1;];

x2 = [85, 528, 59, 541; 
        69, 75, 421, 428; 
        1, 1, 1, 1;];
    
y2 =  [131, 559, 123, 574;
         14, 71, 432, 398;
         1, 1, 1, 1;];

z2 = [108, 517, 98, 536;
      87, 16, 401, 420;
      1, 1, 1, 1;];
  
w2 = [173, 519, 118, 591;
      81, 76, 283, 278;
      1, 1, 1, 1;];
  
H1 = homography2d(x1,x2)
H2 = homography2d(x1,y2)
H3 = homography2d(x1,z2)
H4 = homography2d(x1,w2)

v1 = [calc(H1,1,2);
      calc(H1,1,1) - calc(H1,2,2)];
v2 = [calc(H2,1,2);
      calc(H2,1,1) - calc(H2,2,2)];
v3 = [calc(H3,1,2);
      calc(H3,1,1) - calc(H3,2,2)];
v4 = [calc(H4,1,2);
      calc(H4,1,1) - calc(H4,2,2)];

  V = [v1; v2; v3; v4;];
[U, S, V] = svd(V);
be = V(:,6);
v0 = (be(2)*be(4) - be(1)*be(5))/(be(1)*be(3)-be(2)*be(2))
d = be(6) - (be(4)*be(4) + v0*(be(2)*be(4) - be(1)*be(5)))/be(1)
a = sqrt(abs(d/be(1)))
b = sqrt(d*be(1)/(be(1)*be(3)-be(2)*be(2)))
c = -1 * be(2)*a*a*b/d
u0 = (c*v0/a) - (be(4)*a*a/d)

B = [be(1), be(2), be(4); be(2), be(3), be(5); be(4), be(5), be(6);]
A = [a, c, u0; 0, b, v0; 0, 0, 1;];

r1 = d*inv(A)*H1(:,1);
r2 = d*inv(A)*H1(:,2);
r3 = r1 .* r2;
R1 = [r1, r2, r3]
t1 = d*inv(A)*H1(:,3)

r1 = d*inv(A)*H2(:,1);
r2 = d*inv(A)*H2(:,2);
r3 = r1 .* r2;
R2 = [r1, r2, r3]
t2 = d*inv(A)*H2(:,3)

r1 = d*inv(A)*H3(:,1);
r2 = d*inv(A)*H3(:,2);
r3 = r1 .* r2;
R3 = [r1, r2, r3]
t3 = d*inv(A)*H3(:,3)

r1 = d*inv(A)*H4(:,1);
r2 = d*inv(A)*H4(:,2);
r3 = r1 .* r2;
R4 = [r1, r2, r3]
t4 = d*inv(A)*H4(:,3)

for i =1 : 4
   R = eval(strcat('R',int2str(i)));
   [UU , SS , VV ] = svd (R) ;
   R = UU * VV;
   R' * R;
end


%Computing p_approx and plotting on image
p1_approx = H1 * x1;
p1_approx = bsxfun(@rdivide, p1_approx, p1_approx(3,:));
p2_approx = H2 * x1;
p2_approx = bsxfun(@rdivide, p2_approx, p2_approx(3,:));
p3_approx = H3 * x1;
p3_approx = bsxfun(@rdivide, p3_approx, p3_approx(3,:));
p4_approx = H4 * x1;
p4_approx = bsxfun(@rdivide, p4_approx, p4_approx(3,:));

 figure
 imagesc(im1)
 hold on;
 plot(p1_approx(1,:),p1_approx(2,:),'o');
 title('FIgure 1: Projected Grid Corners for images2');
% figure
% imagesc(im2)
% hold on;
% plot(p2_approx(1,:),p2_approx(2,:),'o');
% title('FIgure 1: Projected Grid Corners for images9');
% figure
% imagesc(im3)
% hold on;
% plot(p3_approx(1,:),p3_approx(2,:),'o');
% title('FIgure 1: Projected Grid Corners for images12');
% figure
% imagesc(im4)
% hold on;
% plot(p4_approx(1,:),p4_approx(2,:),'o');
% title('FIgure 1: Projected Grid Corners for images20');

% Plotting Harris corners
[cim1, r1, c1, rsubp1, csubp1] = harris(rgb2gray(im1), 2, 500, 2, 0);
[cim2, r2, c2, rsubp2, csubp2] = harris(rgb2gray(im2), 2, 500, 2, 0);
[cim3, r3, c3, rsubp3, csubp3] = harris(rgb2gray(im3), 2, 500, 2, 0);
[cim4, r4, c4, rsubp4, csubp4] = harris(rgb2gray(im4), 2, 500, 2, 0);

%Computing p_correct and plotting on image
corners1 = [csubp1, rsubp1];
corners2 = [csubp2, rsubp2];
corners3 = [csubp3, rsubp3];
corners4 = [csubp4, rsubp4];
p1 = [p1_approx(1,:)', p1_approx(2,:)'];
p2 = [p2_approx(1,:)', p2_approx(2,:)'];
p3 = [p3_approx(1,:)', p3_approx(2,:)'];
p4 = [p4_approx(1,:)', p4_approx(2,:)'];

d1 = dist2(p1, corners1);
d2 = dist2(p2, corners2);
d3 = dist2(p3, corners3);
d4 = dist2(p4, corners4);

[random, idx1] = min(d1, [], 2);
[random, idx2] = min(d2, [], 2);
[random, idx3] = min(d3, [], 2);
[random, idx4] = min(d4, [], 2);

p1_correct = [corners1(idx1,:)';1, 1, 1, 1;];
p2_correct = [corners2(idx2,:)';1, 1, 1, 1;];
p3_correct = [corners3(idx3,:)';1, 1, 1, 1;];
p4_correct = [corners4(idx4,:)';1, 1, 1, 1;];

% figure
% imagesc(im1)
% hold on;
% plot(p1_correct(1,:),p1_correct(2,:),'o');
% title('FIgure 3: Grid Points for images2');
% figure
% imagesc(im2)
% hold on;
% plot(p2_correct(1,:),p2_correct(2,:),'o');
% title('FIgure 3: Grid Points for images9');
% figure
% imagesc(im3)
% hold on;
% plot(p3_correct(1,:),p3_correct(2,:),'o');
% title('FIgure 3: Grid Points for images12');
% figure
% imagesc(im4)
% hold on;
% plot(p4_correct(1,:),p4_correct(2,:),'o');
% title('FIgure 3: Grid Points for images20');

% Computing new Homographies
H1_new = homography2d(x1,p1_correct);
H2_new = homography2d(x1,p2_correct);
H3_new = homography2d(x1,p3_correct);
H4_new = homography2d(x1,p4_correct);

% Computing A, R and T and repeating for all images
v1_new = [calc(H1_new,1,2);
      calc(H1_new,1,1) - calc(H1_new,2,2)];
v2_new = [calc(H2_new,1,2);
      calc(H2_new,1,1) - calc(H2_new,2,2)];
v3_new = [calc(H3_new,1,2);
      calc(H3_new,1,1) - calc(H3_new,2,2)];
v4_new = [calc(H4_new,1,2);
      calc(H4_new,1,1) - calc(H4_new,2,2)];
V_new = [v1_new; v2_new; v3_new; v4_new;];

[U, S, V_new] = svd(V_new);
be_new = V_new(:,6);
v0_new = (be_new(2)*be_new(4) - be_new(1)*be_new(5))/(be_new(1)*be_new(3)-be_new(2)*be_new(2));
d_new = be_new(6) - (be_new(4)*be_new(4) + v0_new*(be_new(2)*be_new(4) - be_new(1)*be_new(5)))/be_new(1);
a_new = sqrt(abs(d_new/be_new(1)));
b_new = sqrt(d_new*be_new(1)/(be_new(1)*be_new(3)-be_new(2)*be_new(2)));
c_new = -1 * be_new(2)*a_new*a_new*b_new/d_new;
u0_new = (c_new*v0_new/a_new) - (be_new(4)*a_new*a_new/d_new);
 

B_new = [be_new(1), be_new(2), be_new(4); be_new(2), be_new(3), be_new(5); be_new(4), be_new(5), be_new(6);];
A_new = [a_new, c_new, u0_new; 0, b_new, v0_new; 0, 0, 1;];
 

r1_new = d_new*inv(A_new)*H1_new(:,1);
r2_new = d_new*inv(A_new)*H1_new(:,2);
r3_new = r1_new .* r2_new;
R1_new = [r1_new, r2_new, r3_new]
t1_new = d_new*inv(A_new)*H1_new(:,3)
 

r1_new = d_new*inv(A_new)*H2_new(:,1);
r2_new = d_new*inv(A_new)*H2_new(:,2);
r3_new = r1_new .* r2_new;
R2_new = [r1_new, r2_new, r3_new]
t2_new = d_new*inv(A_new)*H2_new(:,3)
 

r1_new = d_new*inv(A_new)*H3_new(:,1);
r2_new = d_new*inv(A_new)*H3_new(:,2);
r3_new = r1_new .* r2_new;
R3_new = [r1_new, r2_new, r3_new]
t3_new = d_new*inv(A_new)*H3_new(:,3)
 
r1_new = d_new*inv(A_new)*H4_new(:,1);
r2_new = d_new*inv(A_new)*H4_new(:,2);
r3_new = r1_new .* r2_new;
R4_new = [r1_new, r2_new, r3_new]
t4_new = d_new*inv(A_new)*H4_new(:,3)
 

[UU1_new , SS , VV1_new] = svd (R1_new);
R1_new = UU1_new * VV1_new
R1_new' * R1_new;
[UU2_new , SS , VV2_new] = svd (R2_new);
R2_new = UU2_new * VV2_new
R2_new' * R2_new;
[UU3_new , SS , VV3_new] = svd (R3_new);
R3_new = UU3_new * VV3_new;
R3_new' * R3_new;
[UU4_new , SS , VV4_new] = svd (R4_new);
R4_new = UU4_new * VV4_new;
R4_new' * R4_new;

% Error Reprojection
err_reprojection1 = diag(dist2(p1_approx(1:2,:)', p1_correct(1:2,:)'));
err_reprojection2 = diag(dist2(p2_approx(1:2,:)', p2_correct(1:2,:)'));
err_reprojection3 = diag(dist2(p3_approx(1:2,:)', p3_correct(1:2,:)'));
err_reprojection4 = diag(dist2(p4_approx(1:2,:)', p4_correct(1:2,:)'));
