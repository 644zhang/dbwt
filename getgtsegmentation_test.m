file=dir('/home/zxy/dbwt/testrealy/*.tiff');
file1=dir('/home/zxy/dbwt/testrealx/*.tiff');
sum={};
sum1={};
for i=1:length(file)
    sum{i}=file(i).name;
    sum1{i}=file1(i).name;
end
%%% transfer the original gt segmentation to rgb segmentation
N=256;% 2 classes
cmap=labelcolormap(256);
for i=1:length(sum)
    img=imread(strcat('/home/zxy/dbwt/testrealy/',sum{i}));
    img1=imread(strcat('/home/zxy/dbwt/testrealx/',sum1{i}));
    %figure,imshow(img/255*N,cmap);
    iy=img/255;
    %iy(end-5:end,end-5:end)=255;
    imwrite(iy,['/home/zxy/dbwt/testrealpngy/trainy',int2str(i),'.png']);
    imwrite(img1,['/home/zxy/dbwt/testrealpngx/trainx',int2str(i),'.png']);
end
save('/home/zxy/deeplabnew/DeepLab-Context2/matlab/my_script/cmap.mat','cmap');

