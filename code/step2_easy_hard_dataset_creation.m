f = csvread('sample_dataset_20.csv', 1, 0);
f = f(randperm(size(f,1)),:);


f_joined = joinNominal(f);

%divide in subsets for each wilderness area and soil types
%for each area
results = zeros(4*40, 5);
for w = 1:4
    results((w-1)*40 + 1:w*40, 1) = w;
    for s = 1:40
        results(s+((w-1)*40), 2) = s;
    end
end
c_nosample = 0;
c_sameclass = 0;
for w = 1:4
    w_samples_index = (f_joined(:, 11) == w);
    w_dataset = f_joined(w_samples_index, 1:10);
    w_labels = f_joined(w_samples_index, 13);
    
    fw = [w_dataset, f_joined(w_samples_index, 12), w_labels];
    for s = 1:40
        disp(s);
        s_samples_index = (fw(:, 11) == s);
        s_dataset = fw(s_samples_index, 1:10);
        s_labels = fw(s_samples_index, 12);
        
        r_i = s+((w-1)*40);
        
        if (isempty(s_dataset))
            c_nosample = c_nosample + 1;
            results(r_i, 5:size(results, 2)) = 1;
            continue
        end

        results(r_i, 3) = size(s_dataset, 1);
        
        classes_u = unique(s_labels);
        if (isempty(classes_u))
            results(r_i, 5:size(results, 2)) = 1;
            continue
        end
        results(r_i, 4) = size(classes_u, 1);
        if size(classes_u, 1) == 1
            c_sameclass = c_sameclass + 1;
            results(r_i, 5:size(results, 2)) = 1;
            continue
        end
        for i = 1: size(classes_u, 1)
            index_i = (s_labels == classes_u(i));
            s_labels(index_i) = i;
        end
        results = testnormpca(results, r_i, s_dataset, s_labels);
    end
end

easy_area_soil_index = (results(:,5) > 0.2);
easy_area_soil = results(easy_area_soil_index,1:2);
easy_area_soil(:,3) = (easy_area_soil(:,1).*100) + easy_area_soil(:,2);
allsamples = csvread('covtype.csv', 1, 0);
join_allsamples = joinNominal(allsamples);
join_allsamples(:,14) = (join_allsamples(:,11).*100) + join_allsamples(:,12);
allsamples_easyindex = logical(sum((join_allsamples(:,14) == easy_area_soil(:,3)'), 2)); 
easy_dataset = join_allsamples(allsamples_easyindex, 1:13);
hard_dataset = join_allsamples(~allsamples_easyindex, 1:13);
csvwrite('dataset_easy.csv', easy_dataset);
csvwrite('dataset_hard.csv', hard_dataset);

function[f_joined] = joinNominal(f)
    labels = f(:,55);
    %join areas and soil types
    areas_bool = f(:, 11:14);
    areas = zeros(size(f,1), 1);
    for i = 1:4
        areas(areas_bool(:,i)==1, 1) = i;
    end

    soil_bool = f(:, 15:54);
    soils = zeros(size(f,1), 1);
    for i = 1:40
        soils(soil_bool(:,i)==1, 1) = i;
    end

    f_joined = [f(:,1:10), areas, soils, labels];
end

function[results] = testnormpca(results, r_i, i_dataset, i_labels)
    dataset = normalize(i_dataset);
    %remove NaN columns
    dataset( :, all(isnan(dataset), 1)) = [];
    %PCA
    [coeff, scores, latent] = pca(dataset);
    selected_features = latent > 1;
    selected_pc = coeff(:, 1:sum(selected_features));
    reduced_dataset = dataset * selected_pc;
    u = size(unique(i_labels), 1);
    cm = clusterdata(reduced_dataset,'Linkage','average','Maxclust',u);
    nmi = nmi_calculator(i_labels', cm', u, u);
    results(r_i, 5) = nmi;
end