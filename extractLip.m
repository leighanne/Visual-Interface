function extractLip( face,skin_th,lip_th,win_size )
face = face(2*size(face,1)/3:size(face,1),:,:);
%use red channel to detect the skin
max_red = max(max(face(:,:,1)));
[nonSkin_r, nonSkin_c] = find(face(:,:,1)<skin_th*max_red);
for i = 1:size(nonSkin_r,1)
    face(nonSkin_r(i),nonSkin_c(i),:) = 255;
end
face = double(face);
% h(x,y)=R(x,y)/R(x,y)+G(x,y)
h = face(:,:,1)./(face(:,:,1)+face(:,:,2));
min_h = min(min(h)); max_h = max(max(h));
% k = h(x,y)-min_h/max_h-min_h
k = (h(:,:)-min_h(:,:))./(max_h(:,:)-min_h(:,:));
figure; imshow(k);hold on
k_mean = sum(sum(k))/(size(k,1)*size(k,2));
k_max = max(max(k));
k_range = k_max-k_mean;
[lip_r,lip_c] = find(k>k_mean+lip_th*k_range);
% find left and right corner of mouth
left_col = min(lip_c); right_col = max(lip_c);
[r,c] = find(lip_c==left_col); left_row = lip_r(r);
[r,c] = find(lip_c==right_col); right_row = lip_r(r);
% mouth corners usually have highest intensity
left_pix = k(left_row,left_col); max_left = max(left_pix); max_left_ind = find(left_pix==max_left);
left_row = left_row(max_left_ind); left_row = left_row(1);
right_pix = k(right_row, right_col);
max_right = max(right_pix);
max_right_ind = find(right_pix==max_right);
right_row = right_row(max_right_ind); right_row = right_row(1);

% lip middle point column
lr_dist = right_col-left_col;
% upper mid is traced from the left corner
% lower mid is traced from the right corner
left_tmp = [left_row,left_col];
while abs(left_tmp(2)-left_col)<(lr_dist/2)*0.9
    %trace to the upper_right direction
    win = k((left_tmp(1)-win_size):(left_tmp(1)-1),(left_tmp(2)+1):(left_tmp(2)+win_size));
    max_pix = max(max(win));
    [max_r,max_c] = find(win==max_pix);
    max_r = max_r(1)+left_tmp(1)-win_size;
    max_c = max_c(1)+left_tmp(2)+1;
    left_tmp = [max_r,max_c];
end
right_tmp = [right_row,right_col];
while abs(right_tmp(2)-right_col)<(lr_dist/2)*0.9
    %trace to the lower_left direction
    win = k((right_tmp(1)+1):(right_tmp(1)+win_size),(right_tmp(2)-win_size):(right_tmp(2)-1));
    max_pix = max(max(win));
    [max_r,max_c] = find(win==max_pix);
    max_r = max_r(1)+right_tmp(1)+1;
    max_c = max_c(1)+right_tmp(2)-win_size;
    right_tmp = [max_r,max_c];
end
up_mid = left_tmp;
lo_mid = right_tmp;
left_corner = [left_row,left_col];
right_corner = [right_row, right_col];
plot(left_corner(2),left_corner(1),'g*');
plot(right_corner(2),right_corner(1),'g*');
plot(up_mid(2),up_mid(1),'g*');
plot(lo_mid(2),lo_mid(1),'g*');
end

