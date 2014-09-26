% data = [1 0 1;0 1 1];
rng(3,'twister');
data = randn(2,100)+100;
[ front ] = extractFrontier( data );
plot(data(1,:),data(2,:),'+');hold on;
front = sortrows(front',[1])';
plot(front(1,:),front(2,:),'ro-');