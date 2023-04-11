%ã…ç¿ïW0~180

figure
ax1 = axes('Position',[0.1 0.1 0.7 0.7]);
hold on
    
show_num = 1;
cc_num = size(properties(cc_group),1);

for str = char(sort(cellstr(properties(cc_group))))'
    show_num = show_num * depth_rate;
    [theta_cc,rho_cc]= cart2pol(cc_group.(matlab.lang.makeValidName(str'))(:,1),cc_group.(matlab.lang.makeValidName(str'))(:,2));
    theta_cc_deg = rad2deg(theta_cc);
    scatter(theta_cc_deg,rho_cc,2.0,'filled','MarkerFaceColor','magenta','MarkerFaceAlpha', show_num/(depth_rate^cc_num));
    %scatter(theta_cc_deg,rho_cc,2.0,'filled','MarkerFaceColor','magenta','MarkerFaceAlpha', show_num*0.02);
end
if isempty(check_boundary) == 0
    [theta_bound,rho_bound]= cart2pol(check_boundary(:,1),check_boundary(:,2));
    theta_bound_deg = rad2deg(theta_bound);
    scatter(theta_bound_deg,rho_bound,0.5,'filled','MarkerFaceColor','blue','MarkerFaceAlpha',1.0);
end

if isempty(vb) == 0
    [theta_vb,rho_vb]= cart2pol(vb(:,1),vb(:,2));
    theta_vb_deg =  rad2deg(theta_vb);
    scatter(theta_vb_deg,rho_vb,0.5,'filled','MarkerFaceColor','red','MarkerFaceAlpha',1.0);
end

axis on
axis equal
xlim([0 180])
axis 'auto y'
%ylim([0 180])
xticks([-180 -135 -90 -45 0 45 90 135 180])
xticklabels({'-ÉŒ','-3ÉŒ/4','-ÉŒ/2','-ÉŒ/4','0','ÉŒ/4','ÉŒ/2','3ÉŒ/4','ÉŒ'})
xlabel('theta [rad]')
ylabel('rho [mm]')
hold off

print(strcat('result/result_polor_half',sprintf(datestr(datetime('now'),'yyyy_mm_dd_HH_MM_ss_FFF'))),'-dpng','-r300')