dataset = csvread('covtype.csv', 1, 0);

class1 = dataset(find(dataset(:,55)==1), :); 
class2 = dataset(find(dataset(:,55)==2), :); 
class3 = dataset(find(dataset(:,55)==3), :); 
class4 = dataset(find(dataset(:,55)==4), :); 
class5 = dataset(find(dataset(:,55)==5), :); 
class6 = dataset(find(dataset(:,55)==6), :); 
class7 = dataset(find(dataset(:,55)==7), :); 


class1_shuffle = class1(randperm(size(class1,1)),:);
class2_shuffle = class2(randperm(size(class2,1)),:);
class3_shuffle = class3(randperm(size(class3,1)),:);
class4_shuffle = class4(randperm(size(class4,1)),:);
class5_shuffle = class5(randperm(size(class5,1)),:);
class6_shuffle = class6(randperm(size(class6,1)),:);
class7_shuffle = class7(randperm(size(class7,1)),:);

percentage = 0.2;

size1 = percentage*size(class1_shuffle, 1);
sample1 = class1_shuffle(1:size1, :);

size2 = percentage*size(class2_shuffle, 1);
sample2 = class2_shuffle(1:size2, :);

size3 = percentage*size(class3_shuffle, 1);
sample3 = class3_shuffle(1:size3, :);

size4 = percentage*size(class4_shuffle, 1);
sample4 = class4_shuffle(1:size4, :);

size5 = percentage*size(class5_shuffle, 1);
sample5 = class5_shuffle(1:size5, :);

size6 = percentage*size(class6_shuffle, 1);
sample6 = class6_shuffle(1:size6, :);

size7 = percentage*size(class7_shuffle, 1);
sample7 = class7_shuffle(1:size7, :);

sampled_all = [sample1; sample2; sample3; sample4; sample5; sample6; sample7];

csvwrite('sample_dataset_20.csv', sampled_all);

