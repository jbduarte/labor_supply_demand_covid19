function A = setA(vecA,kexample)
% input: vector of unique elements of matrix A
% output: full matrix A
if kexample == 1
     A = [-vecA(1) 1; -vecA(2) 1];
elseif kexample == 2
     A = [1.0 -vecA(1) 0.0; 1.0 -vecA(2) -vecA(3); -vecA(4) -vecA(5) 1.0];
elseif kexample == 4
     A = [1.0 0.0 0.0; vecA(1) 1.0 0.0; vecA(2) vecA(3) 1.0];
end
end

