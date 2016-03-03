function augmented_Reality_Image
figure
im1 = imread('C:\Users\J.Suresh kumar\Desktop\2nd sem\Vision\assign 3\Assignment 3\images12.png');
clipart = imread('C:\Users\J.Suresh kumar\Desktop\2nd sem\Vision\assign 3\Clipart\2.jpg');

H1 = [   0.9892,    0.0895,   32.0409;
        0.0166,   -0.9086,  232.3516;
        0.0000,    0.0002,    0.5542; ];
H2 =  [1.1222    0.0396   58.8378
    0.1602   -0.9504  207.6721
    0.0006    0.0002    0.4820];
H3 = [0.7114    0.0756   60.7810
   -0.1932   -0.9008  250.7110
   -0.0006    0.0002    0.6282];
H4 = [-0.8787   -0.3063  -59.1784
    0.0055    0.3945 -140.7587
   -0.0000   -0.0009   -0.5008];
HG = H4;

clipart = imresize(clipart, .45);
clipart = rot90(clipart);
clipart = flip(clipart,1);
clipart = flip(clipart,2);
clipartgray = rgb2gray(clipart);
m = size(clipart,1);
n = size(clipart,2);
for i = 1:m
    for j = 1:n
        k = HG * [i;j;1;];
        p = floor(k(1,:)/k(3,:));
        q = floor(k(2,:)/k(3,:));
        r = ceil(k(1,:)/k(3,:));
        s = ceil(k(2,:)/k(3,:));
        if clipartgray(i,j) < 230
        im1(q,p,:) = clipart(i,j,:);
        im1(q,r,:) = clipart(i,j,:);
        im1(s,p,:) = clipart(i,j,:);
        im1(s,r,:) = clipart(i,j,:);
        end
    end
end
imshow(im1)


