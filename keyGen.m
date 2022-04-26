function key = keyGen(matrix,watermark)
watermark = wm_sizer(size(matrix,1),size(matrix,2),watermark,'zb');

key = xor(imbinarize(matrix), watermark);

end