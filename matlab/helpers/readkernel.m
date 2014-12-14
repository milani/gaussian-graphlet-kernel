function [k,lk]=readkernel(kernel)
    D = importdata(kernel);
    k = D.data;
    llk = D.textdata;
    llk = llk(2:size(llk,1));
    lk = [];
    for i=1:size(llk,1)
        tmp = strsplit(char(llk(i)),'-');
        lk(i) = char(tmp(2));
    end
end