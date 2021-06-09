% =========================================
% Read in data

nlags = 4;  % this is number of lags in VAR
load data2.txt;   % 1970:Q1 to 2008:Q4
% col 1 = real GDP 
% col 2 = potential real GDP 
% col 3 = GDP deflator (not used)
% col 4 = CPI (not used)
% col 5 = PCE deflator
% col 6 = fed funds rate (average of 3 months during quarter)
gap = 100*(log(data2(5:end,1)) - log(data2(5:end,2)));
inf = 100*(log(data2(5:end,5)) - log(data2(1:end-4,5))); % inflation is year over year change in PCE deflator
ff = data2(5:end,6);
varnames = {' y'; ' \pi'; ' r'};
shocknames = {' supply'; ' demand'; ' monetary'};
varnames2 = char('y','\pi','r');
shocknames2 = char('supply','demand','monetary policy');
yall = [gap inf ff];
tstart = 61;    % start estimation with 1986:Q1
tend = size(yall,1) - 1;    % end estimation with 2008:Q3
YY = yall(tstart:tend,:);

% ===========================================
% Estimate reduced-form VAR
%      XX = (T x k) matrix of observations on k different regressors

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

Phat = chol(omegahat)';
Phat

Pihat = YY'*XX*inv(XX'*XX);
Pihat

nuse = 1;   % for checking let's just try one draw
kcum = 0;   % don't accumulate

invdDraw = zeros(n,nuse);
D = diag(Phat).*diag(Phat);
invdDraw(:,1) = 1./D;

invA = Phat*inv(diag(diag(Phat)));

Bdraw = zeros(n,k,nuse);    % draws for B go in as matrices
Bdraw(:,:,1) = inv(invA)*Pihat;
% ===========================================================
% Generate draws for D and B
'Generating draws for D and B'
isim = 0;

% ====================================================================
% calculate impulse-response function for each draw
hsim = 0;    % hsim is horizon being calculated
hmax = 61;    % hmax - 1 is the maximum horizon sought
if nlags == 0
    hmax = 1;
end


psi = zeros(n,n,hmax+nlags,nuse);  
    % psi(:,:,hsim,isim) is n x n matrix of nonorthogonalized IRF
    % first nlags -1 elements are defined to be zero to use same recursion
       % for horizon hsim and draw isim
psi_invA = zeros(n,n,hmax+nlags,nuse);
    % psi_invA(:,:,hsim,isim) is n x n matrix of structural IRF
  
phicheck = zeros(n,k);
isim = 0;
'Calculating impulse-response functions'
while isim < nuse
    isim = isim+1;
    psi(:,:,nlags,isim) = eye(n);
    psi_invA(:,:,nlags,isim) = invA;
    phi = invA*Bdraw(:,:,isim);
    phicheck = phicheck + phi;
    hsim = 1;
   
    while hsim < hmax
        ilags = 0;
        while ilags < nlags
            ilags = ilags+1;
            psi(:,:,nlags+hsim,isim) = psi(:,:,nlags+hsim,isim) ...
               + phi(:,(ilags-1)*n+1:ilags*n)*psi(:,:,nlags+hsim-ilags,isim);
        end
        if kcum == 0
          psi_invA(:,:,nlags+hsim,isim)=psi(:,:,nlags+hsim,isim)*invA;
        else
            psi_invA(:,:,nlags+hsim,isim)=psi_invA(:,:,nlags+hsim-1,isim)+...
                psi(:,:,nlags+hsim,isim)*invA;
        end
         hsim = hsim+1;
    end
    
    if (isim/10000) == floor(isim/10000)
        isim
    end
end


%'check: avg phi was'
%phicheck/nuse

% ===================================================================
% plot graphs of impulse response function

index1 = 1;  % round(0.025*nuse);
index2 = 1;   % round((1 - 0.025)*nuse);
HO=(0:1:hmax-1)';
figure(3)
for i = 1:n
   for j = 1:n
     subplot(n,n,j+(i-1)*n)
     plotPanel;
   end
end
