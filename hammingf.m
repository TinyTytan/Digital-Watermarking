function out = hammingf(a,b)
    out = 1 - nnz(xor(a,b))/numel(a);
end