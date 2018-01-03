imgfilepath='/home/zxy/dbwt/cropxpng/';
gtfilepath='/home/zxy/dbwt/cropypng/';
timgfilepath='/home/zxy/dbwt/testrealpngx/';
tgtfilepath='/home/zxy/dbwt/testrealpngy/';
txtsavepath='/home/zxy/deeplabnew/DeepLab-Context2/voc12/list/';  
trainval_percent=1;%trainval
train_percent=0.8;%train
  
%%  
imgfile=dir(imgfilepath);  %trainval
gtfile=dir(gtfilepath);  %trainval
timgfile=dir(timgfilepath);  %test
tgtfile=dir(tgtfilepath);  %trainval
numOfimg=length(imgfile)-2;%trainvalnum
tnumOfimg=length(timgfile)-2;% testnum
trainval=sort(randperm(numOfimg,floor(numOfimg*trainval_percent)));  
test=randperm(tnumOfimg);
trainvalsize=length(trainval);
train=sort(trainval(randperm(trainvalsize,floor(trainvalsize*train_percent))));  
val=sort(setdiff(trainval,train));  
  
ftrainval=fopen([txtsavepath 'trainval.txt'],'w');  
ftest=fopen([txtsavepath 'test.txt'],'w');  
ftrain=fopen([txtsavepath 'train.txt'],'w');  
fval=fopen([txtsavepath 'val.txt'],'w');

ftrainval_id=fopen([txtsavepath 'trainval_id.txt'],'w');  
ftest_id=fopen([txtsavepath 'test_id.txt'],'w'); 
ftesty_id=fopen([txtsavepath 'testy_id.txt'],'w');
ftrain_id=fopen([txtsavepath 'train_id.txt'],'w');  
fval_id=fopen([txtsavepath 'val_id.txt'],'w');

for i=1:tnumOfimg  
    fprintf(ftest,'%s\n',strcat('/testrealpngx/',timgfile(i+2).name));
    fprintf(ftest_id,'%s\n',timgfile(i+2).name(1:end-4));
    fprintf(ftesty_id,'%s\n',tgtfile(i+2).name(1:end-4));
end  
fclose(ftest);  
fclose(ftest_id);
fclose(ftesty_id);
for i=1:numOfimg  
    fprintf(ftrainval,'%s',strcat('/cropxpng/',imgfile(i+2).name));
    fprintf(ftrainval,'%s\n',[' ','/cropypng/',gtfile(i+2).name]);
    fprintf(ftrainval_id,'%s\n',imgfile(i+2).name(1:end-4));
    
    if ismember(i,train)  
       fprintf(ftrain,'%s',strcat('/cropxpng/',imgfile(i+2).name));
       fprintf(ftrain,'%s\n',[' ','/cropypng/',gtfile(i+2).name]); 
       fprintf(ftrain_id,'%s\n',imgfile(i+2).name(1:end-4));
    else  
       fprintf(fval,'%s',strcat('/cropxpng/',imgfile(i+2).name));
       fprintf(fval,'%s\n',[' ','/cropypng/',gtfile(i+2).name]);
       fprintf(fval_id,'%s\n',imgfile(i+2).name(1:end-4));
    end  
end  
fclose(ftrainval);  
fclose(ftrain);  
fclose(fval);  
fclose(ftrainval_id);  
fclose(ftrain_id);  
fclose(fval_id);  

