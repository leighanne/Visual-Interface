function palm_area = processPalm( palm,erode_param )
% read the image, and capture the dimensions
height = size(palm,1);
width = size(palm,2);

% initialize the output images
bin = zeros(height,width);

% convert the image from RGB to YCbCr
img_ycbcr = rgb2ycbcr(palm);
Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);

% detect Skin
[r,c,v] = find(Cb>=67 & Cb<=137 & Cr>=133 & Cr<=173);
numind = size(r,1);

% mark skin pixels
for i=1:numind
    bin(r(i),c(i)) = 1;
end

se = strel('disk',8,8);
for i=1:erode_param
    bin = imerode(bin,se);
end

palm_area = sum(sum(bin));
end