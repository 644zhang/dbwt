functiondir=cd;
addpath([functiondir '/common']);
addpath([functiondir '/main']);
addpath([functiondir '/process_fun']);
%x=imread('F:\segdata\test2\t21_3.tiff');
%x=imread('F:\segdata\labeldatazxy\trainy\trainy1.tiff');
imglen=1;
bound=cell(1,imglen);
center=cell(1,imglen);
mask=cell(1,imglen);
bound_small=cell(1,imglen);%small region that's to be growning
center_small=cell(1,imglen);
mask_small=cell(1,imglen);
rmset=cell(1,imglen);
smallobj=cell(1,imglen);  %smallobjcenter that needed to be complemented
diff_small=cell(1,imglen);%seeds that are needed to be growned importantly
for ii=1:288
    %m1= imread(strcat('F:\segdata\db3\result1\db2_31_',int2str(ii),'.tiff')); 
    m= imread(strcat('/home/zxy/dbwt/dbwtimg/wt51/re_',int2str(ii-1),'.tiff')); 
    %m= imread(strcat('H:\tsy\y',int2str(91),'.tif')); 
    %m1= imread(strcat('F:\segdata\db3\result1\db2_31_',int2str(ii),'.tiff')); 
  %figure;
  %imshow(m1);

    m=255-m;
  %figure;
  %imshow(m)

%n=graythresh(m);%求阈值
%bw=im2bw(m,n);%二值化  %fcn1要取~
%figure;
%imshow(bw)
%     figure,imshow(m)
    %m(find(m==255))=0; %m==250 red first  m==125 white first
%     figure,imshow(m)
    bw=m;
    
%L = watershed(bw);
%Lrgb1 = label2rgb(L);
%figure;
%imshow(Lrgb1)   %直接做分水岭运算分割结果并不好

    bw2 = ~bwareaopen(~bw,100,8);%在8连通区域下，消除面积小于100的对象（小点）
%h=fspecial('sobel');%获得纵方向的sobel滤波算子，用于边缘提取
%fd=double(bw2);%double使数据变成双精度  

%g=sqrt(imfilter(fd,h,'replicate').^2+imfilter(fd,h','replicate').^2);  %g为梯度幅值图像  %imfilter:将原始图像A按指定的滤波器h进行滤波增强处理，增强后的图像B与A的尺寸和类型相同
%rm=imregionalmin(bw2);
%im2=imextendedmin(uint8(bw2),0.0975);%阈值要通过观察来定
%figure;
%imshow(g); %直接对梯度幅值图像进行分水岭运算会产生过分割，因此通常需要分别对前景对象和背景对象进行标记
%g2=imclose(imopen(g,strel('disk', 1,0)),strel('disk', 1,0)); %开闭运算，使图像平滑，减少噪声
%figure;
%imshow(g2)  %会出现线段连接中断，效果不太理想

    D = -bwdist(~bw2); %距离变换，
%temp=-bwdist(im2);
%Lim=watershed(temp);
%em=Lim==0;
%g2=imimposemin(g,im2|em);
%L2=watershed(g2);
%f2=bw2;f2(L2==0)=255;
  %figure,imshow(f2,[])
    mask1 = imextendedmin(D,1.5); %imextendedmin函数确定小于某阈值的极小值  %test.jpg的阈值为0.95左右较好  %fcn1.png的阈值为0.0975左右 
  %figure;
  %imshowpair(bw2,mask,'blend')
    D2 = imimposemin(D,mask1);  %修改距离变换的结果，让其只在想要的位置具有局部最小。然后进行watershed
%figure,imshow(D2)
    Ld2 = watershed(D2);
    bw3 = bw2;
    bw3(Ld2 == 0) = 0;
    [Lbw4,numbw4]=bwlabeln(bw3);%把每个连通域贴上标签,Lbw4为贴标签之后的矩阵
    stats=regionprops(bw3,'all');
    bw4 = ismember(Lbw4, find([stats.Area] >3));
    stats=regionprops(bw4,'all');
    areas=[stats.Area];
    [arearesult,areaindex]=sort(areas,'descend');
    rects=cat(1,stats.BoundingBox);
    
%     h=figure(1)
%     imshow(bw4);hold on;
%     for i=1:size(rects,1)
%    % rectangle('position',rects(i,:),'curvature',[1,1],'EdgeColor','r','facecolor','g');
%     text(stats(areaindex(i)).Centroid(1),stats(areaindex(i)).Centroid(2),'1','color','r','FontSize',5);
%     end
%     saveas(h,strcat('F:\segdata\labeldatazxy\test_pure\fcn',int2str(1),'.tiff'))
%     hold off
    zzd=zeros(length(stats),2);
    bound{ii}=zeros(length(stats),4);
    center{ii}=zeros(length(stats),2);
    mask{ii}=cell(1,length(stats));
    for i=1:length(stats)
        bound{ii}(i,:)=ceil(stats(i).BoundingBox);
        zzd(i,:)=stats(i).Centroid;
        center{ii}(i,:)=stats(i).Centroid;
        mask{ii}{i}=stats(i).Image;
    end
zzdi=zzd;
% clear zzd
% n=0;
% small=[];
% for i=1:length(stats)
%     if stats(i).Area<20
%         n=n+1;
%        for j=1:2
%             zzdi(n,j)=stats(i).Centroid(j);
%        end
%     end
% end
n=0;
small=[];
smalllocate=[];
for i=1:length(stats)
    if stats(i).Area<600
        smalllocate=[smalllocate,i];
        if stats(i).Area<10
            n=n+1;
           small=[small,i];
        end
    end
end
% h=figure()
% imshow(bw4);hold on;
% text(zzd(:,1),zzd(:,2),'1','color','r','FontSize',5);
% %saveas(h2,strcat('F:\segdata\labeldatazxy\test_pure\juhe',int2str(1),'.tiff'))
% hold off
    distance_maxtrix= pdist2(zzd,zzd,'euclidean');
    DIST=distance_maxtrix;
    distance_maxtrix(find(distance_maxtrix==0))=[];
    n=0;
    for iter=1:1
        for i=1:size(zzd,1)-1
            for j=i+1:size(zzd,1)
                if zzd(i,1)&&zzd(j,1)&&norm(zzd(i,:)-zzd(j,:))<max(distance_maxtrix)/mean(distance_maxtrix)*10
                    zzd(j,:)=[0,0];
                end
            end
        end
    end
    rm=find(zzd(:,1)==0);
    small=[small,rm'];
    small=unique(small);
    rmset{ii}=small;
    full=1:length(stats);
    diff=setdiff(full,small);%the complement set
    diff_small{ii}=setdiff(smalllocate,small);  %return values whitch are in smalllocate but not in small(need to be removed)
    zzd(find(zzd(:,1)==0),:)=[];
%     h=figure(ii)
%     imshow(bw4);hold on;
%     text(zzd(:,1),zzd(:,2),'1','color','r','FontSize',5);
%     %saveas(h,strcat('F:\segdata\labeldatazxy\test_pure\juhe',int2str(ii),'.tiff'))
%     hold off
    smallobj{ii}=center{ii}(diff_small{ii},:);
    bound_small{ii}=bound{ii}(diff,:);
    center_small{ii}=center{ii}(diff,:);
    for ij=1:length(diff)
        mask_small{ii}{ij}=mask{ii}{diff(ij)};
        
    end


    stats1=stats(diff);
    segimg=zeros(size(bw));
% %stats(rm,:)=[];
% for i=1:length(stats1)  
%     bounding=ceil(stats1(i).BoundingBox);
%     segimg(bounding(2):bounding(2)+bounding(4)-1,bounding(1):bounding(1)+bounding(3)-1)=stats1(i).Image;
% end
% figure,imshow(segimg)
% end   
%  stats1=stats;
% segimg=zeros(1792,2048);
% %stats(rm,:)=[];
% stats=mask{1};
% for i=1:length(stats)  
%     bounding=bound{1}(i,:);
%     g=i*stats{i};
%     segimg(bounding(2):bounding(2)+bounding(4)-1,bounding(1):bounding(1)+bounding(3)-1)=g;
end
% figure,imshow(segimg,[])
save('wt51.mat','bound_small','mask_small','center_small','smallobj','center','bound','rmset','mask','smallobj','diff_small');
% save('D:\\mywork\\filename.mat',v1,v2,...)
