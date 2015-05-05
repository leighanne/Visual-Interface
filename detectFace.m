function [face, palm] = detectFace( input_img )
%To detect Face
FDetect = vision.CascadeObjectDetector;

%Read the input image
I = imread(input_img);

%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);

%face part(s) in the input img
faceSet = cell(size(BB,1));

figure,
imshow(I); hold on

face_edge = 0;

for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
    up_left_c = BB(i,1); col_span = BB(i,3);
    up_left_r = BB(i,2); row_span = BB(i,4);
    facePic = I(up_left_r:up_left_r+row_span-1,up_left_c:up_left_c+col_span-1,:);
    if i==size(BB,1)
        face_edge = up_left_c+col_span-1;
    end
    faceSet{i} = facePic;
end
face = faceSet{size(faceSet)};
palm = I(:,face_edge:size(I,2),:);
title('Face Detection');
hold off;
end