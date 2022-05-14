[phi,psi,xval] = wavefun('db11',10);
a1 = subplot(121);
plot(xval,phi);
title('db11 Scaling Function');

ax = gca ;  
ax.Box = 'off'  ;  
xline(ax.XLim(2),'-k', 'linewidth',ax.LineWidth);  
yline(ax.YLim(2),'-k', 'linewidth',ax.LineWidth);


a2 = subplot(122);
plot(xval,psi);
title('db11 Wavelet');

ax = gca ;  
ax.Box = 'off'  ;  
xline(ax.XLim(2),'-k', 'linewidth',ax.LineWidth);  
yline(ax.YLim(2),'-k', 'linewidth',ax.LineWidth);

set(findobj(gcf,'type','axes'), 'tickdir',  'out',      ...
                                'xgrid',    'off',       ...
                                'xlimitmethod',  'tight',      ...
                                'fontname',  'Times New Roman',      ...
                                'ygrid',    'off',       ...
                                'box',      'off'       );
set(gcf,'color','w');

ax = gca ;  
ax.Box = 'off'  ;  
xline(ax.XLim(2),'-k', 'linewidth',ax.LineWidth);  
yline(ax.YLim(2),'-k', 'linewidth',ax.LineWidth);