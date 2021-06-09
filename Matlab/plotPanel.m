title_a = strcat('Response of',varnames(i),' to', shocknames(j));
x1 = (squeeze(psi_invA0(i,j,nlags:nlags+hmax-1,:)));
x1 = sort(x1,2);
temp1=[(median(x1,2)) x1(:,index1) x1(:,index2)];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax,1),'k:')
lowval = floor(min(x1(:,index1)));
highval = ceil(max(x1(:,index2)));
axis([0 (hmax-1) lowval highval])
set(gca,'XTick',0:5:40)
set(gca,'YTick',lowval:0.5:highval)
title(title_a,'fontsize',10)