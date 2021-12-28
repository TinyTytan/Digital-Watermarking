function out = hamming(a,b)
    out = nnz(xor(a,b));
end