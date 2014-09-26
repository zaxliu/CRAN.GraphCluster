function [ front ] = extractFrontier( data )
% Extract bottom-left frontier points, all data size 2*n, data>0
front = [];

[m,n] = size(data); % assert data size = 2 x n
if m~=2, return, end % check data size
if n==1
    front = data;
    return;
end

flag = zeros(1,n);  % indicate which column in data is frontier
for i = 1:n
    data1 = data(:,i);
    if flag(i)==1, continue, end;
    for j = 1:n
        if i==j, continue, end;
        data2 = data(:,j);
        theta = [data1(2),1;data2(2),1]\[-data1(1);-data2(1)];
        theta = [1;theta];
        prod = theta.'*[data;ones(1,n)];
        zeroProd = theta(3);
%         plot(data(1,:),data(2,:),'+');hold on;
%         plot(data1(1),data1(2),'ro');
%         plot(data2(1),data2(2),'ro');hold off;
%         disp(prod);
%         pause;
        if (all(prod>-10e-5)&&zeroProd<10*eps) || (all(prod<10e-5)&&zeroProd>-10*eps)
            flag(i) = 1;
            flag(j) = 1;
            break;
        end

    end
end
front = data(:,flag==1);
end

