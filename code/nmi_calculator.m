function [ nmi ] = nmi_calculator(label, cluster, nOfClass, nOfCluster)
%calculated the normalized mutual information for accuracy measure
    
    n = size(label,2);
    
    p = zeros(nOfClass,nOfCluster);
    
    H_x_y = 0;
    H_x = 0;
    H_y = 0;
    
    pi = zeros(nOfClass, 1);
    
    pj = zeros(nOfCluster, 1);
    
    for k=1:nOfClass
        
        c = (label==k);
        
        pi(k) = sum(c)/n;
    end
    
    for l=1:nOfCluster
        d = (cluster==l);
        
        pj(l) = sum(d)/n;
    end
    
    for i=1:nOfClass %number of class
        for j=1:nOfCluster %number of cluster
            a = (label==i);
            b = (cluster==j);
            p(i,j) = sum(a.*b)/n;
            if(p(i,j)==0)
                continue;
            end
            
            if(pj(l)==0)
                continue;
            end
            
            if(pi(k)==0)
                continue;
            end
            
            H_x_y = H_x_y + (-p(i,j)*log2(p(i,j)));
            H_x = H_x + (p(i,j)*log2(pi(i)));
            H_y =H_y + (p(i,j)*log2(pj(j)));
           
        end
    end
    H_x = -H_x;
    H_y = -H_y;
    
    
    MI = H_x + H_y - H_x_y;
    
    nmi = MI / sqrt(H_x * H_y);

end


