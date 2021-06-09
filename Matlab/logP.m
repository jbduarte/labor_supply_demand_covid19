function prion=logP(vecA,cA,sigA,nuA,signA)
% ===================================================
% By Christiane Baumeister and James D. Hamilton (Sept 2013)
% returns log of prior evaluated at the point vecA
% cA = vector of location params
% sigA = vector of scale params
% nuA = vector of degrees of freedom
% signA(i) = 1 if element i restricted to be positive
%          = -1 if element i restricted to be negative
%          = 0  if element i not restricted
% ===================================================
x = (vecA - cA)./sigA;
fpdf = tpdf(x,nuA)./sigA;
Fcdf = 0.5*(1 + (1 - abs(signA)) + signA) - signA.*tcdf(-cA./sigA,nuA);
prion = sum(log(fpdf) - log(Fcdf));
