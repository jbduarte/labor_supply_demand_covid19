nlags = 4;  % this is number of lags in VAR
kcum = 1;   % This will accumulate IRFs and var decomps

if subsectors == 0 && production == 0
file = strcat("../Data/NAICS2/All/", sector, "_data.csv");
end
if subsectors == 0 && production == 1
file = strcat("../Data/NAICS2/Production_only/", sector, "_data.csv");
end
if subsectors == 1
file = strcat("../Data/NAICS3/", sector, "_data.csv");
end

data = readtable(file);
data = data{:,:};
% col 1 = date 
% col 2 = real earnings
% col 3 = hours 
wage = 100*(log(data(2:end,2)) - log(data(1:end-1,2)));
employment = 100*(log(data(2:end,3)) - log(data(1:end-1,3)));

varnames = {' wage'; ' employment'};
shocknames = {' demand'; ' supply'};
yall = [wage employment];
tstart = 5;    % start estimation with 2006:M07

if subsectors == 0
    tend = size(yall,1)-3;    % end estimation with 2020:M02
    YY = yall(tstart:tend,:);
    date_start = 2006+7/12;
    date_end = 2020+4/12;   % end HD with 2020:M05
    time = (date_start:1/12:date_end)';
end

if subsectors == 1
    if ii == 47 
        yall = yall(1:207,:);
        tend = size(yall,1)-2;    % end estimation with 2020:M02
        YY = yall(tstart:tend,:);
        date_start = 2003+7/12;
        date_end = 2020+3/12;   % end HD with 2020:M04
        time = (date_start:1/12:date_end)';
    else
        yall = yall(1:363,:);
        tend = size(yall,1)-2;    % end estimation with 2020:M02
        YY = yall(tstart:tend,:);
        date_start = 1990+7/12;
        date_end = 2020+3/12;   % end HD with 2020:M04
        time = (date_start:1/12:date_end)';
    end
end


