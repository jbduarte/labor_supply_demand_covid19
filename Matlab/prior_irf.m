% This program generates draws for D and B as well as IRF
%%% By Joao B. Duarte (2020)

% To be run after running main

%  The prior IRF is just (A^-1)^h

% ===========================================================
% Generate draws for D and B

psi = zeros(n,n,hmax+nlags);  
    % psi(:,:,hsim,isim) is n x n matrix of nonorthogonalized IRF
    % first nlags -1 elements are defined to be zero to use same recursion
       % for horizon hsim and draw isim
psi_invA = zeros(n,n,hmax+nlags);
    % psi_invA(:,:,hsim,isim) is n x n matrix of structural IRF
psi_invA_cum = zeros(n,n,hmax+nlags);

A = [0.6 1; -0.6 1];   

invA = inv(A);
phi_prior = [1 0 0 0 0 0 0 0 0 ; 0 1 0 0 0 0 0 0 0 ];
psi(:,:,nlags) = eye(n);
psi_invA(:,:,nlags) = invA;
psi_invA_cum(:,:,nlags) = invA;

hsim = 1;
   
while hsim < hmax
    ilags = 0;
        while ilags < nlags
            ilags = ilags+1;
            psi(:,:,nlags+hsim) = psi(:,:,nlags+hsim) ...
               + phi_prior(:,(ilags-1)*n+1:ilags*n)*psi(:,:,nlags+hsim-ilags);
        end
    psi_invA(:,:,nlags+hsim)=psi(:,:,nlags+hsim)*invA;    
    psi_invA_cum(:,:,nlags+hsim)=psi_invA_cum(:,:,nlags+hsim-1)+...
            psi_invA(:,:,nlags+hsim)*invA;
    hsim = hsim+1;
end

y = squeeze(psi_invA_cum(1,1,nlags:nlags+hmax-1));
HO=(0:1:hmax-1)';
plot(HO,y);






