%%% Code to implement Metropolis Hastings 
%%% Authors: Christiane Baumeister and James D. Hamilton and modified
%%% by Joao B. Duarte 
%%% Last update: 13/5/2020

% to use this code to implement your own example, replace the calls to:
%     readData1 with your own code to read in Y and X matrix;
%     setPrior1 with your own code to set values for prior parameters;
%     setA with your own code to fill in the values for the matrix A
%     as a function of a vector of unknown parameters;

kexample=1;
ndraws=2e5;              %number of MH iterations 
nburn=1e5;               %number of burn-in draws 
    
%================================================
% This section reads in data in the form of
%      yall = full data set from which lags will be constructed
%      tstart = element of yall that will be obs 1 in regression
%      tend = element of yall that will be obs T in regression
%      T = number of usable observations for variable on LHS of regression
%        = tend - tstart + 1
%      YY = (T x n) matrix of T observations on each of n variables
%         = elements of yall for rows tstart through tend

% ==================================================
% construct matrix of lags 
%      XX = (T x k) matrix of observations on k different regressors
%    (this section should work as is for all applications)


T = size(YY,1);     % T is sample size
n = size(YY,2);     % n is number of equations

if nlags > 0
    XX = yall(tstart-1:tend-1,:);
    ilags = 1;
    while ilags < nlags
        ilags = ilags + 1;
        XX = [XX yall(tstart-ilags:tend-ilags,:)];
    end
    XX = [XX ones(T,1)];
else
    XX = ones(T,1);     % always include constant in XX 
end

k = size(XX,2);     % k is number of regressors

omegahat = (YY'*YY - YY'*XX*inv(XX'*XX)*XX'*YY)/T;
omegahat

%===========================================================
% set values that characterize the priors and how they will be plotted

nA = 2;   % nA is number of unknown elements in A
setPrior;
xbound = 3;    % absolute value of upper or lower bound for values of A for
  % distributions are to be plotted
ybound = 6;    % upper bound on density for which distribution to be plotted
steps = 0.01;   % increments at which density is evaluated for purposes of plotting priors
chsi = 1.3;   %tuning parameter to control acceptance rate


%===============================================================
% calculate variance-covariance matrix of univariate AR residuals

e = zeros(T,n);
i = 0;
while i < n
   i = i+1;
   if nlags > 0
      ylags = yall(tstart-1:tend-1,i);
      ilags = 1;
      while ilags < nlags
         ilags = ilags + 1;
         ylags = [ylags yall(tstart-ilags:tend-ilags,i)];
      end
      ylags = [ylags ones(T,1)];
   else
      ylags = ones(T,1);
   end
   e(:,i) = yall(tstart:tend,i) - ylags*inv(ylags'*ylags)*ylags'*yall(tstart:tend,i);
end
Sstar = e'*e/T;
Sstar

%============================================================
% Calculate inverse of Mtilde for standard Minn prior
v1 = 1:nlags;
v1 = v1'.^(-2*lambda1);
v2 = 1./diag(Sstar);
v3 = kron(v1,v2);
v3 = lambda0^2*[v3; lambda3^2];
v3 = 1./v3;
Mtildeinv = diag(v3);

%============================================================
% calculate parameters that characterize posteriors
%    (this section should not need to be changed for different
%    applications)

kappastar = kappa + (T/2); % posterior kappastar
ytilde = YY'*YY + eta*Mtildeinv*eta';
yxtilde = YY'*XX + eta*Mtildeinv;
xtildei = zeros(k,k,n);
i = 0;
while i < n
    i = i+1;
    if longA(i) == 0
        xtildei(:,:,i) = inv(XX'*XX + Mtildeinv);
    else
        xtildei(:,:,i) = inv(XX'*XX + Mtildeinv + Ri'*Ri/Vi);
    end
end


seednumber=140778;
rand('seed',seednumber);
randn('seed',seednumber);

%==================================================
% calculate prior densities to plot against posteriors

z1=-xbound:steps:xbound;  %grid for parameters to define points where density is evaluated
pdf_prior = zeros(nA,size(z1,2));

i = 0;
while i < nA
     i = i + 1;
     z2 = (z1 - cA(i))/sigA(i);
     if signA(i) == 1
 	pdf_prior(i,:) = ((z1 > 0.0) .* (tpdf(z2,nuA(i))/sigA(i))) / (1 - tcdf(-cA(i)/sigA(i),nuA(i)));
     elseif signA(i) == -1
	pdf_prior(i,:) = ((z1 < 0.0) .* (tpdf(z2,nuA(i))/sigA(i))) / tcdf(-cA(i)/sigA(i),nuA(i));
     elseif signA(i) == 0
	pdf_prior(i,:) = tpdf(z2,nuA(i)) / sigA(i);
     end 
end

%==================================================
% find posterior mode and hessian for scaling if desired
k_opt_scale = 1;   
	% k_opt_scale = 1 for optimal scaling
	% k_opt_scale = 0 for fixed scaling

if k_opt_scale == 1
   % create anonymous function whose only argument is theta
   A_params = [cA sigA nuA signA];
   f_anon = @(theta)post_val(theta,A_params,longA,kappa,T,kexample,omegahat,...
       Sstar,ytilde,xtildei,yxtilde,Ri,Vi)

   % find posterior mode
   theta_zero = cA;
   [theta_max,val_max,exitm,om,gm,hm] = fminunc(f_anon,theta_zero)
   'posterior mode is'
   theta_max

   % find hessian of log posterior
   if min(eig(inv(hm))) > 0
        opt_scale = chol(inv(hm))';
   else
         opt_scale = eye(nA);
   end

elseif k_opt_scale == 0
   opt_scale = eye(nA);
end


%==================================================
% RW-MH algorithm to generate A

naccept=0;
count=0;

% set initial value
   Q1 = zeros(n,1);
   a_old = theta_max;
   A = setA(a_old,kexample);
   Q = A*omegahat*A';
   tau = kappa.*diag(A*Sstar*A');
   zetastar = zeros(n,1);
   i = 0;
   while i < n
       i = i+1;
       ytildei = A(i,:)*ytilde*A(i,:)';
       yxtildei = A(i,:)*yxtilde;
       if longA(i) == 1
           ri = A(2,1);
           ytildei = ytildei + ri^2/Vi;
           yxtildei = yxtildei + ri*Ri/Vi;
       end
       zetastar(i) = ytildei - yxtildei*xtildei(:,:,i)*yxtildei';
   end
   zeta_old = zetastar;
   mstar_old = A*eta;
   
      ptarget_old = logP(a_old,cA,sigA,nuA,signA) + (T/2)*log(det(Q)) ...
       - kappastar'*log((2*tau/T) + zetastar/T) + kappa'*log(tau);
   
   
% Store posterior distribution (after burn-in)
a_post=zeros(nA,ndraws-nburn);
zeta_post=zeros(n,ndraws-nburn);
mstar_post=zeros(n,k,ndraws-nburn);

while count<ndraws 
    count=count+1;
    if (count/10000) == floor(count/10000)
        count
    end
    a_new=a_old+chsi*opt_scale*randn(nA,1)/sqrt(0.5*(randn(1)^2 + randn(1)^2));
 if min(sign(a_new).*signA) >= 0
	A = setA(a_new,kexample);
    Q = A*omegahat*A';
    tau = kappa.*diag(A*Sstar*A');
    zeta_new = zeros(n,1);
    mstar_new = zeros(n,k);
    i = 0;
    while i < n
       i = i+1;
       ytildei = A(i,:)*ytilde*A(i,:)';
       yxtildei = A(i,:)*yxtilde;
       if longA(i) == 1
           ri = A(2,1);
           ytildei = ytildei + ri^2/Vi;
           yxtildei = yxtildei + ri*Ri/Vi;
       end
       zeta_new(i) = ytildei - yxtildei*xtildei(:,:,i)*yxtildei';
       mstar_new(i,:) = yxtildei*xtildei(:,:,i);
    end
       	
        
	ptarget_new = logP(a_new,cA,sigA,nuA,signA) + (T/2)*log(det(Q)) ...
       - kappastar'*log((2*tau/T) + zeta_new/T) + kappa'*log(tau);
    
    accept=min([exp(ptarget_new - ptarget_old);1]);
       u=rand(1);                      %draw from a uniform distribution
       if u<=accept
          a_old=a_new;                %we retain the new draw
          zeta_old = zeta_new;
          mstar_old = mstar_new;
	  ptarget_old = ptarget_new;
          naccept=naccept+1;          %count the number of acceptances
       end
       
 end
   
 %Store results after burn-in    
    if count>nburn
        a_post(:,count-nburn)=a_old;
        zeta_post(:,count-nburn) = zeta_old;
        mstar_post(:,:,count-nburn) = mstar_old;
    end 
    
end

% Compute acceptance ratio of RW-MH algorithm
   acceptance_ratio=naccept/ndraws;
   disp(['Acceptance ratio:' num2str(acceptance_ratio)])

% Uncomment if want to analyze convergence of the chain
p1=0.1;   %first 10% of the sample (for Geweke's (1992) convergence diagnostic)
p2=0.5;   %last 50% of the sample
autoc = convergence_diagnostics(a_post,p1,p2);




