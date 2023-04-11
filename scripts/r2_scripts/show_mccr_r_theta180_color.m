%ã…ç¿ïW0~180

figure
ax1 = axes('Position',[0.1 0.1 0.7 0.7]);
hold on
    
show_num = 1;
cc_num = size(properties(cc_group),1);

for str = char(sort(cellstr(properties(cc_group))))'
    show_num = show_num * depth_rate;
    polar_cc_group.(matlab.lang.makeValidName(sprintf('%s',str))) = double.empty;
    [polar_cc_group.(matlab.lang.makeValidName(sprintf(str')))(:,1),polar_cc_group.(matlab.lang.makeValidName(sprintf(str')))(:,2)] = cart2pol(cc_group.(matlab.lang.makeValidName(str'))(:,1),cc_group.(matlab.lang.makeValidName(str'))(:,2));
    polar_cc_group.(matlab.lang.makeValidName(sprintf(str')))(:,1) = rad2deg(polar_cc_group.(matlab.lang.makeValidName(sprintf(str')))(:,1));
    
    if (str' == 'cc_01')
        scatter(polar_cc_group.(matlab.lang.makeValidName(sprintf(str')))(:,1),polar_cc_group.(matlab.lang.makeValidName(sprintf(str')))(:,2),2.0,'filled','MarkerFaceColor','#F9F790','MarkerFaceAlpha', 1.0);
        %fill(theta_cc_deg(k),rho_cc(k),'m');%k = convhull(polar_cc_group.(matlab.lang.makeValidName(sprintf(str')))(:,1),polar_cc_group.(matlab.lang.makeValidName(sprintf(str')))(:,2));
        xryou=cc_group.(matlab.lang.makeValidName(str'))(:,1);
        %xryou=polar_cc_group.(matlab.lang.makeValidName(sprintf(str')))(:,1);
        yryou=cc_group.(matlab.lang.makeValidName(str'))(:,2);
        %yryou=polar_cc_group.(matlab.lang.makeValidName(sprintf(str')))(:,2);
        k = boundary(xryou,yryou,1.0);
        %theta_cc=xryou(k);
        %rho_cc=yryou(k);
        [theta_cc,rho_cc]=cart2pol(xryou(k),yryou(k));
        ryosuke=[theta_cc rho_cc];
        theta_cc=rad2deg(theta_cc);
        [M,I] = max(theta_cc);
        AA_theta = theta_cc(1:I);
        AA_rho = rho_cc(1:I);
        BB_theta = theta_cc(I+1:end);
        BB_rho = rho_cc(I+1:end);
        theta_cc = [BB_theta;AA_theta];
        rho_cc = [BB_rho;AA_rho];
        theta_cc = [-180;theta_cc;180];
        rho_cc = [0;rho_cc;0];
        ryosuke=[theta_cc rho_cc];
        plot(theta_cc,rho_cc);
        fill(theta_cc,rho_cc,'y')
    end
    if (str' == 'cc_02')
        xryou=cc_group.(matlab.lang.makeValidName(str'))(:,1);
        %xryou=polar_cc_group.(matlab.lang.makeValidName(sprintf(str')))(:,1);
        yryou=cc_group.(matlab.lang.makeValidName(str'))(:,2);
        %yryou=polar_cc_group.(matlab.lang.makeValidName(sprintf(str')))(:,2);
        k = boundary(xryou,yryou,1.0);
        %theta_cc=xryou(k);
        %rho_cc=yryou(k);
        [theta_cc,rho_cc]=cart2pol(xryou(k),yryou(k));
        ryosuke=[theta_cc rho_cc];
        theta_cc=rad2deg(theta_cc);
        [M,I] = max(theta_cc);
        AA_theta = theta_cc(1:I);
        AA_rho = rho_cc(1:I);
        BB_theta = theta_cc(I+1:end);
        BB_rho = rho_cc(I+1:end);
        theta_cc = [BB_theta;AA_theta];
        rho_cc = [BB_rho;AA_rho];
        ryosuke=[theta_cc rho_cc];
        plot(theta_cc,rho_cc);
        fill(theta_cc,rho_cc,'g')
    end
    if (str' == 'cc_03')
        scatter(polar_cc_group.(matlab.lang.makeValidName(sprintf(str')))(:,1),polar_cc_group.(matlab.lang.makeValidName(sprintf(str')))(:,2),2.0,'filled','MarkerFaceColor','#DB7307','MarkerFaceAlpha', 1.0);
        %fill(theta_cc_deg(k),rho_cc(k),'m');
    end
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
ylim([0 180])
xticks([-180 -135 -90 -45 0 45 90 135 180])
xticklabels({'-ÉŒ','-3ÉŒ/4','-ÉŒ/2','-ÉŒ/4','0','ÉŒ/4','ÉŒ/2','3ÉŒ/4','ÉŒ'})
xlabel('theta [rad]')
ylabel('rho [mm]')
hold off

%print(strcat('result/result_polor_half',sprintf(datestr(datetime('now'),'yyyy_mm_dd_HH_MM_ss_FFF'))),'-dpng','-r300')