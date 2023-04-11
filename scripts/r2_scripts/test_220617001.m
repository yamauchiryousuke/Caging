c_cls_boundary = boundary(c_cls.Location(:,1),c_cls.Location(:,2),1);
c_cls_outline = c_cls.Location(c_cls_boundary,1:2);
figure
scatter(c_cls_outline(:,1),c_cls_outline(:,2),'filled')
figure
c_cls_outline_double = c_cls_outline*2;
scatter(c_cls_outline_double(:,1),c_cls_outline_double(:,2),'filled')