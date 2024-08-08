function [c] = hierarchical_clustering(x, sigma, nClusters)
    [datasize, dimension] = size(x);
    c = zeros(1,datasize);
    cm = zeros(nClusters,dimension);

    %Creation of first cluster
    %m = number of current cluster
    m = 1;
    x1 = x(1,:);
    cm(1,:) = x1;
    c(1) = 1;

    for i = 2:datasize
        if (rem(i,1000)==0)
            disp(i);
        end 
        xi = x(i,:);
        [minDistance,tocluster] = min(pdist2(xi,cm(1:m,:)));
        %disp(minDistance);
        if ((minDistance > sigma) && (m < nClusters))
            m = m + 1;
            cm(m,:) = xi;
            c(i) = m;
        else
            c(i) = tocluster;
            cluster_elements = x(find(c==tocluster),:);
            cluster_elements_rows =  size(cluster_elements,1);
            cm(tocluster,:) = sum(cluster_elements, 1)/cluster_elements_rows;
        end
        
%         if i==8
%             break;
%         end
    end
end

