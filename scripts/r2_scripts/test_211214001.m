%�ɍ��W0~180

figure
ax1 = axes('Position',[0.1 0.1 0.7 0.7]);
hold on
    
show_num = 1;
cc_num = size(properties(cc_group),1);

for str = char(sort(cellstr(properties(cc_group))))'
    
    for area_size = 1:size(area_unique_cc_group.(matlab.lang.makeValidName(str')))
        row=find(cc_group.(matlab.lang.makeValidName(str'))(:,3)==area_unique_cc_group.(matlab.lang.makeValidName(str'))(area_size,1));
        xryou=cc_group.(matlab.lang.makeValidName(str'))(row,1);
        yryou=cc_group.(matlab.lang.makeValidName(str'))(row,2);
        k = boundary(xryou,yryou,1.0);
        [theta_cc,rho_cc]=cart2pol(xryou(k),yryou(k));
        ryosuke=[theta_cc rho_cc];
        theta_cc=rad2deg(theta_cc);
        I = find(theta_cc==180);
        II = find(theta_cc==0);
        [sz_I,~] = size(I);
        theta_cc_test = theta_cc;
        if(str' == 'cc_01')
            AA_theta = theta_cc(1:I);
            AA_rho = rho_cc(1:I);
        elseif sz_I==2
            AA_theta = [-180;theta_cc(I(2)+1:end);theta_cc(1:I(1)-1);-180];
            AA_rho = [rho_cc(I(2));rho_cc(I(2)+1:end);rho_cc(1:I(1)-1);rho_cc(I(1))];
        end
        if(str' == 'cc_01')
            BB_theta = [-180;theta_cc(I+1:end)];
            BB_rho = [rho_cc(I);rho_cc(I+1:end)];
        elseif sz_I==2
            BB_theta = theta_cc(I(1):I(2));
            BB_rho = rho_cc(I(1):I(2));
        end
        if(str' == 'cc_01')
            theta_cc = [BB_theta;AA_theta];
            rho_cc = [BB_rho;AA_rho];
            theta_cc = [-180;theta_cc;180];
            rho_cc = [0;rho_cc;0];
        else
            if sz_I==2
                theta_cc = AA_theta;
                rho_cc = AA_rho;
                %theta_cc = [180;BB_theta;180];
                %rho_cc = [BB_rho(1);BB_rho;BB_rho(end)];
                
            else
                theta_cc = [theta_cc];
                rho_cc = [rho_cc];
            end
        end
        ryosuke=[theta_cc rho_cc];
        
        if (str' == 'cc_01')
            plot(theta_cc,rho_cc);
            fill(theta_cc,rho_cc,'y')
        end
        if (str' == 'cc_02')
            if sz_I==2
                plot(AA_theta,AA_rho);
                fill(AA_theta,AA_rho,'g')
                plot(BB_theta,BB_rho);
                fill(BB_theta,BB_rho,'g')
            else
                plot(theta_cc,rho_cc);
                fill(theta_cc,rho_cc,'g')
            end
        end
        if (str' == 'cc_03')
            if sz_I==2
                plot(AA_theta,AA_rho);
                fill(AA_theta,AA_rho,'m')
                plot(BB_theta,BB_rho);
                fill(BB_theta,BB_rho,'m')
            else
                plot(theta_cc,rho_cc);
                fill(theta_cc,rho_cc,'m')
            end
        end
    end
        
end

if isempty(check_boundary) == 0
    [theta_bound,rho_bound]= cart2pol(check_boundary(:,1),check_boundary(:,2));
    theta_bound_deg = rad2deg(theta_bound);
    scatter(theta_bound_deg,rho_bound,5.0,'filled','MarkerFaceColor','blue','MarkerFaceAlpha',1.0);
end

if isempty(vb) == 0
    [theta_vb,rho_vb]= cart2pol(vb(:,1),vb(:,2));
    theta_vb_deg =  rad2deg(theta_vb);
    scatter(theta_vb_deg,rho_vb,5.0,'filled','MarkerFaceColor','red','MarkerFaceAlpha',1.0);
end

axis on
axis equal
xlim([0 180])
ylim([0 180])
xticks([-180 -135 -90 -45 0 45 90 135 180])
xticklabels({'-��','-3��/4','-��/2','-��/4','0','��/4','��/2','3��/4','��'})
xlabel('theta [rad]')
ylabel('rho [mm]')
hold off

%print(strcat('result/result_polor_half',sprintf(datestr(datetime('now'),'yyyy_mm_dd_HH_MM_ss_FFF'))),'-dpng','-r300')