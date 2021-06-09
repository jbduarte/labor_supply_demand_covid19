%%% This program generates draws for historical decomposition
%%% Authors: Christiane Baumeister and James D. Hamilton and modified by
%%% Joao B. Duarte
%%% Last update: 13/5/2020

% To be run after running main_general.m and irf.m, which should have set variables including:
%  psi_invA = [n x n x (hmax+nlags) x nuse] array which includes structural
%     impulse-response matrices
%     dimension 1: variable affected
%     dimension 2: shock whose effect is sought
%     dimension 3: hmax + s component is effect of shock after s periods (s = 0,1,..,hmax-1)
%     dimension 4: indexes the Monte Carlo draw of the parameters
%  note psi_invA is the cumulation of IRFs if kcum = 1
%  YY = (T x n) matrix of observations on dependent variable
%  XX = (T x k) matrix of observations on explanatory variables
%  a_post = [na x (ndraws - nburn)] matrix of draws for elements that go into (n x n) matrix A
%  Bdraw = (n x k x nuse) array of draws for the (n x k) matrix B

% output:
% QH = (n x n x T x nuse) array of components of y attributable to each shock
%     dimension 1: variable affected
%     dimension 2: shock whose effect is sought
%     dimension 3: date of observation
%     dimension 4: indexes the Monte Carlo draw of the parameters

if subsectors == 0
    T = T+3; % to finish decomposition in May 2020
end

if subsectors == 1
    T = T+2; % to finish decomposition in April 2020
end

QH = zeros(n,n,T,nuse);
QHD = zeros(n,T,nuse);

if subsectors == 0
    YY = yall(tstart:tend+3,:);
    if nlags > 0
    XX = yall(tstart-1:tend+3-1,:);
    ilags = 1;
    while ilags < nlags
        ilags = ilags + 1;
        XX = [XX yall(tstart-ilags:tend+3-ilags,:)];
    end
    XX = [XX ones(T,1)];
    else
    XX = ones(T,1);     % always include constant in XX 
    end
end

if subsectors == 1
    YY = yall(tstart:tend+2,:);
    if nlags > 0
    XX = yall(tstart-1:tend+2-1,:);
    ilags = 1;
    while ilags < nlags
        ilags = ilags + 1;
        XX = [XX yall(tstart-ilags:tend+2-ilags,:)];
    end
    XX = [XX ones(T,1)];
    else
    XX = ones(T,1);     % always include constant in XX 
    end
end

% ===========================================================
% 'Generating draws for historical decomposition'
isim = 0;
while isim < nuse
    isim = isim + 1;
    if (isim/10000) == floor(isim/10000)
        isim
    end

    % ============================================================
    % construct U = (T x n) matrix containing history of structural residuals for this draw
    %A = inv(invA);   % delete this line when no longer in checking mode
    A = setA(a_post(:,isim),kexample);  %uncomment this when no longer
    %  in checking mode
    B = squeeze(Bdraw(:,:,isim));
    U = YY*A' - XX*B';

    for j = 1:n
        % =============================================
        % find historical contribution of structural shock j
        ulast = U(:,j);
        uj = zeros(T,n);
        for hsim = 0:hmax
            uj = uj + ulast*squeeze(psi_invA(:,j,nlags+hsim,isim))';
            ulast = [0; ulast(1:end-1)];
        end
    QH(:,j,:,isim) = uj';
    end
    QHD(:,:,isim) = QH(:,2,:,isim)-QH(:,1,:,isim);
end

% ============================================================
% calculate median and percentiles
index0 = round(0.5*nuse);
index1 = round(0.025*nuse);
index2 = round((1 - 0.025)*nuse);
index3 = round(0.16*nuse);
index4 = round((1 - 0.16)*nuse);



QH0 = zeros(n,n,T);
QH1 = zeros(n,n,T);
QH2 = zeros(n,n,T);

QHD0 = zeros(n,T);
QHD1 = zeros(n,T);
QHD2 = zeros(n,T);
QHD3 = zeros(n,T);
QHD4 = zeros(n,T);

for i = 1:n
    for j = 1:n
        for t = 1:T
           K = squeeze(QH(i,j,t,:));
           K = sort(K);
           QH0(i,j,t) = K(index0);
           QH1(i,j,t) = K(index1);
           QH2(i,j,t) = K(index2);
        end
    end
end

for i = 1:n
    for t = 1:T
       K = squeeze(QHD(i,t,:));
       K = sort(K);
       QHD0(i,t) = K(index0);
       QHD1(i,t) = K(index1);
       QHD2(i,t) = K(index2);
       QHD3(i,t) = K(index3);
       QHD4(i,t) = K(index4);
    end
end

% =========================================================
% Save hours results

if subsectors == 0
% save difference of historical shocks median, lower and upper bounds for
% hours
dlmwrite(strcat("../Shocks/Difference/", sector, "_hd_diff.txt"),QHD0(2,:));
dlmwrite(strcat("../Shocks/Difference/", sector, "_hdL_diff.txt"),QHD1(2,:));
dlmwrite(strcat("../Shocks/Difference/", sector, "_hdU_diff.txt"),QHD2(2,:));
dlmwrite(strcat("../Shocks/Difference/", sector, "_hdL2_diff.txt"),QHD3(2,:));
dlmwrite(strcat("../Shocks/Difference/", sector, "_hdU2_diff.txt"),QHD4(2,:));

% save difference of historical shocks median, lower and upper bounds for
% wages
dlmwrite(strcat("../Shocks/Difference/", sector, "_hd_diff_wages.txt"),QHD0(1,:));
dlmwrite(strcat("../Shocks/Difference/", sector, "_hdL_diff_wages.txt"),QHD1(1,:));
dlmwrite(strcat("../Shocks/Difference/", sector, "_hdU_diff_wages.txt"),QHD2(1,:));
dlmwrite(strcat("../Shocks/Difference/", sector, "_hdL_diff_wages.txt"),QHD3(1,:));
dlmwrite(strcat("../Shocks/Difference/", sector, "_hdU_diff_wages.txt"),QHD4(1,:));
    
% save demand and supply historical shocks  median, lower and upper bounds 
% for hours
dlmwrite(strcat("../Shocks/NAICS2/", sector, "_hd_demand.txt"),QH0(2,1,:));
dlmwrite(strcat("../Shocks/NAICS2/", sector, "_hd_supply.txt"),QH0(2,2,:));
dlmwrite(strcat("../Shocks/NAICS2/", sector, "_hdL_demand.txt"),QH1(2,1,:));
dlmwrite(strcat("../Shocks/NAICS2/", sector, "_hdL_supply.txt"),QH1(2,2,:));
dlmwrite(strcat("../Shocks/NAICS2/", sector, "_hdU_demand.txt"),QH2(2,1,:));
dlmwrite(strcat("../Shocks/NAICS2/", sector, "_hdU_supply.txt"),QH2(2,2,:));

% save demand and supply historical shocks  median, lower and upper bounds 
% for wages
dlmwrite(strcat("../Shocks/NAICS2/", sector, "_hd_demand_wages.txt"),QH0(1,1,:));
dlmwrite(strcat("../Shocks/NAICS2/", sector, "_hd_supply_wages.txt"),QH0(1,2,:));
dlmwrite(strcat("../Shocks/NAICS2/", sector, "_hdL_demand_wages.txt"),QH1(1,1,:));
dlmwrite(strcat("../Shocks/NAICS2/", sector, "_hdL_supply_wages.txt"),QH1(1,2,:));
dlmwrite(strcat("../Shocks/NAICS2/", sector, "_hdU_demand_wages.txt"),QH2(1,1,:));
dlmwrite(strcat("../Shocks/NAICS2/", sector, "_hdU_supply_wages.txt"),QH2(1,2,:));
end

if subsectors == 1
dlmwrite(strcat("../Shocks/NAICS3/", sector, "_hd_demand.txt"),QH0(2,1,:));
dlmwrite(strcat("../Shocks/NAICS3/", sector, "_hd_supply.txt"),QH0(2,2,:));
dlmwrite(strcat("../Shocks/NAICS3/", sector, "_hdL_demand.txt"),QH1(2,1,:));
dlmwrite(strcat("../Shocks/NAICS3/", sector, "_hdL_supply.txt"),QH1(2,2,:));
dlmwrite(strcat("../Shocks/NAICS3/", sector, "_hdU_demand.txt"),QH2(2,1,:));
dlmwrite(strcat("../Shocks/NAICS3/", sector, "_hdU_supply.txt"),QH2(2,2,:));

dlmwrite(strcat("../Shocks/NAICS3/", sector, "_hd_demand_wages.txt"),QH0(1,1,:));
dlmwrite(strcat("../Shocks/NAICS3/", sector, "_hd_supply_wages.txt"),QH0(1,2,:));
dlmwrite(strcat("../Shocks/NAICS3/", sector, "_hdL_demand_wages.txt"),QH1(1,1,:));
dlmwrite(strcat("../Shocks/NAICS3/", sector, "_hdL_supply_wages.txt"),QH1(1,2,:));
dlmwrite(strcat("../Shocks/NAICS3/", sector, "_hdU_demand_wages.txt"),QH2(1,1,:));
dlmwrite(strcat("../Shocks/NAICS3/", sector, "_hdU_supply_wages.txt"),QH2(1,2,:));
end



     

