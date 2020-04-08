image=double(imread('capture200.jpg'))/255;
img=rgb2gray(image);
moyenne=median(median(img));
 for i=1:size(img,1)
    for j=1:size(img,2)
        if img(i,j)>moyenne
            img(i,j)=1;%img(i,j);
        else 
            img(i,j)=0;
        end
    end
end
img=imopen(img,strel('disk',3));

%%
% Module du gradient
[gm,gh,gv]=tse_imgrad(img,'gog',2);
g=sqrt(gh.*gh+gv.*gv);
figure(4),imshow(g,[],'ColorMap',jet);

% LPE du gradient 
lpe=watershed(g);
lpe=imerode(lpe,strel('disk',1));
figure(6),imshow(lpe==0,[]);

%% 
lpe=tse_imsplitobjects(logical(img));
imshow(lpe,[]);

