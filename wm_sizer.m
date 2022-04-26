function [wm_out] = wm_sizer(in_mtx_h,in_mtx_w,wm_in,type)

cRows = in_mtx_h;
if strcmp(type,'dh')
    cCols = in_mtx_w/3;
elseif strcmp(type,'zb')
    cCols = in_mtx_w;
end

constrSquare = min(cRows,cCols);
wm_in = imresize(wm_in,[constrSquare constrSquare]);

if cRows < cCols % if matrix is wide
    wm_in = repmat(wm_in, 1, 30);
    wm_in = imcrop(wm_in, [0 0 cCols constrSquare]);

elseif cCols < cRows % if matrix is tall
    wm_in = repmat(wm_in, 30, 1);
    wm_in = imcrop(wm_in, [0 0 constrSquare cRows]);

end

wm_out = wm_in;
end

